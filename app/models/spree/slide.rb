class Spree::Slide < ActiveRecord::Base
  attr_accessible :name, :body, :link_url, :published, :image, :position, :product_id
  
  has_attached_file :attachment, 
    :default_style => :medium,
    :styles => { :medium => "300x300>", :thumb => "100x100>" }, 
    :url =>  ":s3_alias_url", # this has to be ":s3_alias_url" to work with AWS S3
    :path => "/spree/locations/:id/:style/:basename.:extension", 
    :convert_options => { :all => '-strip -auto-orient' }, 
    :s3_host_alias => "#{ENV['s3_bucket']}.s3.amazonaws.com"

  # 
  #  WARNING - THIS CODE IS EXPLICITLY MEANT FOR S3 CONNECTION. FORK AND EDI THESE LINES IF THIS DOES NOT MEET YOUR USE CASE.
  # 
  # Note: copied from 
  # https://github.com/spree/spree/blob/master/core/app/models/spree/image.rb
  include Spree::Core::S3Support
  supports_s3 :attachment
  # use the styles already set above
  # Spree::Image.attachment_definitions[:attachment][:styles] = ActiveSupport::JSON.decode(Spree::Config[:attachment_styles])
  Spree::Image.attachment_definitions[:attachment][:path] = Spree::Config[:attachment_path]
  Spree::Image.attachment_definitions[:attachment][:url] = Spree::Config[:attachment_url]
  Spree::Image.attachment_definitions[:attachment][:default_url] = Spree::Config[:attachment_default_url]
  Spree::Image.attachment_definitions[:attachment][:default_style] = Spree::Config[:attachment_default_style]


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
