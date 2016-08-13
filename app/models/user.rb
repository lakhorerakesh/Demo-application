class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook, :twitter, :google_oauth2, :linkedin]

  has_attached_file :image, styles: { medium: "300x300>", thumb: "50x50>" }, default_url: "/assets/missing.png"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
  has_many :conversations, :foreign_key => :sender_id

  def self.find_for_oauth(auth, signed_in_resource = nil)

    # Get the identity and user if they exist
    identity = Identity.find_for_oauth(auth)
    user = signed_in_resource ? signed_in_resource : identity.user
    if user.nil?
      email_is_verified = auth.info.email
      email = auth.info.email if email_is_verified
      user = User.where(:email => email).first if email
      if user.nil?
        limit = 3
        begin
          username = "#{auth.info.first_name.downcase}#{auth.uid[0..limit+=1]}"
        end while self.exists?(name: username)

        user = User.new(
          name: username,
          email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
          password: Devise.friendly_token[0,20]
        )
        user.skip_confirmation! if user.respond_to?(:skip_confirmation)
        user.save!
      end
    end
    if identity.user != user
      identity.user = user
      identity.save!
    end
    user
  end

  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      if auth.provider == "twitter"
        user.name = auth.info.nickname
      else 
        user.name = auth.info.name
      end
      user.save
    end
  end
end
