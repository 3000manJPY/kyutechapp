class Campus < ActiveRecord::Base
    has_many :access_campuses
    has_many :accesses, through: :access_campuses
end
