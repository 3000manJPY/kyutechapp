class Access < ActiveRecord::Base
    belongs_to :genre
    belongs_to :tation
    belongs_to :line
    belongs_to :direction

    has_many :patterns, dependent: :destroy

    has_many :access_campuses
    has_many :campuses, through: :access_campuses
end
