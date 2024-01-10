class HostType < ApplicationRecord
  validates :id_type, :presence => true, :uniqueness => true, :length => { :in => 3..64 }
  validates :name, :presence => true, :uniqueness => true, :length => { :in => 3..64 }
end
