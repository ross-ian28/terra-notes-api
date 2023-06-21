class Note < ApplicationRecord
    validates_presence_of :user_id
    validates_presence_of :contents
end