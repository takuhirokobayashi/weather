class WindDirection < ApplicationRecord
  has_many :measurements

  validates :compass_direction, presence: true, uniqueness: true
end
