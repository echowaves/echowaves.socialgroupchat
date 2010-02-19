# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key    => '_echowaves_session',
  :secret => '185ff60159b3609c1a72cefbde7bebf4990d7b47819b377da48012cead904313e439803d1a3d5eb4d648b0ec032ea5a49a89260a4d22c09f7d776eeb4d8ebf5b'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
