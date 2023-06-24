class User < ApplicationRecord
    has_many :notes
    has_many :docs
    
    validates_presence_of :email
    validates_uniqueness_of :email
    validates_presence_of :username
    validates_presence_of :password
    validates_presence_of :logged_in

    has_secure_password
end