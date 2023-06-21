class Doc < ApplicationRecord
    validates_presence_of :user_id
    validates_presence_of :password

    has_secure_password
end