class Spree::Slide < ActiveRecord::Base
  attr_accessible :name, :body, :link_url, :published, :image, :position, 
    :product_id
  
  has_attached_file :image, 
    url: '/spree/slides/:id/:style/:basename.:extension',
    path: ':rails_root/public/spree/slides/:id/:style/:basename.:extension'
  
  # validates_attachment :attachment,
  #   :content_type => { :content_type => %w(image/jpeg image/jpg image/png image/gif) }

  belongs_to :product

  scope :published, where(:published => true)

  def initialize(attrs = nil)
    attrs ||= {:published => true}
    super
  end

  def slide_name
    if name.blank? && product.present?
      product.name
    else 
      name
    end
  end

  def slide_link
    if link_url.blank? && product.present?
      product
    else
      link_url
    end
  end

  def slide_image
    if !image.file? && product.present? && product.images.any?
      product.images.first.attachment
    else
      image
    end
  end
end
