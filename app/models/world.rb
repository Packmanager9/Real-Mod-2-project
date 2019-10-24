require "Chunky_png"


class World < ApplicationRecord

    has_many :godworlds
    has_many :paths
    has_many :gods, through: :godworlds


    def unpack_seed

        unpacker = Egg.all.first.itraits.split(",")

        unpacker[0] = 255  
    end




    def next_frame
        pngx = ChunkyPNG::Image.new(self.width, self.height, ChunkyPNG::Color::BLACK)


    #    Weather.create(r: 0, g: 255, b: 255, a: 2, name: -999, depth: -1000, energy: 12345678910, moisture: 0, status: 1, typisch: -999, inventory: 0, path_id: Path.all[rand(Path.all.length)].id )
    #    Weather.create(r: 255, g: 0, b: 255, a: 2, name: -999, depth: -1000, energy: 12345678910, moisture: 0, status: 1, typisch: -999, inventory: 0, path_id: Path.all[rand(Path.all.length)].id )
    #    Weather.create(r: 255, g: 255, b: 0, a: 2, name: -999, depth: -1000, energy: 12345678910, moisture: 0, status: 1, typisch: -999, inventory: 0, path_id: Path.all[rand(Path.all.length)].id )


        plant_logic()

        herbivore_logic()

       predator_logic()

        Path.all.each do |path|
           pngx[path.x, path.y] = ChunkyPNG::Color.rgba(path.r, path.g, path.b, 255)
        end


        Plant.all.each do |plant|
            pngx[plant.path.x, plant.path.y] =ChunkyPNG::Color.rgba(plant.r, plant.g, plant.b, 255)
       end


        Herbivore.all.each do |herbivore|
           pngx[herbivore.path.x, herbivore.path.y] =ChunkyPNG::Color.rgba(herbivore.r, herbivore.g, herbivore.b, 255)
        end


       Predator.all.each do |predator|
            pngx[predator.path.x, predator.path.y] = ChunkyPNG::Color.rgba(predator.r, predator.g, predator.b, 255)
        end




        weather_logic(pngx)
        pngx.save("/Users/coleditzler/soil/app/assets/images/world-#{self.id}.png")
        pngx.save("/Users/coleditzler/Desktop/worldstorage/world-#{rand(10000)}.png")
        #next_frame
    end


    def plant_logic

        some_kind_of_catching_box = []
        World.all.first.paths.all.each do |paths|
            if paths.plants
                paths.plants.each do |planter|
                some_kind_of_catching_box << planter
                end
            end
        end

        
        some_kind_of_catching_box.each do |plant|  
            pathspot = plant.path
                if pathspot.energy > plant.growthrate
                        plant.energy += plant.growthrate
                        pathspot.energy -= plant.growthrate
                        puts plant
                end

            if  plant.energy > 11000
                    plant.energy -= 1000
                Egg.create(name: 11, status: 1,  typisch: 11, itraits: "#{fuzzer_c(plant.r)},#{fuzzer_c(plant.g)},#{fuzzer_c(plant.b)},7,0,1000,#{(plant.growthrate+1)},1,2,#{plant.inventory+1}", pod_id: plant.id, pod_type: "Plant")       
            end

    plant.save
    pathspot.save
    end
end


def herbivore_logic

    Herbivore.all.each do |herbivore|
        pathspot = herbivore.path
        if herbivore.energy > herbivore.growthrate
            herbivore.path.energy += herbivore.growthrate
            herbivore.energy -= herbivore.growthrate
        else
            herbivore.destroy
        end


        if herbivore.path.plants

            herbivore.path.plants.each do |edible| 
                herbivore.energy += edible.energy
                edible.eggs.each do |egg|
                    egg.pod_type = "Herbivore"
                    egg.pod_id = herbivore.id
                    egg.save
                end
                edible.energy = 0
                edible.destroy
            end

        end

        if herbivore.eggs.length >= 0
            if rand(100) == 0
                herbivore.eggs.each do |egg|
                    egg.pod_type = "Path"
                    egg.pod_id = herbivore.path.id
                    egg.save
                end
            end
        end

        if herbivore.energy > 110000
            Herbivore.create(r: fuzzer_c(herbivore.r), g: fuzzer_c(herbivore.g),  b: fuzzer_c(herbivore.b), name: 7, depth: 0, energy: 55000, growthrate: fuzzer_c(herbivore.growthrate),  status: 1,  typisch: 6, inventory: (herbivore.inventory+1), path_id: pathspot.id)
            herbivore.energy = (herbivore.energy/2).to_i
        end

        herbivorex = pathspot.x
        herbivorey = pathspot.y

        herbivorey += rand(-1..1)
        herbivorex += rand(-1..1)

        herbivory = [herbivorey, 0].max
        herbivorx = [herbivorex, 0].max
        herbivorx = [herbivorex, self.width-1].min
        herbivory = [herbivorey, self.width-1].max

        herbivore.path = Path.find_by(x: herbivorex, y: herbivorey)


        herbivore.save
    end
