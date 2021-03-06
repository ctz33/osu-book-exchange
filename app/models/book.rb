class Book < ApplicationRecord
  has_many :posts
  accepts_nested_attributes_for :posts
  searchable do
  	text :title
  	text :ISBN_13
  	text :ISBN_10
  end
  validates_presence_of :title
  # validates_presence_of :author
end
