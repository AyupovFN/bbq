class User < ApplicationRecord

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # Юзер может создавать много событий
  has_many :events
  has_many :comments
  has_many :subscriptions

    validates :name, presence: true, length: {maximum: 35}

  # метод set_name
  before_validation :set_name, on: :create

  after_commit :link_subscriptions, on: :create

  private

  # Задаем юзеру случайное имя, если оно пустое
  def set_name
    self.name = "Товарисч №#{rand(777)}" if self.name.blank?
  end

  def link_subscriptions
    Subscription.where(user_id: nil, user_email: self.email)
        .update_all(user_id: self.id)
  end
end
