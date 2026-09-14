-- seed.sql — equivalent of seed.js, safe to re-run (skips existing rows)


-- Categories

INSERT INTO categories (name)
SELECT 'Weddings' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE name = 'Weddings');

INSERT INTO categories (name)
SELECT 'Corporate' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE name = 'Corporate');

INSERT INTO categories (name)
SELECT 'Private Dinners' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE name = 'Private Dinners');

INSERT INTO categories (name)
SELECT 'Tours' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE name = 'Tours');


-- Catering Packages

INSERT INTO catering_packages (category_id, name, description, base_price, event_size, image_url, guests_label, courses_label, feature_label, badge, is_featured)
SELECT c.category_id, 'Executive Wedding', 'Full-service plated dining with a dedicated coordinator on the day.', 200.0, 'large', 'https://images.unsplash.com/photo-1519741497674-611481863552?auto=format&fit=crop&w=600&q=80', '50+ Guests', '3 Courses', 'Setup Included', 'Popular', 1
FROM categories c
WHERE c.name = 'Weddings'
AND NOT EXISTS (
  SELECT 1 FROM catering_packages cp WHERE cp.name = 'Executive Wedding' AND cp.category_id = c.category_id
);

INSERT INTO catering_packages (category_id, name, description, base_price, event_size, image_url, guests_label, courses_label, feature_label, badge, is_featured)
SELECT c.category_id, 'Corporate Brunch', 'Buffet-style brunch spread built for meetings, launches, and offsites.', 150.0, 'small', 'https://images.unsplash.com/photo-1555244162-803834f70033?auto=format&fit=crop&w=600&q=80', '30+ Guests', '2 Courses', 'Setup Included', NULL, 0
FROM categories c
WHERE c.name = 'Corporate'
AND NOT EXISTS (
  SELECT 1 FROM catering_packages cp WHERE cp.name = 'Corporate Brunch' AND cp.category_id = c.category_id
);

INSERT INTO catering_packages (category_id, name, description, base_price, event_size, image_url, guests_label, courses_label, feature_label, badge, is_featured)
SELECT c.category_id, 'Signature Private', 'An intimate, chef-led tasting menu served in your own space.', 300.0, 'small', 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?auto=format&fit=crop&w=600&q=80', '80+ Guests', '3 Courses', 'Premium Service', 'New', 1
FROM categories c
WHERE c.name = 'Private Dinners'
AND NOT EXISTS (
  SELECT 1 FROM catering_packages cp WHERE cp.name = 'Signature Private' AND cp.category_id = c.category_id
);

INSERT INTO catering_packages (category_id, name, description, base_price, event_size, image_url, guests_label, courses_label, feature_label, badge, is_featured)
SELECT c.category_id, 'Winelands Harvest', 'Farm-style sharing platters, delivered en route for tour groups.', 250.0, 'tour', 'https://images.unsplash.com/photo-1506377247377-2a5b3b417ebb?auto=format&fit=crop&w=600&q=80', '40+ Guests', '2 Courses', 'Delivery Included', NULL, 1
FROM categories c
WHERE c.name = 'Tours'
AND NOT EXISTS (
  SELECT 1 FROM catering_packages cp WHERE cp.name = 'Winelands Harvest' AND cp.category_id = c.category_id
);

INSERT INTO catering_packages (category_id, name, description, base_price, event_size, image_url, guests_label, courses_label, feature_label, badge, is_featured)
SELECT c.category_id, 'Garden Celebration', 'Relaxed outdoor-friendly menu with vegetarian and vegan options built in.', 180.0, 'large', 'https://images.unsplash.com/photo-1464366400600-7168b8af9bc3?auto=format&fit=crop&w=600&q=80', '60+ Guests', '3 Courses', 'Setup Included', NULL, 0
FROM categories c
WHERE c.name = 'Weddings'
AND NOT EXISTS (
  SELECT 1 FROM catering_packages cp WHERE cp.name = 'Garden Celebration' AND cp.category_id = c.category_id
);

INSERT INTO catering_packages (category_id, name, description, base_price, event_size, image_url, guests_label, courses_label, feature_label, badge, is_featured)
SELECT c.category_id, 'Boardroom Lunch', 'Individually boxed lunches with allergen labelling for larger teams.', 120.0, 'small', 'https://images.unsplash.com/photo-1600891964092-4316c288032e?auto=format&fit=crop&w=600&q=80', '10+ Guests', '1 Course', 'Delivery Included', NULL, 1
FROM categories c
WHERE c.name = 'Corporate'
AND NOT EXISTS (
  SELECT 1 FROM catering_packages cp WHERE cp.name = 'Boardroom Lunch' AND cp.category_id = c.category_id
);

INSERT INTO catering_packages (category_id, name, description, base_price, event_size, image_url, guests_label, courses_label, feature_label, badge, is_featured)
SELECT c.category_id, 'Candlelit Anniversary', 'A five-course set menu for two, plated course by course at home.', 450.0, 'small', 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?auto=format&fit=crop&w=600&q=80', '2+ Guests', '5 Courses', 'Premium Service', NULL, 0
FROM categories c
WHERE c.name = 'Private Dinners'
AND NOT EXISTS (
  SELECT 1 FROM catering_packages cp WHERE cp.name = 'Candlelit Anniversary' AND cp.category_id = c.category_id
);

INSERT INTO catering_packages (category_id, name, description, base_price, event_size, image_url, guests_label, courses_label, feature_label, badge, is_featured)
SELECT c.category_id, 'Safari Sundowner', 'Canapés and drinks service timed to golden hour game drives.', 220.0, 'tour', 'https://images.unsplash.com/photo-1516426122078-c23e76319801?auto=format&fit=crop&w=600&q=80', '20+ Guests', '2 Courses', 'Delivery Included', 'New', 0
FROM categories c
WHERE c.name = 'Tours'
AND NOT EXISTS (
  SELECT 1 FROM catering_packages cp WHERE cp.name = 'Safari Sundowner' AND cp.category_id = c.category_id
);


