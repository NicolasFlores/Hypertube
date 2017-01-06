class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:google_oauth2, :marvin, :facebook]

  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100"}
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  has_many :users_movies
  has_many :comments
  has_many :movies, through: :users_movies

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.fname = auth.info.name.split(' ')[0]
      user.lname = auth.info.name.split(' ', 2)[1]
      if auth.provider == 'facebook'
          user.avatar = auth.info.image.gsub('http', 'https')
      elsif auth.provider == 'marvin'
          user.avatar = auth.info.image || auth.info.profile
    #   else
    #       user.avatar = auth.info.image
      end
      user.nickname = auth.info.nickname
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
    end
  end

  def self.get_nickname(id)
      nickname = User.where(id: id).first.nickname
      return nickname
  end

end
