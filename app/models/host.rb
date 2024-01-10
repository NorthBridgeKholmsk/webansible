class Host < ApplicationRecord
  #attr_accessor :password
  validates :hostname, :presence => true, :uniqueness => true, :length => { :in => 3..64 }
  validates :address, :presence => true, :uniqueness => true, :length => { :in => 3..64 }
  validates :login, :presence => true, :uniqueness => false, :length => { :in => 3..64 }
  validates :password, :presence => true, :uniqueness => false, :length => { :in => 3..64 }, :on => :create
  validates :host_type_id, :presence => true, :uniqueness => false
  validates :os, :presence => true, :uniqueness => false, :length => { :in => 3..64 }
  validates :host_role, :presence => true, :uniqueness => false
  validates :group_id, :presence => true, :uniqueness => false
end
