class WishlistsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_wishlist

  # GET /wishlist
  def show
    render json: @wishlist.to_json(
      include: {
        wishlist_items: {
          include: {
            variant: {
              include: :product
            }
          }
        }
      }
    )
  end

  # POST /wishlist/add_item
  # params: { variant_id: 123 }
  def add_item
    variant = Variant.find(params[:variant_id])

    item = @wishlist.wishlist_items.find_or_initialize_by(variant: variant)

    if item.save
      render json: {
        success: true,
        wishlist_item: item,
        message: "#{variant.product.name} added to wishlist"
      }, status: :ok
    else
      render json: { success: false, errors: item.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  # DELETE /wishlist/remove_item/:variant_id
  def remove_item
    item = @wishlist.wishlist_items.find_by(variant_id: params[:variant_id])

    if item
      item.destroy
      render json: { success: true, message: "Removed from wishlist" }, status: :ok
    else
      render json: { success: false, error: "Item not found in wishlist" },
             status: :not_found
    end
  end

  private

  def set_wishlist
    if current_user
      @wishlist = current_user.wishlist || current_user.build_wishlist(status: "active")
      @wishlist.save if @wishlist.new_record?
    else
      # guest wishlist via session
      session[:wishlist_token] ||= SecureRandom.hex(10)
      @wishlist = Wishlist.find_or_create_by!(
        session_token: session[:wishlist_token],
        status: "active"
      )
    end
  end
end
