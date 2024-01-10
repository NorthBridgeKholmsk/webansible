class Playbook < ApplicationRecord
  validates :name, :presence => true, :uniqueness => true, :length => { :in => 3..64 }
end
