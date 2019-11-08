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
  
  devise :omniauthable, omniauth_providers: [:google_oauth2,:facebook,:twitter,:linkedin,:instagram]	

  
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

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.google_data"] && session["devise.google_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
      if data = session["devise.twitter_data"] && session["devise.twitter_data"]["extra"]["raw_info"]["email"]
        user.email = data["email"] if user.email.blank?
      end
      if data = session["devise.linkedin_data"] && session["devise.linkedin_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
      if data = session["devise.instagram_data"] && session["devise.instagram_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def self.from_omniauth(auth)
    registered_user = User.where(:email => auth.info.email).first
    if registered_user
      return registered_user
    else
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.email = auth.info.email
        user.role = :admin if user.email == "moksh.panchal@green-apex.com"
        user.password = Devise.friendly_token[0,20]
        user.name = auth.info.name   # assuming the user model has a name
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