-- Menu Items

INSERT INTO menu_items (package_id, name, description, course_type, dietary_tags, price_addon, is_default)
SELECT cp.package_id, 'Butternut & Sage Soup', NULL, 'starter', '["veg", "halal"]', 0.00, 1
FROM catering_packages cp
WHERE cp.name = 'Executive Wedding'
AND NOT EXISTS (
  SELECT 1 FROM menu_items mi WHERE mi.name = 'Butternut & Sage Soup' AND mi.package_id = cp.package_id
);

INSERT INTO menu_items (package_id, name, description, course_type, dietary_tags, price_addon, is_default)
SELECT cp.package_id, 'Biltong & Fig Salad', NULL, 'starter', '["halal"]', 0.00, 1
FROM catering_packages cp
WHERE cp.name = 'Executive Wedding'
AND NOT EXISTS (
  SELECT 1 FROM menu_items mi WHERE mi.name = 'Biltong & Fig Salad' AND mi.package_id = cp.package_id
);

INSERT INTO menu_items (package_id, name, description, course_type, dietary_tags, price_addon, is_default)
SELECT cp.package_id, 'Roasted Beet Carpaccio', NULL, 'starter', '["veg", "gf", "halal"]', 0.00, 1
FROM catering_packages cp
WHERE cp.name = 'Executive Wedding'
AND NOT EXISTS (
  SELECT 1 FROM menu_items mi WHERE mi.name = 'Roasted Beet Carpaccio' AND mi.package_id = cp.package_id
);

INSERT INTO menu_items (package_id, name, description, course_type, dietary_tags, price_addon, is_default)
SELECT cp.package_id, 'Slow-Roasted Lamb Shoulder', NULL, 'main', '["gf", "halal"]', 0.00, 1
FROM catering_packages cp
WHERE cp.name = 'Executive Wedding'
AND NOT EXISTS (
  SELECT 1 FROM menu_items mi WHERE mi.name = 'Slow-Roasted Lamb Shoulder' AND mi.package_id = cp.package_id
);

INSERT INTO menu_items (package_id, name, description, course_type, dietary_tags, price_addon, is_default)
SELECT cp.package_id, 'Pan-Seared Kingklip', NULL, 'main', '["gf", "halal"]', 0.00, 1
FROM catering_packages cp
WHERE cp.name = 'Executive Wedding'
AND NOT EXISTS (
  SELECT 1 FROM menu_items mi WHERE mi.name = 'Pan-Seared Kingklip' AND mi.package_id = cp.package_id
);

INSERT INTO menu_items (package_id, name, description, course_type, dietary_tags, price_addon, is_default)
SELECT cp.package_id, 'Wild Mushroom Risotto', NULL, 'main', '["veg", "halal"]', 0.00, 1
FROM catering_packages cp
WHERE cp.name = 'Executive Wedding'
AND NOT EXISTS (
  SELECT 1 FROM menu_items mi WHERE mi.name = 'Wild Mushroom Risotto' AND mi.package_id = cp.package_id
);

INSERT INTO menu_items (package_id, name, description, course_type, dietary_tags, price_addon, is_default)
SELECT cp.package_id, 'Free-Range Chicken Ballotine', NULL, 'main', '["halal"]', 0.00, 1
FROM catering_packages cp
WHERE cp.name = 'Executive Wedding'
AND NOT EXISTS (
  SELECT 1 FROM menu_items mi WHERE mi.name = 'Free-Range Chicken Ballotine' AND mi.package_id = cp.package_id
);

INSERT INTO menu_items (package_id, name, description, course_type, dietary_tags, price_addon, is_default)
SELECT cp.package_id, 'Malva Pudding & Custard', NULL, 'dessert', '["veg", "halal"]', 0.00, 1
FROM catering_packages cp
WHERE cp.name = 'Executive Wedding'
AND NOT EXISTS (
  SELECT 1 FROM menu_items mi WHERE mi.name = 'Malva Pudding & Custard' AND mi.package_id = cp.package_id
);

INSERT INTO menu_items (package_id, name, description, course_type, dietary_tags, price_addon, is_default)
SELECT cp.package_id, 'Dark Chocolate Torte', NULL, 'dessert', '["veg", "gf", "halal"]', 0.00, 1
FROM catering_packages cp
WHERE cp.name = 'Executive Wedding'
AND NOT EXISTS (
  SELECT 1 FROM menu_items mi WHERE mi.name = 'Dark Chocolate Torte' AND mi.package_id = cp.package_id
);

INSERT INTO menu_items (package_id, name, description, course_type, dietary_tags, price_addon, is_default)
SELECT cp.package_id, 'Vanilla Bean Wedding Cake Slice', NULL, 'dessert', '["veg", "halal"]', 0.00, 1
FROM catering_packages cp
WHERE cp.name = 'Executive Wedding'
AND NOT EXISTS (
  SELECT 1 FROM menu_items mi WHERE mi.name = 'Vanilla Bean Wedding Cake Slice' AND mi.package_id = cp.package_id
);

INSERT INTO menu_items (package_id, name, description, course_type, dietary_tags, price_addon, is_default)
SELECT cp.package_id, 'Fresh Fruit & Granola Cups', NULL, 'starter', '["veg", "vegan", "gf", "halal"]', 0.00, 1
FROM catering_packages cp
WHERE cp.name = 'Corporate Brunch'
AND NOT EXISTS (
  SELECT 1 FROM menu_items mi WHERE mi.name = 'Fresh Fruit & Granola Cups' AND mi.package_id = cp.package_id
);

INSERT INTO menu_items (package_id, name, description, course_type, dietary_tags, price_addon, is_default)
SELECT cp.package_id, 'Mini Croissants & Danish Pastries', NULL, 'starter', '["veg", "halal"]', 0.00, 1
FROM catering_packages cp
WHERE cp.name = 'Corporate Brunch'
AND NOT EXISTS (
  SELECT 1 FROM menu_items mi WHERE mi.name = 'Mini Croissants & Danish Pastries' AND mi.package_id = cp.package_id
);

