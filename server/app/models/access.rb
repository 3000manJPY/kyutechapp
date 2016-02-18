class Access < ActiveRecord::Base
    has_many :directions, dependent: :destroy
end
