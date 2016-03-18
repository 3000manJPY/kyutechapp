class CampusStation < ActiveRecord::Base
    belongs_to :station
    belongs_to :campus
end
