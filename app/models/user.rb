class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :medical_histories

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def self.list_patients
    User.where(doctor: false)
  end

  def is_doctor?
    self.doctor
  end
end
