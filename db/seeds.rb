# db/seeds.rb
puts "🌱 Seeding database..."

# -----------------------
# METALS
# -----------------------
gold   = Metal.find_or_create_by!(name: 'Gold',   purity_karat: 22)
silver = Metal.find_or_create_by!(name: 'Silver', purity_karat: 0)
alloy  = Metal.find_or_create_by!(name: 'Alloy',  purity_karat: 0) # artificial base

puts "✅ Metals seeded: #{Metal.count}"

# -----------------------
# CATEGORIES
# -----------------------
rings = Category.find_or_create_by!(name: 'Rings')
neck  = Category.find_or_create_by!(name: 'Necklaces')

puts "✅ Categories seeded: #{Category.count}"

# -----------------------
# GEMSTONES
# -----------------------
emerald = Gemstone.find_or_create_by!(name: 'Emerald') do |g|
  g.kind  = :natural
  g.color = 'green'
end

ruby_gem = Gemstone.find_or_create_by!(name: 'Ruby') do |g|
  g.kind  = :lab_created
  g.color = 'red'
end

puts "✅ Gemstones seeded: #{Gemstone.count}"

# -----------------------
# PRODUCTS
# -----------------------
p1 = Product.find_or_create_by!(sku: 'RING-GLD-0001') do |p|
  p.name             = 'Classic Gold Ring'
  p.category         = rings
  p.metal            = gold
  p.description      = '22k gold ring'
  p.weight_grams     = 5.2
  p.base_price_cents = 120_000
  p.currency         = 'USD'
  p.visible          = true
end

puts "✅ Product created: #{p1.name}"

# -----------------------
# VARIANTS
# -----------------------
[
  { size: '6', price_cents: 120_000, stock: 10 },
  { size: '7', price_cents: 120_000, stock: 8 }
].each do |variant_attrs|
  Variant.find_or_create_by!(
    product: p1,
    sku: "RING-GLD-0001-#{variant_attrs[:size]}"
  ) do |v|
    v.option_values = { size: variant_attrs[:size] }
    v.price_cents   = variant_attrs[:price_cents]
    v.stock         = variant_attrs[:stock]
    v.active        = true
  end
end

puts "✅ Variants seeded: #{Variant.count}"

# -----------------------
# PRODUCT GEMSTONES
# -----------------------
ProductGemstone.find_or_create_by!(product: p1, gemstone: emerald) do |pg|
  pg.carat_weight = 0.5
end

puts "✅ ProductGemstones seeded: #{ProductGemstone.count}"

# -----------------------
# ADMIN USER
# -----------------------
User.find_or_create_by!(email: 'admin@example.com') do |u|
  u.password              = 'Password1!'
  u.password_confirmation = 'Password1!'
  u.role                  = :admin
  u.first_name            = 'Store'
  u.last_name             = 'Admin'
  u.confirmed_at          = Time.current
end

puts "✅ Admin user created: admin@example.com / Password1!"

puts "🎉 Seeding complete."
