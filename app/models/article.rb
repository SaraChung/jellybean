class Article < ActiveRecord::Base
	acts_as_taggable
  MOST_COMMENTS_LIMIT = 3

	belongs_to :category
	has_many :comments, dependent: :destroy
	validates :title, presence: true, length: { minimum:1 }
	validates :thumbnail, presence: true
  validates :published_at, presence: true, :if => :is_published?
	has_attached_file :thumbnail,
    {
      :styles => { :thumb => "200x200#" },
      :default_url => "/images/:style/missing.png"
    }.merge(PaperclipStorageOption.options)

	self.per_page = 12
  validates_attachment_content_type :thumbnail, :content_type => /\Aimage\/.*\Z/

  scope :latest, lambda { order(created_at: :desc) }
  def is_published?
    published == true
  end

  scope :most_comments, lambda {
    joins(:comments)
      .group("articles.id")
      .select("articles.title", "count(comments.id) as comments_count")
      .limit(MOST_COMMENTS_LIMIT)
  }
end