INSERT INTO menu_items (package_id, name, description, course_type, dietary_tags, price_addon, is_default)
SELECT cp.package_id, 'Smoked Salmon Bagel Bites', NULL, 'starter', '["halal"]', 0.00, 1
FROM catering_packages cp
WHERE cp.name = 'Corporate Brunch'
AND NOT EXISTS (
  SELECT 1 FROM menu_items mi WHERE mi.name = 'Smoked Salmon Bagel Bites' AND mi.package_id = cp.package_id
);

INSERT INTO menu_items (package_id, name, description, course_type, dietary_tags, price_addon, is_default)
SELECT cp.package_id, 'Baked Eggs Florentine', NULL, 'main', '["veg", "halal"]', 0.00, 1
FROM catering_packages cp
WHERE cp.name = 'Corporate Brunch'
AND NOT EXISTS (
  SELECT 1 FROM menu_items mi WHERE mi.name = 'Baked Eggs Florentine' AND mi.package_id = cp.package_id
);

INSERT INTO menu_items (package_id, name, description, course_type, dietary_tags, price_addon, is_default)
SELECT cp.package_id, 'Beef Rasher & Cheese Frittata', NULL, 'main', '["gf", "halal"]', 0.00, 1
FROM catering_packages cp
WHERE cp.name = 'Corporate Brunch'
AND NOT EXISTS (
  SELECT 1 FROM menu_items mi WHERE mi.name = 'Beef Rasher & Cheese Frittata' AND mi.package_id = cp.package_id
);

INSERT INTO menu_items (package_id, name, description, course_type, dietary_tags, price_addon, is_default)
SELECT cp.package_id, 'Avocado & Halloumi Toast', NULL, 'main', '["veg", "halal"]', 0.00, 1
FROM catering_packages cp
WHERE cp.name = 'Corporate Brunch'
AND NOT EXISTS (
  SELECT 1 FROM menu_items mi WHERE mi.name = 'Avocado & Halloumi Toast' AND mi.package_id = cp.package_id
);

INSERT INTO menu_items (package_id, name, description, course_type, dietary_tags, price_addon, is_default)
SELECT cp.package_id, 'Chicken & Waffle Sliders', NULL, 'main', '["halal"]', 0.00, 1
FROM catering_packages cp
WHERE cp.name = 'Corporate Brunch'
AND NOT EXISTS (
  SELECT 1 FROM menu_items mi WHERE mi.name = 'Chicken & Waffle Sliders' AND mi.package_id = cp.package_id
);

INSERT INTO menu_items (package_id, name, description, course_type, dietary_tags, price_addon, is_default)
SELECT cp.package_id, 'Lemon Yoghurt Muffins', NULL, 'dessert', '["veg", "halal"]', 0.00, 1
FROM catering_packages cp
WHERE cp.name = 'Corporate Brunch'
AND NOT EXISTS (
  SELECT 1 FROM menu_items mi WHERE mi.name = 'Lemon Yoghurt Muffins' AND mi.package_id = cp.package_id
);

INSERT INTO menu_items (package_id, name, description, course_type, dietary_tags, price_addon, is_default)
SELECT cp.package_id, 'Seasonal Fruit Platter', NULL, 'dessert', '["veg", "vegan", "gf", "halal"]', 0.00, 1
FROM catering_packages cp
WHERE cp.name = 'Corporate Brunch'
AND NOT EXISTS (
  SELECT 1 FROM menu_items mi WHERE mi.name = 'Seasonal Fruit Platter' AND mi.package_id = cp.package_id
);

INSERT INTO menu_items (package_id, name, description, course_type, dietary_tags, price_addon, is_default)
SELECT cp.package_id, 'Mini Cinnamon Rolls', NULL, 'dessert', '["veg", "halal"]', 0.00, 1
FROM catering_packages cp
WHERE cp.name = 'Corporate Brunch'
AND NOT EXISTS (
  SELECT 1 FROM menu_items mi WHERE mi.name = 'Mini Cinnamon Rolls' AND mi.package_id = cp.package_id
);

INSERT INTO menu_items (package_id, name, description, course_type, dietary_tags, price_addon, is_default)
SELECT cp.package_id, 'Seared Queen Prawns with Pea Purée', NULL, 'starter', '["gf", "halal"]', 0.00, 1
FROM catering_packages cp
WHERE cp.name = 'Signature Private'
AND NOT EXISTS (
  SELECT 1 FROM menu_items mi WHERE mi.name = 'Seared Queen Prawns with Pea Purée' AND mi.package_id = cp.package_id
);

INSERT INTO menu_items (package_id, name, description, course_type, dietary_tags, price_addon, is_default)
SELECT cp.package_id, 'Beef Carpaccio, Truffle & Quail Egg', NULL, 'starter', '["halal"]', 0.00, 1
FROM catering_packages cp
WHERE cp.name = 'Signature Private'
AND NOT EXISTS (
  SELECT 1 FROM menu_items mi WHERE mi.name = 'Beef Carpaccio, Truffle & Quail Egg' AND mi.package_id = cp.package_id
);

INSERT INTO menu_items (package_id, name, description, course_type, dietary_tags, price_addon, is_default)
SELECT cp.package_id, 'Heirloom Tomato & Burrata', NULL, 'starter', '["veg", "halal"]', 0.00, 1
FROM catering_packages cp
WHERE cp.name = 'Signature Private'
AND NOT EXISTS (
  SELECT 1 FROM menu_items mi WHERE mi.name = 'Heirloom Tomato & Burrata' AND mi.package_id = cp.package_id
);

