class User < ApplicationRecord
    validates_presence_of :email
    validates_presence_of :username
    validates_presence_of :password
    validates_presence_of :logged_in
    validates_presence_of :incogneto_mode

    has_secure_password
end