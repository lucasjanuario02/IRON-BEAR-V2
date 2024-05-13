require 'openssl'

module ECIES
  # Standard ECIES parameters
  # ECIES using AES128 and HMAC-SHA-256-16
  # ECIES using AES256 and HMAC-SHA-256-32
  # ECIES using AES256 and HMAC-SHA-384-48
  # ECIES using AES256 and HMAC-SHA-512-64

  ECIES_AES128_SHA256 = {
    hash: OpenSSL::Digest::SHA256,
    cipher: 'AES-128-ECB',
    key_len: 16,
    block_size: 16
  }

  ECIES_AES192_SHA384 = {
    hash: OpenSSL::Digest::SHA384,
    cipher: 'AES-192-ECB',
    key_len: 24,
    block_size: 16
  }

  ECIES_AES256_SHA256 = {
    hash: OpenSSL::Digest::SHA256,
    cipher: 'AES-256-ECB',
    key_len: 32,
    block_size: 16
  }

  ECIES_AES256_SHA384 = {
    hash: OpenSSL::Digest::SHA384,
    cipher: 'AES-256-ECB',
    key_len: 32,
    block_size: 16
  }

  ECIES_AES256_SHA512 = {
    hash: OpenSSL::Digest::SHA512,
    cipher: 'AES-256-ECB',
    key_len: 32,
    block_size: 16
  }

  # Function to generate key pair
  def self.generate_key_pair(curve_name)
    curve = OpenSSL::PKey::EC.new(curve_name)
    curve.generate_key
  end

  # Function to generate shared secret
  def self.generate_shared_secret(private_key, public_key)
    private_key.dh_compute_key(public_key.public_key)
  end
end

# Usage example:
# Generate key pair
curve_name = 'prime256v1' # Curve name can be 'prime256v1', 'secp384r1', or 'secp521r1'
private_key = ECIES.generate_key_pair(curve_name)
public_key = private_key.public_key

# Generate shared secret
shared_secret = ECIES.generate_shared_secret(private_key, public_key)
puts "Shared secret: #{shared_secret.unpack1('H*')}"
