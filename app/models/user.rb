class User < ApplicationRecord

  has_many :orders 
  has_one :wishlist
  has_one :cart
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

	has_attached_file :avatar, styles: { medium: "300x300>", thumb: "50X50>" }, default_url: "avatar.png"
  validates_attachment_content_type :avatar, content_type: ["image/jpeg", "image/gif", "image/png"] 
  
  devise :omniauthable, omniauth_providers: [:google_oauth2]	

  
	def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
    data = access_token.info
    user = User.where(:provider => access_token.provider, :uid => access_token.uid    ).first
    if user
      return user
    else
      registered_user = User.where(:email => access_token.info.email).first
      if registered_user
        return registered_user
      else
        user = User.create(
          provider:access_token.provider,
          email: data["email"],
          uid: access_token.uid ,
          password: Devise.friendly_token[0,20],
        )
      end
   end
end


  #To differenciate between user and admin
  enum role: [:user, :admin] 

  after_initialize do
    if self.new_record?
      self.role ||= :user
  	elsif self.email == "moksh.panchal@green-apex.com"
  	  self.role = :admin
  	end
  end 
end
