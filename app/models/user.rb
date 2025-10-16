class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :confirmable, :trackable
  enum :role, { customer: 0, admin: 1 }, prefix: true
  has_many :carts, dependent: :nullify
  has_many :orders, dependent: :nullify
end
