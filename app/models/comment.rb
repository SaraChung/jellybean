class Comment < ActiveRecord::Base
	belongs_to :article
  has_many :replies

  validates :title, presence: true, length: { minimum: 1 }
  validates :body, presence: true, length: { minimum: 1 }
end