INSERT INTO menu_items (package_id, name, description, course_type, dietary_tags, price_addon, is_default)
SELECT cp.package_id, 'Dry-Aged Sirloin, Rosemary Jus', NULL, 'main', '["gf", "halal"]', 0.00, 1
FROM catering_packages cp
WHERE cp.name = 'Signature Private'
AND NOT EXISTS (
  SELECT 1 FROM menu_items mi WHERE mi.name = 'Dry-Aged Sirloin, Rosemary Jus' AND mi.package_id = cp.package_id
);

INSERT INTO menu_items (package_id, name, description, course_type, dietary_tags, price_addon, is_default)
SELECT cp.package_id, 'Miso-Glazed Black Cod', NULL, 'main', '["gf", "halal"]', 0.00, 1
FROM catering_packages cp
WHERE cp.name = 'Signature Private'
AND NOT EXISTS (
  SELECT 1 FROM menu_items mi WHERE mi.name = 'Miso-Glazed Black Cod' AND mi.package_id = cp.package_id
);

INSERT INTO menu_items (package_id, name, description, course_type, dietary_tags, price_addon, is_default)
SELECT cp.package_id, 'Truffle & Parmesan Tortellini', NULL, 'main', '["veg", "halal"]', 0.00, 1
FROM catering_packages cp
WHERE cp.name = 'Signature Private'
AND NOT EXISTS (
  SELECT 1 FROM menu_items mi WHERE mi.name = 'Truffle & Parmesan Tortellini' AND mi.package_id = cp.package_id
);

INSERT INTO menu_items (package_id, name, description, course_type, dietary_tags, price_addon, is_default)
SELECT cp.package_id, 'Deconstructed Tiramisu', NULL, 'dessert', '["veg", "halal"]', 0.00, 1
FROM catering_packages cp
WHERE cp.name = 'Signature Private'
AND NOT EXISTS (
  SELECT 1 FROM menu_items mi WHERE mi.name = 'Deconstructed Tiramisu' AND mi.package_id = cp.package_id
);

INSERT INTO menu_items (package_id, name, description, course_type, dietary_tags, price_addon, is_default)
SELECT cp.package_id, 'Valrhona Chocolate Fondant', NULL, 'dessert', '["veg", "halal"]', 0.00, 1
FROM catering_packages cp
WHERE cp.name = 'Signature Private'
AND NOT EXISTS (
  SELECT 1 FROM menu_items mi WHERE mi.name = 'Valrhona Chocolate Fondant' AND mi.package_id = cp.package_id
);

INSERT INTO menu_items (package_id, name, description, course_type, dietary_tags, price_addon, is_default)
SELECT cp.package_id, 'Passionfruit & Yuzu Sorbet', NULL, 'dessert', '["veg", "vegan", "gf", "halal"]', 0.00, 1
FROM catering_packages cp
WHERE cp.name = 'Signature Private'
AND NOT EXISTS (
  SELECT 1 FROM menu_items mi WHERE mi.name = 'Passionfruit & Yuzu Sorbet' AND mi.package_id = cp.package_id
);

INSERT INTO menu_items (package_id, name, description, course_type, dietary_tags, price_addon, is_default)
SELECT cp.package_id, 'Farm Bread & Cultured Butter Board', NULL, 'starter', '["veg", "halal"]', 0.00, 1
FROM catering_packages cp
WHERE cp.name = 'Winelands Harvest'
AND NOT EXISTS (
  SELECT 1 FROM menu_items mi WHERE mi.name = 'Farm Bread & Cultured Butter Board' AND mi.package_id = cp.package_id
);

INSERT INTO menu_items (package_id, name, description, course_type, dietary_tags, price_addon, is_default)
SELECT cp.package_id, 'Cured Meats & Preserves Platter', NULL, 'starter', '["gf", "halal"]', 0.00, 1
FROM catering_packages cp
WHERE cp.name = 'Winelands Harvest'
AND NOT EXISTS (
  SELECT 1 FROM menu_items mi WHERE mi.name = 'Cured Meats & Preserves Platter' AND mi.package_id = cp.package_id
);

INSERT INTO menu_items (package_id, name, description, course_type, dietary_tags, price_addon, is_default)
SELECT cp.package_id, 'Marinated Olives & Farm Cheeses', NULL, 'starter', '["veg", "gf", "halal"]', 0.00, 1
FROM catering_packages cp
WHERE cp.name = 'Winelands Harvest'
AND NOT EXISTS (
  SELECT 1 FROM menu_items mi WHERE mi.name = 'Marinated Olives & Farm Cheeses' AND mi.package_id = cp.package_id
);

INSERT INTO menu_items (package_id, name, description, course_type, dietary_tags, price_addon, is_default)
SELECT cp.package_id, 'Wood-Fired Boerewors & Chutney', NULL, 'main', '["gf", "halal"]', 0.00, 1
FROM catering_packages cp
WHERE cp.name = 'Winelands Harvest'
AND NOT EXISTS (
  SELECT 1 FROM menu_items mi WHERE mi.name = 'Wood-Fired Boerewors & Chutney' AND mi.package_id = cp.package_id
);

INSERT INTO menu_items (package_id, name, description, course_type, dietary_tags, price_addon, is_default)
SELECT cp.package_id, 'Harvest Vegetable Tart', NULL, 'main', '["veg", "halal"]', 0.00, 1
FROM catering_packages cp
WHERE cp.name = 'Winelands Harvest'
AND NOT EXISTS (
  SELECT 1 FROM menu_items mi WHERE mi.name = 'Harvest Vegetable Tart' AND mi.package_id = cp.package_id
);

INSERT INTO menu_items (package_id, name, description, course_type, dietary_tags, price_addon, is_default)
SELECT cp.package_id, 'Grilled Chicken & Peri Peri Basting', NULL, 'main', '["gf", "halal"]', 0.00, 1
FROM catering_packages cp
WHERE cp.name = 'Winelands Harvest'
AND NOT EXISTS (
  SELECT 1 FROM menu_items mi WHERE mi.name = 'Grilled Chicken & Peri Peri Basting' AND mi.package_id = cp.package_id
);

