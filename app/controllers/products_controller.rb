class ProductsController < ApplicationController
  # def index
  #   @products = Product.where(visible: true)

  #   # Filter by STI type (ex: ?kind=ring → type: "Ring")
  #   if params[:kind].present?
  #     sti_class_name = params[:kind].to_s.classify # "ring" → "Ring"
  #     @products = @products.where(type: sti_class_name)
  #   end

  #   @products = @products.where(category_id: params[:category_id]) if params[:category_id].present?
  #   @products = @products.where(metal_id: params[:metal_id]) if params[:metal_id].present?

  #   if params[:min_price].present? && params[:max_price].present?
  #     @products = @products.where(
  #       "base_price_cents BETWEEN ? AND ?",
  #       params[:min_price].to_f * 100,
  #       params[:max_price].to_f * 100
  #     )
  #   elsif params[:min_price].present?
  #     @products = @products.where("base_price_cents >= ?", params[:min_price].to_f * 100)
  #   elsif params[:max_price].present?
  #     @products = @products.where("base_price_cents <= ?", params[:max_price].to_f * 100)
  #   end

  #   if params[:search].present?
  #     query = "%#{params[:search].strip.downcase}%"
  #     @products = @products.where("LOWER(name) LIKE ? OR LOWER(sku) LIKE ?", query, query)
  #   end

  #   render json: @products
  # end
  def index
    @products = Product.visible.includes(:category, :metal, :gemstones)

    if params[:search].present?
      q = "%#{params[:search].strip.downcase}%"

      @products = @products.where("
        LOWER(products.name) LIKE :q
        OR LOWER(products.sku) LIKE :q
        OR LOWER(products.description) LIKE :q
        OR LOWER(categories.name) LIKE :q
        OR LOWER(metals.name) LIKE :q
        OR EXISTS (
          SELECT 1
          FROM gemstones
          INNER JOIN product_gemstones ON product_gemstones.gemstone_id = gemstones.id
          WHERE product_gemstones.product_id = products.id
          AND LOWER(gemstones.name) LIKE :q
        )
      ", q: q)
    end


    if params[:type].present?
      @products = @products.where(type: params[:type].classify)
    end

    if params[:category_id].present?
      @products = @products.where(category_id: params[:category_id])
    end

    if params[:metal_id].present?
      @products = @products.where(metal_id: params[:metal_id])
    end

    if params[:min_price].present?
      @products = @products.where("base_price_cents >= ?", params[:min_price].to_i * 100)
    end

    if params[:max_price].present?
      @products = @products.where("base_price_cents <= ?", params[:max_price].to_i * 100)
    end

    render json: @products.as_json(
      include: {
        category: { only: [:id, :name] },
        metal: { only: [:id, :name, :purity_karat] },
        gemstones: { only: [:id, :name, :kind, :color] }
      }
    )
  end

  def suggestions
    render json: {
      inspiration: [
        { label: "Watches for Him", image: "/images/m1.jpg", link: "/products?type=watch&gender=male" },
        { label: "Watches for Her", image: "/images/m2.jpg", link: "/products?type=watch&gender=female" },
        { label: "Icons",           image: "/images/m3.jpg", link: "/products?featured=true" },
        { label: "Little Luxuries", image: "/images/m4.jpg", link: "/products?price_max=500" }
      ],
      categories: Category.all.order(:name).pluck(:id, :name).map { |id, name| { id: id, name: name } },
      popular_searches: [
        "Rings",
        "Necklaces",
        "Bracelets",
        "Earrings",
        "Gold Jewelry",
        "Men’s Watches"
      ]
    }
  end

  def popular
    render json: [
      "Rings", "Necklaces", "Watches", "Earrings",
      "Bracelets", "Gold Jewelry", "Diamond Ring"
    ]
  end

  def show
    @product = Product.find_by(id: params[:id], visible: true)
    if @product
      render json: @product
    else
      render json: { error: "Product not found" }, status: :not_found
    end
  end
end
