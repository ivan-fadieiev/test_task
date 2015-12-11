class User < ActiveRecord::Base
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  before_save { self.email = email.downcase }
  before_create :create_remember_token
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, length: { minimum: 4 }
  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100#", :small => "100x100#" }, :default_url => "/images/:style/missing.png",:url  => "/tmp/products/:id/:style/:basename.:extension",
:path => ":rails_root/tmp/products/:id/:style/:basename.:extension"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
  
  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private

    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end
end
