class Pattern < ActiveRecord::Base
    belongs_to :access
    has_many :timetables, dependent: :destroy

end