INSERT INTO menu_items (package_id, name, description, course_type, dietary_tags, price_addon, is_default)
SELECT cp.package_id, 'Rustic Apple & Cinnamon Crumble', NULL, 'dessert', '["veg", "halal"]', 0.00, 1
FROM catering_packages cp
WHERE cp.name = 'Winelands Harvest'
AND NOT EXISTS (
  SELECT 1 FROM menu_items mi WHERE mi.name = 'Rustic Apple & Cinnamon Crumble' AND mi.package_id = cp.package_id
);

INSERT INTO menu_items (package_id, name, description, course_type, dietary_tags, price_addon, is_default)
SELECT cp.package_id, 'Farm Honey & Ricotta Tart', NULL, 'dessert', '["veg", "halal"]', 0.00, 1
FROM catering_packages cp
WHERE cp.name = 'Winelands Harvest'
AND NOT EXISTS (
  SELECT 1 FROM menu_items mi WHERE mi.name = 'Farm Honey & Ricotta Tart' AND mi.package_id = cp.package_id
);

INSERT INTO menu_items (package_id, name, description, course_type, dietary_tags, price_addon, is_default)
SELECT cp.package_id, 'Seasonal Vineyard Fruit Bowl', NULL, 'dessert', '["veg", "vegan", "gf", "halal"]', 0.00, 1
FROM catering_packages cp
WHERE cp.name = 'Winelands Harvest'
AND NOT EXISTS (
  SELECT 1 FROM menu_items mi WHERE mi.name = 'Seasonal Vineyard Fruit Bowl' AND mi.package_id = cp.package_id
);

INSERT INTO menu_items (package_id, name, description, course_type, dietary_tags, price_addon, is_default)
SELECT cp.package_id, 'Heirloom Tomato Gazpacho', NULL, 'starter', '["veg", "vegan", "gf", "halal"]', 0.00, 1
FROM catering_packages cp
WHERE cp.name = 'Garden Celebration'
AND NOT EXISTS (
  SELECT 1 FROM menu_items mi WHERE mi.name = 'Heirloom Tomato Gazpacho' AND mi.package_id = cp.package_id
);

INSERT INTO menu_items (package_id, name, description, course_type, dietary_tags, price_addon, is_default)
SELECT cp.package_id, 'Grilled Peach & Burrata Salad', NULL, 'starter', '["veg", "gf", "halal"]', 0.00, 1
FROM catering_packages cp
WHERE cp.name = 'Garden Celebration'
AND NOT EXISTS (
  SELECT 1 FROM menu_items mi WHERE mi.name = 'Grilled Peach & Burrata Salad' AND mi.package_id = cp.package_id
);

INSERT INTO menu_items (package_id, name, description, course_type, dietary_tags, price_addon, is_default)
SELECT cp.package_id, 'Chargrilled Asparagus & Lemon Oil', NULL, 'starter', '["veg", "vegan", "gf", "halal"]', 0.00, 1
FROM catering_packages cp
WHERE cp.name = 'Garden Celebration'
AND NOT EXISTS (
  SELECT 1 FROM menu_items mi WHERE mi.name = 'Chargrilled Asparagus & Lemon Oil' AND mi.package_id = cp.package_id
);

INSERT INTO menu_items (package_id, name, description, course_type, dietary_tags, price_addon, is_default)
SELECT cp.package_id, 'Herb-Crusted Vegetable Wellington', NULL, 'main', '["veg", "vegan", "halal"]', 0.00, 1
FROM catering_packages cp
WHERE cp.name = 'Garden Celebration'
AND NOT EXISTS (
  SELECT 1 FROM menu_items mi WHERE mi.name = 'Herb-Crusted Vegetable Wellington' AND mi.package_id = cp.package_id
);

INSERT INTO menu_items (package_id, name, description, course_type, dietary_tags, price_addon, is_default)
SELECT cp.package_id, 'Lemon & Thyme Roast Chicken', NULL, 'main', '["gf", "halal"]', 0.00, 1
FROM catering_packages cp
WHERE cp.name = 'Garden Celebration'
AND NOT EXISTS (
  SELECT 1 FROM menu_items mi WHERE mi.name = 'Lemon & Thyme Roast Chicken' AND mi.package_id = cp.package_id
);

INSERT INTO menu_items (package_id, name, description, course_type, dietary_tags, price_addon, is_default)
SELECT cp.package_id, 'Grilled Line Fish, Salsa Verde', NULL, 'main', '["gf", "halal"]', 0.00, 1
FROM catering_packages cp
WHERE cp.name = 'Garden Celebration'
AND NOT EXISTS (
  SELECT 1 FROM menu_items mi WHERE mi.name = 'Grilled Line Fish, Salsa Verde' AND mi.package_id = cp.package_id
);

INSERT INTO menu_items (package_id, name, description, course_type, dietary_tags, price_addon, is_default)
SELECT cp.package_id, 'Chickpea & Butternut Tagine', NULL, 'main', '["veg", "vegan", "gf", "halal"]', 0.00, 1
FROM catering_packages cp
WHERE cp.name = 'Garden Celebration'
AND NOT EXISTS (
  SELECT 1 FROM menu_items mi WHERE mi.name = 'Chickpea & Butternut Tagine' AND mi.package_id = cp.package_id
);

INSERT INTO menu_items (package_id, name, description, course_type, dietary_tags, price_addon, is_default)
SELECT cp.package_id, 'Lavender Panna Cotta', NULL, 'dessert', '["veg", "gf", "halal"]', 0.00, 1
FROM catering_packages cp
WHERE cp.name = 'Garden Celebration'
AND NOT EXISTS (
  SELECT 1 FROM menu_items mi WHERE mi.name = 'Lavender Panna Cotta' AND mi.package_id = cp.package_id
);