end

    def predator_logic

        Predator.all.each do |predator|
            pathspot = predator.path
            if predator.energy > predator.growthrate
                predator.path.energy += predator.growthrate
                predator.energy -= predator.growthrate
            else
                predator.destroy
            end
    
    
            if predator.path.herbivores
    
                predator.path.herbivores.each do |edible| 
                    predator.energy += edible.energy
                    edible.energy = 0
                    edible.destroy
                end
    
            end
    
            if predator.energy > 1100000
    
                Predator.create(r: fuzzer_c(predator.r), g: fuzzer_c(predator.g),  b: fuzzer_c(predator.b), name: 7, depth: 0, energy: 550000, growthrate: fuzzer_c(predator.growthrate),  status: 1,  typisch: 6, path_id: pathspot.id)
    
                predator.energy = (predator.energy/2).to_i
            end
    
            predatorx = pathspot.x
            predatory = pathspot.y

     #       World.all.first.  #sight?


    
            predatory += rand(-1..1)
            predatorx += rand(-1..1)
    
            herbivory = [predatory, 0].max
            herbivorx = [predatorx, 0].max
            herbivorx = [predatorx, self.width-1].min
            herbivory = [predatory, self.width-1].max
    
            predator.path = Path.find_by(x: predatorx, y: predatory)
    
    
            predator.save
        end
    
    
end

def weather_logic(pngx)
    Weather.all.each do |thesun|
    if rand(0..3) == 0
        if rand(0..1) == 0
      #  thesun.y -= 1
        else
        #    thesun.y += 1
        end
        end


        
        longitude = thesun.path.x
        latitude = thesun.path.y
        longitude -= 7
        latitude -= 15
        thesun.a = 5
       # thesun.r = 255
       # thesun.b = 255
       # thesun.g = 255

       width = World.all.first.width
       height =World.all.first.height




        if latitude < 0
            latitude = height-1
        end

        if longitude < 0
            longitude = width-1
        end
        if latitude  > height-1
            latitude = 0
        end

        if longitude > width-1
            latitude = 0
        end

        thesun.path = Path.find_by(x: longitude, y: latitude)
        thesun.save

        minrange = [width, height].min

        solarsize = 145
        solarsize.times do
        
                    y = 0-(solarsize/2)
                    x = 0-(solarsize/2)
                    (solarsize).times do
                        (solarsize).times do
                            if (solarsize %  12)  == 0
                            fuzzx = x + longitude
                            fuzzy = y + latitude
=begin
                            if fuzzx > 49
                                fuzzx = (fuzzx - (width-1))
                                if fuzzx < 0
                                    fuzzx = 0
                                end
                            end
                            if fuzzy > 49
                                fuzzy = (fuzzy - (height-1))
                                if fuzzy < 0
                                    fuzzy = 0
                                end
                            end
                            if fuzzx < 1
                                fuzzx = (fuzzx + width-1)
                            end
                            if fuzzy < 1
                                fuzzy = (fuzzy +  (height-1))
                            end
           
                            if fuzzx <= -1
                                fuzzx = (fuzzx % (width-1))
                            end
                            if fuzzy <= -1
                                  fuzzy = (fuzzy % (height-1))
                              end   
=end

                        fuzzx = fuzzx%width
                        fuzzy = fuzzy%height



                        red = ChunkyPNG::Color.r(pngx[fuzzx, fuzzy]) *255
                        green = ChunkyPNG::Color.g(pngx[fuzzx, fuzzy]) *255
                        blue =  ChunkyPNG::Color.b(pngx[fuzzx, fuzzy]) *255
                        thesunred =  thesun.r * (thesun.a)
                        thesungreen =  thesun.g * (thesun.a)
                        thesunblue = thesun.b * (thesun.a)
                        red = [((thesunred+red)/255).to_i, 255].min
                        green = [((thesungreen+green)/255).to_i, 255].min
                        blue = [((thesunblue+blue)/255).to_i, 255].min
                        pngx[fuzzx, fuzzy] = ChunkyPNG::Color.rgba(red, green, blue, 255) #renders to the screen

        #    guuut = Path.find_by(x: fuzzx, y: fuzzy)

        #     shine(guuut) ## the shine method interacts with the energy of water, plants and soil moisture. 

                    end
                    x+=1
                    end
                    x = 0-(solarsize/2)
                    y+=1
                    end
                    y= 0-(solarsize/2)
                            solarsize -=1  
                end             
        end

