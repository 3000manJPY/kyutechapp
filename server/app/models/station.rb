class Station < ActiveRecord::Base
    has_many :line_stations
    has_many :lines, through: :line_stations

    has_many :campus_stations
    has_many :campuses, through: :campus_stations

    has_many :directions, dependent: :destroy


end
