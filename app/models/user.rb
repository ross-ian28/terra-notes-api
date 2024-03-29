class User < ApplicationRecord
    has_many :notes
    
    validates_uniqueness_of :email

    has_secure_password
end