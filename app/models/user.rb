class User < ApplicationRecord
  has_secure_password

  has_many :posts, dependent: :destroy

  validates :password, length: { minimum: 6, message: 'length must be at least 6 characters long' },
                       if: :password_digest_changed?

  validates :displayName, length: { minimum: 8, message: 'length must be at least 8 characters long' }

  validates :email, uniqueness: true, presence: true,
                    format: { with: /\A(.+)@(.+)\Z/, message: 'must be a valid email' }
end
