class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :http_authenticatable, :token_authenticatable, :lockable, :timeoutable and :activatable
  devise :registerable, :authenticatable, :confirmable, :recoverable,
         :rememberable, :trackable, :validatable


  field :email #  t.string,  :null               => false
  field :encrypted_password # t.string, :limit   => 40, :null => false
  field :password_salt # t.string, :null         => false
  field :confirmation_token # t.string, :limit   => 20
  field :confirmed_at # t.datetime
  field :confirmation_sent_at # t.datetime
  field :reset_password_token # t.string, :limit => 20
  field :remember_token # t.string, :limit       => 20
  field :remember_created_at # t.datetime
  field :sign_in_count # t.integer
  field :current_sign_in_at # t.datetime
  field :last_sign_in_at # t.datetime
  field :current_sign_in_ip # t.string
  field :last_sign_in_ip # t.string
  field :failed_attempts # t.integer, :default   => 0
  field :unlock_token # t.string, :limit         => 20
  field :locked_at # t.datetime
  field :created_at # t.datetime
  field :updated_at # t.datetime


end
