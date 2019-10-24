class PlantsController < ApplicationController

    before_action :redirect_god



    def new
        @plant = Plant.new
    end




    def index   
        @plants  = Plant.all
        @average = Plant.average_energy
        #the line below this was an attempt to produce the colors in the color
#<%=    Rainbow(" R: #{plant.r}, G: #{plant.g}, B: #{plant.b}").color(colorstring)                     %>
end


def create
    @plant = Plant.new
    @plant.r = params[:plant][:r]
    @plant.g = params[:plant][:g]
    @plant.b = params[:plant][:b]
    @plant.depth = 0
    @plant.energy = 10950
    @plant.growthrate = 50
    @plant.status = 1
    @plant.typisch = 7
    @plant.name = 7
    @plant.status = 1
    @plant.inventory = 10000
    @plant.save
end



def edit   
    @plant = Plant.new
end

def update

   @plant = Plant.all[rand(Plant.all.length)]
    @plant.r = params[:plant][:r]
    @plant.g = params[:plant][:g]
    @plant.b = params[:plant][:b]
    @plant.energy = 10950
    @plant.inventory = 10000
    
    
    if @plant.save
    redirect_to plants_path
    else    
        flash[:message] = "Be serious, 0 through 255"
        redirect_to '/plants/1/edit'
    end
end



end
