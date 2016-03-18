class Line < ActiveRecord::Base
    belongs_to :access

     has_many :line_stations
     has_many :stations, through: :line_stations
end
