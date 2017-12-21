class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def status
    if self.admin?
      "Admin"
    elsif self.premium?
      "Premium"
    else
      "Standard"
    end
  end
end
