class Comment < ApplicationRecord
	belongs_to :article
	has_many  :likes, as: :likeable, dependent: :destroy
end
