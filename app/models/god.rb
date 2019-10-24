class God < ApplicationRecord

    has_many :godworlds
    has_many :worlds, through: :godworlds

end
