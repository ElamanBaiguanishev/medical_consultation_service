class Patient < ApplicationRecord
    has_many :consultation_requests, dependent: :destroy
    has_many :recommendations, through: :consultation_requests
end
