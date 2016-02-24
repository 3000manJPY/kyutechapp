class Api::V2::AccessController < ApplicationController
    def allAccesses
        @campus_id = params[:campus_id]
        if @campus_id == nil 
            @accesses = Access.all.to_json(:include => {:directions => {:include => :time_tables}})
        else
            @accesses = Access.find_by(:campus_id => @campus_id).to_json(:include => {:directions => {:include => :time_tables}})
        end
        render json: @accesses
    end

    def access
        @id = params[:id] 
        render json: Access.find_by(:id => @id)
    end
end
