class AccessCampus < ActiveRecord::Base
    belongs_to :access
    belongs_to :campus
end
