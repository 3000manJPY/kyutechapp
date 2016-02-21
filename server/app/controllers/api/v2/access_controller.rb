class Api::V2::AccessController < ApplicationController

    def show
        render json: Access.all.to_json(:include => {:directions => {:include => :time_tables}})
    end


end
