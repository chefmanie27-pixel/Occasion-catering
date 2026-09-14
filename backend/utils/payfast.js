const crypto = require('crypto');
const https = require('https');

const MODE = (process.env.PAYFAST_MODE || 'sandbox').toLowerCase();

const PROCESS_URL =
  MODE === 'live'
    ? 'https://www.payfast.co.za/eng/process'
    : 'https://sandbox.payfast.co.za/eng/process';

const VALIDATE_HOST =
  MODE === 'live' ? 'www.payfast.co.za' : 'sandbox.payfast.co.za';

// PayFast wants standard URL-encoding but with spaces as '+' (like PHP's
// urlencode), and the signature string built from fields IN THE ORDER THEY
// WERE ADDED to the payload (not sorted alphabetically). This matters both
// when we build the outgoing signature and when we verify an inbound ITN,
// where we must walk req.body's keys in the order PayFast sent them.
// PayFast's signature check is generated server-side with PHP's urlencode(),
// which escapes everything except A-Z a-z 0-9 - _ . (and turns space into
// '+'). JS's encodeURIComponent leaves ! ~ * ' ( ) unescaped, so those need
// fixing up by hand to match PHP byte-for-byte, or the signature won't
// reproduce what PayFast recomputes on their end.
function pfEncode(value) {
  return encodeURIComponent(String(value).trim())
    .replace(/%20/g, '+')
    .replace(/[!'()*~]/g, (c) => '%' + c.charCodeAt(0).toString(16).toUpperCase());
}

function buildSignature(fields, passphrase) {
  let pairs = Object.entries(fields)
    .filter(([key, value]) => key !== 'signature' && value !== undefined && value !== null && value !== '')
    .map(([key, value]) => `${key}=${pfEncode(value)}`);

  if (passphrase) {
    pairs.push(`passphrase=${pfEncode(passphrase)}`);
  }

  const paramString = pairs.join('&');
  return crypto.createHash('md5').update(paramString).digest('hex');
}

// Builds the full field set for a "pay now" redirect and appends the
// signature. Field insertion order matches PayFast's documented order
// (merchant details -> return/cancel/notify -> buyer details -> transaction
// details -> custom fields) since the signature is order-sensitive.
function buildPaymentFields({
  merchantId,
  merchantKey,
  returnUrl,
  cancelUrl,
  notifyUrl,
  nameFirst,
  nameLast,
  emailAddress,
  mPaymentId,
  amount,
  itemName,
  itemDescription,
  customStr1,
}) {
  const fields = {
    merchant_id: merchantId,
    merchant_key: merchantKey,
    return_url: returnUrl,
    cancel_url: cancelUrl,
    notify_url: notifyUrl,
  };

  if (nameFirst) fields.name_first = nameFirst;
  if (nameLast) fields.name_last = nameLast;
  if (emailAddress) fields.email_address = emailAddress;

  fields.m_payment_id = mPaymentId;
  fields.amount = Number(amount).toFixed(2);
  fields.item_name = itemName;
  if (itemDescription) fields.item_description = itemDescription;
  if (customStr1) fields.custom_str1 = customStr1;

  const passphrase = process.env.PAYFAST_PASSPHRASE || '';
  fields.signature = buildSignature(fields, passphrase);

  return fields;
}

// Recomputes the signature from an inbound ITN payload the same way
// PayFast does, then compares to the signature it sent. req.body's key
// order (as parsed by express.urlencoded) matches the order the form
// fields arrived in, which is what PayFast used to sign.
function verifyItnSignature(payload) {
  if (!payload || !payload.signature) return false;
  const passphrase = process.env.PAYFAST_PASSPHRASE || '';
  const expected = buildSignature(payload, passphrase);

  // TEMP DEBUG — remove once signature matching is confirmed working
  if (expected !== payload.signature) {
    const pairs = Object.entries(payload)
      .filter(([key, value]) => key !== 'signature' && value !== undefined && value !== null && value !== '')
      .map(([key, value]) => `${key}=${pfEncode(value)}`);
    if (passphrase) pairs.push(`passphrase=${pfEncode(passphrase)}`);
    console.log('DEBUG signature paramString:', pairs.join('&'));
    console.log('DEBUG expected:', expected, 'received:', payload.signature);
    console.log('DEBUG passphrase length:', passphrase.length, JSON.stringify(passphrase));
  }

  return expected === payload.signature;
}

// Server-to-server confirmation: post the raw ITN body back to PayFast's
// validate endpoint. PayFast responds with the plain text "VALID" or
// "INVALID". This is the second of PayFast's three recommended ITN checks
// (signature match, source-of-request validation, amount match) and
// protects against spoofed notify calls that merely guess a valid signature.
function validateWithPayFast(rawBody) {
  return new Promise((resolve) => {
    const postData = rawBody;
    const req = https.request(
      {
        hostname: VALIDATE_HOST,
        path: '/eng/query/validate',
        method: 'POST',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Content-Length': Buffer.byteLength(postData),
        },
        timeout: 8000,
      },
      (res) => {
        let data = '';
        res.on('data', (chunk) => (data += chunk));
        res.on('end', () => resolve(data.trim() === 'VALID'));
      },
    );
    req.on('error', () => resolve(false));
    req.on('timeout', () => {
      req.destroy();
      resolve(false);
    });
    req.write(postData);
    req.end();
  });
}

module.exports = {
  PROCESS_URL,
  buildSignature,
  buildPaymentFields,
  verifyItnSignature,
  validateWithPayFast,
};