end

=begin

def  weather_logic(pngx)

    Weather.all.each  do |thesun|



        
        longitude = thesun.path.x
        latitude = thesun.path.y
        

        longitude = longitude - 3

        if longitude < 0
            longitude = (self.width-1)
        end
        if longitude > (self.width-1)
            longitude = 0
        end 



        if latitude < 0
            latitude = (self.height-1)
        end
        if latitude > (self.height-1)
            latitude = 0
        end 
## beginning of paste







minrange = [self.width, self.height].min
    
solarsize = 40
solarsize.times do

            y = 0-(solarsize/2)
            x = 0-(solarsize/2)
            (solarsize).times do
                (solarsize).times do
                    if (solarsize %  (self.width ** (1.to_f/3.to_f)).to_i) == 0
                    fuzzx = x + longitude
                    fuzzy = y + latitude
            
                    if fuzzx > self.width 
                        fuzzx = (fuzzx - self.width)
                        if fuzzx < 0
                            fuzzx = 0
                        end
                    end
                    if fuzzy > self.height 
                        fuzzy = (fuzzy - self.height)
                        if fuzzy < 0
                            fuzzy = 0
                        end
                    end
                    if fuzzx < 0
                        fuzzx = (fuzzx + self.width)
                    end
                    if fuzzy < 0
                        fuzzy = (fuzzy +  self.height)
                    end
   
                    if fuzzx <= -1
                        fuzzx = (fuzzx % self.width)
                    end
                    if fuzzy <= -1
                          fuzzy = (fuzzy % self.height)
                      end   

                      fuzzx =  [fuzzx, 0].max
                      fuzzx =  [fuzzx, (self.width-1)].min


                      fuzzy =  [fuzzy, 0].max
                      fuzzy =  [fuzzy, (self.height-1)].min

                red = ChunkyPNG::Color.r(pngx[fuzzx, fuzzy]) *255
                green = ChunkyPNG::Color.g(pngx[fuzzx, fuzzy]) *255
                blue =  ChunkyPNG::Color.b(pngx[fuzzx, fuzzy]) *255
                thesunred =  thesun.r *20 #(thesun.a)
                thesungreen =  thesun.g *20 #(thesun.a)
                thesunblue = thesun.b *20# (thesun.a)
                red = [((thesunred+red)/255).to_i, 255].min
                green = [((thesungreen+green)/255).to_i, 255].min
                blue = [((thesunblue+blue)/255).to_i, 255].min
                pngx[fuzzx, fuzzy] = ChunkyPNG::Color.rgba(red, green, blue, 255) #renders to the screen

                    end
                end
            end
        end
       #       guuut = Path.find_by(x: fuzzx, y: fuzzy)

      #         shine(guuut.x, guuut.y) ## the shine method interacts with the energy of water, plants and soil moisture. 


















#end of paste
    end  #end of Weather.all.each  do |thesun| 
end
=end
def fuzzer_c(num)

    num += rand(-10...10)

    if num < 1
        num = 1
    end

    if num > 255
        num = 255
    end

    num
end


def shine(soilspot)

    if rand(100) == 0

   if soilspot.eggs.all.length > 0
            eag = soilspot.eggs.all[rand(soilspot.eggs.all.length)]

            traits = eag.itraits.split(',')

            Plant.create(r: traits[0], g: traits[1], b: traits[2], name: traits[3], depth: traits[4], energy: traits[5], growthrate: traits[6], status: traits[7], inventory:0, path_id: soilspot.id )

            #Plant.create(r: 0, g: (rand(55)+200), b: 0, name: 7, depth: 0, energy: 1000000,  growthrate: 5000, status: 1,  typisch: 2, inventory: 0, path_id: World.find(worldone.id).paths[rand((worldone.height*worldone.width))].id)

            eag.destroy   
        end
    end
end


end
