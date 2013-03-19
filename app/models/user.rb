class User < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  after_create { |user| user.send_reset_password_instructions }

  def password_required?
    new_record? ? false : super
  end
end
