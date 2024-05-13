```ruby
# This Ruby code translates the provided Go code to print the list of trusted checkpoints
# for each known network.

# Define the TrustedCheckpoint class to represent a trusted checkpoint
class TrustedCheckpoint
  attr_reader :section_index, :section_head, :cht_root, :bloom_root

  # Constructor to initialize the TrustedCheckpoint object
  def initialize(section_index, section_head, cht_root, bloom_root)
    @section_index = section_index
    @section_head = section_head
    @cht_root = cht_root
    @bloom_root = bloom_root
  end

  # Method to check if the checkpoint is empty
  def empty?
    @section_head.nil? || @section_head.empty? || @cht_root.nil? || @cht_root.empty? || @bloom_root.nil? || @bloom_root.empty?
  end

  # Method to calculate the hash of the checkpoint
  def hash
    return '' if empty?

    data = [@section_index].pack('Q>')
    data << [@section_head].pack('H*')
    data << [@cht_root].pack('H*')
    data << [@bloom_root].pack('H*')

    Digest::SHA3.hexdigest(data)
  end
end

# Define the CheckpointOracleConfig class to represent the configuration of the checkpoint oracle
class CheckpointOracleConfig
  attr_reader :address, :signers, :threshold

  # Constructor to initialize the CheckpointOracleConfig object
  def initialize(address, signers, threshold)
    @address = address
    @signers = signers
    @threshold = threshold
  end
end

# Define the ChainConfig class to represent the core configuration for a blockchain network
class ChainConfig
  attr_reader :chain_id, :homestead_block, :dao_fork_block, :dao_fork_support, :eip150_block, :eip150_hash, :eip155_block, :eip158_block, :byzantium_block, :constantinople_block, :petersburg_block, :istanbul_block, :muir_glacier_block, :berlin_block, :london_block, :arrow_glacier_block, :merge_fork_block, :terminal_total_difficulty, :ethash, :clique

  # Constructor to initialize the ChainConfig object
  def initialize(chain_id, homestead_block, dao_fork_block, dao_fork_support, eip150_block, eip150_hash, eip155_block, eip158_block, byzantium_block, constantinople_block, petersburg_block, istanbul_block, muir_glacier_block, berlin_block, london_block, arrow_glacier_block, merge_fork_block, terminal_total_difficulty, ethash, clique)
    @chain_id = chain_id
    @homestead_block = homestead_block
    @dao_fork_block = dao_fork_block
    @dao_fork_support = dao_fork_support
    @eip150_block = eip150_block
    @eip150_hash = eip150_hash
    @eip155_block = eip155_block
    @eip158_block = eip158_block
    @byzantium_block = byzantium_block
    @constantinople_block = constantinople_block
    @petersburg_block = petersburg_block
    @istanbul_block = istanbul_block
    @muir_glacier_block = muir_glacier_block
    @berlin_block = berlin_block
    @london_block = london_block
    @arrow_glacier_block = arrow_glacier_block
    @merge_fork_block = merge_fork_block
    @terminal_total_difficulty = terminal_total_difficulty
    @ethash = ethash
    @clique = clique
  end

  # Method to check if the block number is equal to or greater than the given block number
  def forked?(block_number, fork_block)
    return true if fork_block.nil?

    block_number >= fork_block
  end

  # Method to check if the block number is equal to or greater than the Homestead block number
  def homestead?(block_number)
    forked?(block_number, @homestead_block)
  end

  # Method to check if the block number is equal to or greater than the DAO fork block number
  def dao_fork?(block_number)
    forked?(block_number, @dao_fork_block)
  end

  # Method to check if the block number is equal to or greater than the EIP150 block number
  def eip150?(block_number)
    forked?(block_number, @eip150_block)
  end

  # Method to check if the block number is equal to or greater than the EIP155 block number
  def eip155?(block_number)
    forked?(block_number, @eip155_block)
  end

  # Method to check if the block number is equal to or greater than the E