INSERT INTO menu_items (package_id, name, description, course_type, dietary_tags, price_addon, is_default)
SELECT cp.package_id, 'Vegan Berry Pavlova', NULL, 'dessert', '["veg", "vegan", "gf", "halal"]', 0.00, 1
FROM catering_packages cp
WHERE cp.name = 'Garden Celebration'
AND NOT EXISTS (
  SELECT 1 FROM menu_items mi WHERE mi.name = 'Vegan Berry Pavlova' AND mi.package_id = cp.package_id
);

INSERT INTO menu_items (package_id, name, description, course_type, dietary_tags, price_addon, is_default)
SELECT cp.package_id, 'Garden Herb Lemon Tart', NULL, 'dessert', '["veg", "halal"]', 0.00, 1
FROM catering_packages cp
WHERE cp.name = 'Garden Celebration'
AND NOT EXISTS (
  SELECT 1 FROM menu_items mi WHERE mi.name = 'Garden Herb Lemon Tart' AND mi.package_id = cp.package_id
);

INSERT INTO menu_items (package_id, name, description, course_type, dietary_tags, price_addon, is_default)
SELECT cp.package_id, 'Garden Side Salad, Boxed', NULL, 'starter', '["veg", "vegan", "gf", "halal"]', 0.00, 1
FROM catering_packages cp
WHERE cp.name = 'Boardroom Lunch'
AND NOT EXISTS (
  SELECT 1 FROM menu_items mi WHERE mi.name = 'Garden Side Salad, Boxed' AND mi.package_id = cp.package_id
);

INSERT INTO menu_items (package_id, name, description, course_type, dietary_tags, price_addon, is_default)
SELECT cp.package_id, 'Butternut Soup Cup', NULL, 'starter', '["veg", "gf", "halal"]', 0.00, 1
FROM catering_packages cp
WHERE cp.name = 'Boardroom Lunch'
AND NOT EXISTS (
  SELECT 1 FROM menu_items mi WHERE mi.name = 'Butternut Soup Cup' AND mi.package_id = cp.package_id
);

INSERT INTO menu_items (package_id, name, description, course_type, dietary_tags, price_addon, is_default)
SELECT cp.package_id, 'Hummus & Crudité Box', NULL, 'starter', '["veg", "vegan", "gf", "halal"]', 0.00, 1
FROM catering_packages cp
WHERE cp.name = 'Boardroom Lunch'
AND NOT EXISTS (
  SELECT 1 FROM menu_items mi WHERE mi.name = 'Hummus & Crudité Box' AND mi.package_id = cp.package_id
);

INSERT INTO menu_items (package_id, name, description, course_type, dietary_tags, price_addon, is_default)
SELECT cp.package_id, 'Chicken Mayo Sandwich Box', NULL, 'main', '["halal"]', 0.00, 1
FROM catering_packages cp
WHERE cp.name = 'Boardroom Lunch'
AND NOT EXISTS (
  SELECT 1 FROM menu_items mi WHERE mi.name = 'Chicken Mayo Sandwich Box' AND mi.package_id = cp.package_id
);

INSERT INTO menu_items (package_id, name, description, course_type, dietary_tags, price_addon, is_default)
SELECT cp.package_id, 'Falafel & Tahini Wrap', NULL, 'main', '["veg", "vegan", "halal"]', 0.00, 1
FROM catering_packages cp
WHERE cp.name = 'Boardroom Lunch'
AND NOT EXISTS (
  SELECT 1 FROM menu_items mi WHERE mi.name = 'Falafel & Tahini Wrap' AND mi.package_id = cp.package_id
);

INSERT INTO menu_items (package_id, name, description, course_type, dietary_tags, price_addon, is_default)
SELECT cp.package_id, 'Grilled Steak Sandwich Box', NULL, 'main', '["halal"]', 0.00, 1
FROM catering_packages cp
WHERE cp.name = 'Boardroom Lunch'
AND NOT EXISTS (
  SELECT 1 FROM menu_items mi WHERE mi.name = 'Grilled Steak Sandwich Box' AND mi.package_id = cp.package_id
);

INSERT INTO menu_items (package_id, name, description, course_type, dietary_tags, price_addon, is_default)
SELECT cp.package_id, 'Quinoa & Roast Veg Bowl', NULL, 'main', '["veg", "vegan", "gf", "halal"]', 0.00, 1
FROM catering_packages cp
WHERE cp.name = 'Boardroom Lunch'
AND NOT EXISTS (
  SELECT 1 FROM menu_items mi WHERE mi.name = 'Quinoa & Roast Veg Bowl' AND mi.package_id = cp.package_id
);

INSERT INTO menu_items (package_id, name, description, course_type, dietary_tags, price_addon, is_default)
SELECT cp.package_id, 'Boxed Brownie Bite', NULL, 'dessert', '["veg", "halal"]', 0.00, 1
FROM catering_packages cp
WHERE cp.name = 'Boardroom Lunch'
AND NOT EXISTS (
  SELECT 1 FROM menu_items mi WHERE mi.name = 'Boxed Brownie Bite' AND mi.package_id = cp.package_id
);

INSERT INTO menu_items (package_id, name, description, course_type, dietary_tags, price_addon, is_default)
SELECT cp.package_id, 'Fresh Fruit Cup', NULL, 'dessert', '["veg", "vegan", "gf", "halal"]', 0.00, 1
FROM catering_packages cp
WHERE cp.name = 'Boardroom Lunch'
AND NOT EXISTS (
  SELECT 1 FROM menu_items mi WHERE mi.name = 'Fresh Fruit Cup' AND mi.package_id = cp.package_id
);

INSERT INTO menu_items (package_id, name, description, course_type, dietary_tags, price_addon, is_default)
SELECT cp.package_id, 'Oat & Berry Slice', NULL, 'dessert', '["veg", "vegan", "halal"]', 0.00, 1
FROM catering_packages cp
WHERE cp.name = 'Boardroom Lunch'
AND NOT EXISTS (
  SELECT 1 FROM menu_items mi WHERE mi.name = 'Oat & Berry Slice' AND mi.package_id = cp.package_id
);

