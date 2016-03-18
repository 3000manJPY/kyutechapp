class Pattern < ActiveRecord::Base
    belongs_to :direction
    has_many :timetables, dependent: :destroy

end
