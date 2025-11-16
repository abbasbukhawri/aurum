puts "🌱 Seeding database..."

# -----------------------
# METALS
# -----------------------
gold   = Metal.find_or_initialize_by(name: 'Gold')
gold.purity_karat = 22
gold.save!

silver = Metal.find_or_initialize_by(name: 'Silver')
silver.purity_karat = 0
silver.save!

alloy = Metal.find_or_initialize_by(name: 'Alloy')
alloy.purity_karat = 0
alloy.save!

puts "✅ Metals seeded: #{Metal.count}"

# -----------------------
# CATEGORIES
# -----------------------
rings = Category.find_or_initialize_by(name: 'Rings')
rings.save!

necklaces = Category.find_or_initialize_by(name: 'Necklaces')
necklaces.save!

puts "✅ Categories seeded: #{Category.count}"

# -----------------------
# GEMSTONES
# -----------------------
emerald = Gemstone.find_or_initialize_by(name: 'Emerald')
emerald.kind = 'natural'
emerald.color = 'green'
emerald.save!

ruby_gem = Gemstone.find_or_initialize_by(name: 'Ruby')
ruby_gem.kind = 'lab_created'
ruby_gem.color = 'red'
ruby_gem.save!

puts "✅ Gemstones seeded: #{Gemstone.count}"

# -----------------------
# PRODUCTS
# -----------------------
ring1 = Ring.find_or_initialize_by(sku: 'RING-GLD-0001')
ring1.assign_attributes(
  name: 'Classic Gold Ring',
  category: rings,
  metal: gold,
  description: '22k gold ring',
  weight_grams: 5.2,
  base_price_cents: 120_000,
  currency: 'USD',
  visible: true
)
ring1.save!

necklace1 = Product.find_or_initialize_by(sku: 'NECK-SLV-0001')
necklace1.assign_attributes(
  name: 'Ruby Necklace',
  type: 'Necklace',
  category: necklaces,
  metal: silver,
  description: 'Beautiful ruby necklace',
  weight_grams: 15.0,
  base_price_cents: 200_000,
  currency: 'USD',
  visible: true
)
necklace1.save!

puts "✅ Products seeded: #{Product.count}"

# -----------------------
# VARIANTS
# -----------------------
[
  { size: '6', price_cents: 120_000, stock: 10 },
  { size: '7', price_cents: 120_000, stock: 8 }
].each do |attrs|
  variant = Variant.find_or_initialize_by(sku: "RING-GLD-0001-#{attrs[:size]}")
  variant.product = ring1
  variant.option_values = { size: attrs[:size] }
  variant.price_cents = attrs[:price_cents]
  variant.stock = attrs[:stock]
  variant.active = true
  variant.save!
end

variant_neck = Variant.find_or_initialize_by(sku: 'NECK-SLV-0001-18')
variant_neck.product = necklace1
variant_neck.option_values = { length: '18inch' }
variant_neck.price_cents = 200_000
variant_neck.stock = 5
variant_neck.active = true
variant_neck.save!

puts "✅ Variants seeded: #{Variant.count}"

# -----------------------
# USERS
# -----------------------
admin = User.find_or_initialize_by(email: 'admin@example.com')
admin.assign_attributes(
  password: 'Password1!',
  password_confirmation: 'Password1!',
  role: 'admin',
  first_name: 'Store',
  last_name: 'Admin',
  confirmed_at: Time.current
)
admin.save!

customer1 = User.find_or_initialize_by(email: 'john@example.com')
customer1.assign_attributes(
  password: 'Password1!',
  password_confirmation: 'Password1!',
  role: 'customer',
  first_name: 'John',
  last_name: 'Doe',
  confirmed_at: Time.current
)
customer1.save!

customer2 = User.find_or_initialize_by(email: 'jane@example.com')
customer2.assign_attributes(
  password: 'Password1!',
  password_confirmation: 'Password1!',
  role: 'customer',
  first_name: 'Jane',
  last_name: 'Smith',
  confirmed_at: Time.current
)
customer2.save!

puts "✅ Users seeded: #{User.count}"

# -----------------------
# CARTS & CART ITEMS
# -----------------------
cart1 = Cart.find_or_initialize_by(user: customer1, status: '0')
cart1.save!
CartItem.find_or_initialize_by(cart: cart1, variant: Variant.find_by(sku: 'RING-GLD-0001-6')).tap do |ci|
  ci.quantity = 2
  ci.save!
end

cart2 = Cart.find_or_initialize_by(user: customer2, status: '0')
cart2.save!
CartItem.find_or_initialize_by(cart: cart2, variant: Variant.find_by(sku: 'NECK-SLV-0001-18')).tap do |ci|
  ci.quantity = 1
  ci.save!
end

puts "✅ Carts & CartItems seeded: #{Cart.count} / #{CartItem.count}"

puts "🎉 Seeding complete!"