INSERT INTO menu_items (package_id, name, description, course_type, dietary_tags, price_addon, is_default)
SELECT cp.package_id, 'Charred Prawn Ceviche, Citrus Mignonette', NULL, 'starter', '["gf", "halal"]', 0.00, 1
FROM catering_packages cp
WHERE cp.name = 'Candlelit Anniversary'
AND NOT EXISTS (
  SELECT 1 FROM menu_items mi WHERE mi.name = 'Charred Prawn Ceviche, Citrus Mignonette' AND mi.package_id = cp.package_id
);

INSERT INTO menu_items (package_id, name, description, course_type, dietary_tags, price_addon, is_default)
SELECT cp.package_id, 'Wild Mushroom & Truffle Velouté', NULL, 'starter', '["veg", "gf", "halal"]', 0.00, 1
FROM catering_packages cp
WHERE cp.name = 'Candlelit Anniversary'
AND NOT EXISTS (
  SELECT 1 FROM menu_items mi WHERE mi.name = 'Wild Mushroom & Truffle Velouté' AND mi.package_id = cp.package_id
);

INSERT INTO menu_items (package_id, name, description, course_type, dietary_tags, price_addon, is_default)
SELECT cp.package_id, 'Beetroot-Cured Salmon Gravlax', NULL, 'starter', '["gf", "halal"]', 0.00, 1
FROM catering_packages cp
WHERE cp.name = 'Candlelit Anniversary'
AND NOT EXISTS (
  SELECT 1 FROM menu_items mi WHERE mi.name = 'Beetroot-Cured Salmon Gravlax' AND mi.package_id = cp.package_id
);

INSERT INTO menu_items (package_id, name, description, course_type, dietary_tags, price_addon, is_default)
SELECT cp.package_id, 'Rack of Lamb, Rosemary & Red Grape Jus', NULL, 'main', '["gf", "halal"]', 0.00, 1
FROM catering_packages cp
WHERE cp.name = 'Candlelit Anniversary'
AND NOT EXISTS (
  SELECT 1 FROM menu_items mi WHERE mi.name = 'Rack of Lamb, Rosemary & Red Grape Jus' AND mi.package_id = cp.package_id
);

INSERT INTO menu_items (package_id, name, description, course_type, dietary_tags, price_addon, is_default)
SELECT cp.package_id, 'Butter-Poached Lobster Tail', NULL, 'main', '["gf", "halal"]', 0.00, 1
FROM catering_packages cp
WHERE cp.name = 'Candlelit Anniversary'
AND NOT EXISTS (
  SELECT 1 FROM menu_items mi WHERE mi.name = 'Butter-Poached Lobster Tail' AND mi.package_id = cp.package_id
);

INSERT INTO menu_items (package_id, name, description, course_type, dietary_tags, price_addon, is_default)
SELECT cp.package_id, 'Wild Mushroom & Truffle Risotto', NULL, 'main', '["veg", "gf", "halal"]', 0.00, 1
FROM catering_packages cp
WHERE cp.name = 'Candlelit Anniversary'
AND NOT EXISTS (
  SELECT 1 FROM menu_items mi WHERE mi.name = 'Wild Mushroom & Truffle Risotto' AND mi.package_id = cp.package_id
);

INSERT INTO menu_items (package_id, name, description, course_type, dietary_tags, price_addon, is_default)
SELECT cp.package_id, 'Molten Chocolate Soufflé for Two', NULL, 'dessert', '["veg", "halal"]', 0.00, 1
FROM catering_packages cp
WHERE cp.name = 'Candlelit Anniversary'
AND NOT EXISTS (
  SELECT 1 FROM menu_items mi WHERE mi.name = 'Molten Chocolate Soufflé for Two' AND mi.package_id = cp.package_id
);

INSERT INTO menu_items (package_id, name, description, course_type, dietary_tags, price_addon, is_default)
SELECT cp.package_id, 'Rose & Raspberry Jelly', NULL, 'dessert', '["veg", "vegan", "gf", "halal"]', 0.00, 1
FROM catering_packages cp
WHERE cp.name = 'Candlelit Anniversary'
AND NOT EXISTS (
  SELECT 1 FROM menu_items mi WHERE mi.name = 'Rose & Raspberry Jelly' AND mi.package_id = cp.package_id
);

INSERT INTO menu_items (package_id, name, description, course_type, dietary_tags, price_addon, is_default)
SELECT cp.package_id, 'Vanilla Bean Crème Brûlée', NULL, 'dessert', '["veg", "gf", "halal"]', 0.00, 1
FROM catering_packages cp
WHERE cp.name = 'Candlelit Anniversary'
AND NOT EXISTS (
  SELECT 1 FROM menu_items mi WHERE mi.name = 'Vanilla Bean Crème Brûlée' AND mi.package_id = cp.package_id
);

INSERT INTO menu_items (package_id, name, description, course_type, dietary_tags, price_addon, is_default)
SELECT cp.package_id, 'Biltong & Cream Cheese Canapés', NULL, 'starter', '["halal"]', 0.00, 1
FROM catering_packages cp
WHERE cp.name = 'Safari Sundowner'
AND NOT EXISTS (
  SELECT 1 FROM menu_items mi WHERE mi.name = 'Biltong & Cream Cheese Canapés' AND mi.package_id = cp.package_id
);

INSERT INTO menu_items (package_id, name, description, course_type, dietary_tags, price_addon, is_default)
SELECT cp.package_id, 'Smoked Springbok Carpaccio Bites', NULL, 'starter', '["gf", "halal"]', 0.00, 1
FROM catering_packages cp
WHERE cp.name = 'Safari Sundowner'
AND NOT EXISTS (
  SELECT 1 FROM menu_items mi WHERE mi.name = 'Smoked Springbok Carpaccio Bites' AND mi.package_id = cp.package_id
);

