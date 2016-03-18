class Direction < ActiveRecord::Base
    belongs_to :station
    has_many :patterns, dependent: :destroy

        
end
