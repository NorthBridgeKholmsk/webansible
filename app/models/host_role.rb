class HostRole < ApplicationRecord
  validates :id_role, :presence => true, :uniqueness => true, :length => { :in => 3..64 }
  validates :name, :presence => true, :uniqueness => true, :length => { :in => 3..64 }
end
