class Plant < ApplicationRecord


    validates :g, :r, :b, presence: true
    validates :r, numericality: true
    validates :r, numericality: { greater_than_or_equal_to: 0 }
    validates :r, numericality: { less_than_or_equal_to: 255 }
    validates :g, numericality: true
    validates :g, numericality: { greater_than_or_equal_to: 0 }
    validates :g, numericality: { less_than_or_equal_to: 255 }
    validates :b, numericality: true
    validates :b, numericality: { greater_than_or_equal_to: 0 }
    validates :b, numericality: { less_than_or_equal_to: 255 }
    belongs_to :path
    has_many :eggs, as: :pod




    def self.average_energy
            x = 0
            Plant.all.each do |plant| x += plant.energy end
                avg = (x.to_f/Plant.all.length)
                avg
    end



end
