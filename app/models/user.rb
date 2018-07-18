class User < ApplicationRecord
  has_many :posts
  has_many :messages
  has_many :contracts
  # @user = User.friendly.find(params[:id])
  extend FriendlyId
  friendly_id :name, use: :slugged
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

end
