class Direction < ActiveRecord::Base
    belongs_to :access
    has_many :time_tables, dependent: :destroy

end
