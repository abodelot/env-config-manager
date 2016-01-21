class User < ActiveRecord::Base
  include Filterable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  before_save :ensure_authentication_token

  has_and_belongs_to_many :environments

  public_scope :environment, -> (arg) {
    joins(:environments).where(:environments => {:name => arg})
  }

  public_scope :email, -> (arg) { where(:email => arg) }

  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end

  private

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token if User.where(:authentication_token => token).empty?
    end
  end
end
