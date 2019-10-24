class Path < ApplicationRecord

belongs_to :world
has_many :eggs, as: :pod

has_many :weathers 
has_many :herbivores 
has_many :plants 
has_many :predators 

end
