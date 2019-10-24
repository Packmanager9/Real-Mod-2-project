class WeathersController < ApplicationController


    before_action :redirect_god


    def new
        @thesun = Weather.new
    end


    def index
        @weathers = Weather.all
    end

    def destroy
    Weather.all.each do |sun|
        sun.destroy
    end
    end

def create
    @suns = Weather.all
    #  @thesun = Weather.new(sun_params)
   @thesun = Weather.new()
  #  byebug
    @thesun.r = 255
    @thesun.g = 255
    @thesun.b = 255
    @thesun.a = 17
    @thesun.depth = -1000
    @thesun.energy = 1095000000
    @thesun.moisture = 0
    @thesun.status = 1
    @thesun.typisch = -999
    @thesun.name = -999
    @thesun.status = 1
    @thesun.inventory = 10000
    @thesun.path_id = rand(2500)
    @thesun.save
end

private

def sun_params
    params.require(:weather).permit(:r, :g, :b)
end




end
