class User < ActiveRecord::Base
  include CohortModelExtensions

  acts_as_authentic
  has_many :notes, :dependent => :destroy
  has_many :log_items, :dependent => :destroy

  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i

  validates_uniqueness_of :login

  before_destroy :check_if_deleteable

  def create_random_password
    #eliminate capital I and lowercase l and uppercase O to minimize confusion
    password_seed = %W|A B C D E F G H i J K L M N o P Q R S T U V W X Y Z a b c d e f g h j k m n p q r s t u v w x y z 0 2 3 4 5 6 7 8 9 - ! .|

    password_length = [12,13,14,15,16]
    pass = '' 
    password_length[Kernel.rand(password_length.length)].times do 
      pass += password_seed[Kernel.rand(password_seed.length)].to_s
    end
    self.password = pass
    self.password_confirmation = pass
  end

  def self.system_user
    self.find_by_login('importer')
  end

end
