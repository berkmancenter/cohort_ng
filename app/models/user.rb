class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, #:registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :lockable

  acts_as_authorization_subject  :association_name => :roles

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :url 

  include CohortModelExtensions

  has_many :notes#, :dependent => :destroy
  has_many :log_items#, :dependent => :destroy

  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i

  before_destroy :check_if_deleteable
  #after_create :post_save_hooks

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
    self.find_by_email('importer-no-reply@example.com')
  end
  
  def self.random_password(size = 11)
    chars = (('a'..'z').to_a + ('0'..'9').to_a) - %w(i o 0 1 l 0)
    (1..size).collect{|a| chars[rand(chars.size)] }.join
  end
  
  def post_save_hooks
    Email.create(
      :from => DEFAULT_MAILER_SENDER,
      :reply_to => DEFAULT_MAILER_SENDER,
      :to => self.email,
      :subject => "Your Cohort Account Has Been Created",
      :body => %Q|<p>Welcome to Cohort.</p><p>Your login is: #{self.email}. Please visit <a href="#{ROOT_URL}/users/password/new">Inscriptio</a> to create a new password and log into your account.</p>|
    )
  end

end
