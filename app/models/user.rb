class User < ActiveRecord::Base
  include Filterable

  render_attrs :id, :email, :created_at, :updated_at

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  before_save :ensure_authentication_token

  ## Relations

  has_and_belongs_to_many :environments

  ## Scopes

  public_scope :environment_id, -> (arg) {
    id = Environment.find_by_name_or_id(arg).id
    joins(:environments).where(environments: {id: id})
  }

  public_scope :email, -> (arg) {
    where(:email => arg)
  }

  ## Methods

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