INSERT INTO menu_items (package_id, name, description, course_type, dietary_tags, price_addon, is_default)
SELECT cp.package_id, 'Roasted Butternut & Feta Skewers', NULL, 'starter', '["veg", "gf", "halal"]', 0.00, 1
FROM catering_packages cp
WHERE cp.name = 'Safari Sundowner'
AND NOT EXISTS (
  SELECT 1 FROM menu_items mi WHERE mi.name = 'Roasted Butternut & Feta Skewers' AND mi.package_id = cp.package_id
);

INSERT INTO menu_items (package_id, name, description, course_type, dietary_tags, price_addon, is_default)
SELECT cp.package_id, 'Mini Boerewors Rolls', NULL, 'main', '["halal"]', 0.00, 1
FROM catering_packages cp
WHERE cp.name = 'Safari Sundowner'
AND NOT EXISTS (
  SELECT 1 FROM menu_items mi WHERE mi.name = 'Mini Boerewors Rolls' AND mi.package_id = cp.package_id
);

INSERT INTO menu_items (package_id, name, description, course_type, dietary_tags, price_addon, is_default)
SELECT cp.package_id, 'Peri Peri Chicken Skewers', NULL, 'main', '["gf", "halal"]', 0.00, 1
FROM catering_packages cp
WHERE cp.name = 'Safari Sundowner'
AND NOT EXISTS (
  SELECT 1 FROM menu_items mi WHERE mi.name = 'Peri Peri Chicken Skewers' AND mi.package_id = cp.package_id
);

INSERT INTO menu_items (package_id, name, description, course_type, dietary_tags, price_addon, is_default)
SELECT cp.package_id, 'Grilled Halloumi & Vegetable Skewers', NULL, 'main', '["veg", "gf", "halal"]', 0.00, 1
FROM catering_packages cp
WHERE cp.name = 'Safari Sundowner'
AND NOT EXISTS (
  SELECT 1 FROM menu_items mi WHERE mi.name = 'Grilled Halloumi & Vegetable Skewers' AND mi.package_id = cp.package_id
);

INSERT INTO menu_items (package_id, name, description, course_type, dietary_tags, price_addon, is_default)
SELECT cp.package_id, 'Salted Caramel Chocolate Mousse Shots', NULL, 'dessert', '["veg", "halal"]', 0.00, 1
FROM catering_packages cp
WHERE cp.name = 'Safari Sundowner'
AND NOT EXISTS (
  SELECT 1 FROM menu_items mi WHERE mi.name = 'Salted Caramel Chocolate Mousse Shots' AND mi.package_id = cp.package_id
);

INSERT INTO menu_items (package_id, name, description, course_type, dietary_tags, price_addon, is_default)
SELECT cp.package_id, 'Rooibos-Poached Fruit Skewers', NULL, 'dessert', '["veg", "vegan", "gf", "halal"]', 0.00, 1
FROM catering_packages cp
WHERE cp.name = 'Safari Sundowner'
AND NOT EXISTS (
  SELECT 1 FROM menu_items mi WHERE mi.name = 'Rooibos-Poached Fruit Skewers' AND mi.package_id = cp.package_id
);

INSERT INTO menu_items (package_id, name, description, course_type, dietary_tags, price_addon, is_default)
SELECT cp.package_id, 'Malva Pudding Bites', NULL, 'dessert', '["veg", "halal"]', 0.00, 1
FROM catering_packages cp
WHERE cp.name = 'Safari Sundowner'
AND NOT EXISTS (
  SELECT 1 FROM menu_items mi WHERE mi.name = 'Malva Pudding Bites' AND mi.package_id = cp.package_id
);


-- Tour Operators

INSERT INTO tour_operators (company_name, contact_email, contact_phone)
SELECT 'Cape Explorer Tours', 'info@capeexplorer.test', '+27210000001' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM tour_operators WHERE company_name = 'Cape Explorer Tours');

INSERT INTO tour_operators (company_name, contact_email, contact_phone)
SELECT 'Winelands Adventure Co', 'info@winelandsadventure.test', '+27210000002' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM tour_operators WHERE company_name = 'Winelands Adventure Co');

INSERT INTO tour_operators (company_name, contact_email, contact_phone)
SELECT 'Table Mountain Experiences', 'info@tablemountainexperiences.test', '+27210000003' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM tour_operators WHERE company_name = 'Table Mountain Experiences');


-- Tour Packages

INSERT INTO tour_packages (operator_id, package_id, itinerary_notes)
SELECT o.operator_id, cp.package_id, 'Full-day Cape Winelands experience with wine tasting, scenic stops, and farm-style sharing platters en route.'
FROM tour_operators o, catering_packages cp
WHERE o.company_name = 'Cape Explorer Tours' AND cp.name = 'Winelands Harvest'
AND NOT EXISTS (
  SELECT 1 FROM tour_packages tp WHERE tp.operator_id = o.operator_id AND tp.package_id = cp.package_id
);

INSERT INTO tour_packages (operator_id, package_id, itinerary_notes)
SELECT o.operator_id, cp.package_id, 'Premium Stellenbosch and Franschhoek route with guided tastings and curated local cuisine.'
FROM tour_operators o, catering_packages cp
WHERE o.company_name = 'Winelands Adventure Co' AND cp.name = 'Winelands Harvest'
AND NOT EXISTS (
  SELECT 1 FROM tour_packages tp WHERE tp.operator_id = o.operator_id AND tp.package_id = cp.package_id
);

INSERT INTO tour_packages (operator_id, package_id, itinerary_notes)
SELECT o.operator_id, cp.package_id, 'Golden-hour game drive combined with canapés and drinks service at sundown.'
FROM tour_operators o, catering_packages cp
WHERE o.company_name = 'Table Mountain Experiences' AND cp.name = 'Safari Sundowner'
AND NOT EXISTS (
  SELECT 1 FROM tour_packages tp WHERE tp.operator_id = o.operator_id AND tp.package_id = cp.package_id
);
