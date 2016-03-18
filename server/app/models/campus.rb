class Campus < ActiveRecord::Base
    has_many :campus_stations
    has_many :stations, through: :campus_stations
end
