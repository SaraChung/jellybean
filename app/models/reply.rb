class Reply < ActiveRecord::Base
	belongs_to :comment

  validates :name, :content, presence: true
end
