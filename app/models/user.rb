class User < ApplicationRecord
    has_many :notes
    has_many :docs
    
    validates_uniqueness_of :email

    has_secure_password
end