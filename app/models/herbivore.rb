class Herbivore < ApplicationRecord
    belongs_to :path
    has_many :eggs, as: :pod
end
