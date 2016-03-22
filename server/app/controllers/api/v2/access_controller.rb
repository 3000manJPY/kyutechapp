class Api::V2::AccessController < ApplicationController
    def allAccesses
        @campus_id = params[:campus_id]
#        if @campus_id == nil
#            @accesses = Access.all.to_json(:include => {:lines => {:include => {:stations => {:include => {:directions => {:include => {:patterns => {:include => :timetables}}}}}}}})
#        else
#            @accesses =  Access.all.includes({:lines => {:stations => :campuses}}).where(campus_stations: {campus_id: @campus_id}).references(:campuses).to_json(:include => {:lines => {:include => {:stations => {:include => {:directions => {:include => {:patterns => {:include => :timetables}}}}}}}})
#
#        end
        #

        if @campus_id == nil
            render json: Access.all.to_json(:include => [:genre, :line, :station ,:direction, {:patterns => {:include => :timetables}}])

        else
            render json: Access.all.where(campus_id: @campus_id).to_json(:include => [:genre, :line, :station ,:direction, {:patterns => {:include => :timetables}}])
        end
    end

    def access
        @id = params[:id] 
        render json: Access.find_by(:id => @id)
    end
end
