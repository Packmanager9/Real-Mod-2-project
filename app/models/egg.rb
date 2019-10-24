class Egg < ApplicationRecord
    belongs_to :pod, polymorphic: true
end
