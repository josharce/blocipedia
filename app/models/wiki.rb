class Wiki < ApplicationRecord
  belongs_to :user, optional: true
  serialize :collaborators, Array
end
