class WorldsController < ApplicationController

  before_action :redirect_god

    def showb
      #  catchme = 0
        @world = World.find(params[:id])
      #  while true
   #    @world.next_frame
      #  if catchme == 0
     #   redirect_to action: "showa", id: @world.id
 #   system "rake remake_image"
       # catchme = 1
       # end
       # end
    end

    def showa
       # catchme = 0
        @world = World.find(params[:id])
        #while true
        @world.next_frame
       # if catchme == 0
       # catchme = 1
       # end
      #  end

    #    system "rake remake_image"
    end

    def show
      @worlds = World.find(params[:id])
    end


    def darkmode

      Path.all.each do |path|
        path.r = 0
        path.b = 0
        path.g = 0
        path.save
      end
    
      Herbivore.all.each do |path|
        path.r = 0
        path.b = 255
        path.g = 255
        path.save
      end
    
      Predator.all.each do |path|
        path.r = 255
        path.b = 0
        path.g = 255
        path.save
      end
    
    
      Plant.all.each do |path|
        if path.inventory < 9999
        path.r = 255
        path.b = 255
        path.g = 0
        path.save
        end
      end

      Egg.all.each do |egg|
        if egg.itraits.split(',')[9].to_i < 999 
        egg.itraits = "255,0,255,7,0,1000,10,1,2,1"
        egg.save
        end
      end


      redirect_to action: "showa", id: World.all.first.id
    end


    def lightmode

      Path.all.each do |path|
        path.r = 80
        path.b = 18
        path.g = 35
        path.save
      end
    
      Herbivore.all.each do |path|
        path.r = 200
        path.b = 210
        path.g = 200
        path.save
      end
    
      Predator.all.each do |path|
        path.r = 255
        path.b = 0
        path.g = 0
        path.save
      end
    
    
      Plant.all.each do |path|
        if path.inventory < 9999
        path.r = 0
        path.b = 0
        path.g = 255
        path.save
        end
      end


      Egg.all.each do |egg|
        egg.itraits = "0,255,0,7,0,1000,10,1,2,1"
        egg.save
      end



      redirect_to action: "showa", id: World.all.first.id
    end
        

def planttint
    @plants = Plant.all
    @plant = @plants.first
end


def update
  @plant = Plant.find(params[:id])
  @plant.update_attributes(params[:r])
  @plant.update_attributes(params[:g])
  @plant.update_attributes(params[:b])

    redirect_to action: "showa", id: World.all.first.id

end

def edit
  @plant = Plant.find(params[:id])
  #redirect_to action: "showa", id: World.all.first.id
end

    def index   
            @worlds = World.all
    end




end
