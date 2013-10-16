# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
Kinesis::Application.config.secret_key_base = 'defab78d08ab1a2abc9640268f5371d24b4178005e5e088980376c5635dd4ab7e5fa8352946b14f20c92318472703809436a5ac985146879c3e62409f3097713'
