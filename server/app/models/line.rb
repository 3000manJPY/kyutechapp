class Line < ActiveRecord::Base
     has_many :accesses, through: :line_stations
end
