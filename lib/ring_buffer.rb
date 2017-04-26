require_relative "static_array"

class RingBuffer
  attr_reader :length

  def initialize(length = 0, capacity = 8)
    @length = length
    @store = StaticArray.new(capacity)
    @capacity = capacity
    @start_idx = 0
  end

  # O(1)
  def [](index)
    self.check_index(index)
    ring_index = (@start_idx + index) % @capacity
    @store[ring_index]
  end

  # O(1)
  def []=(index, val)
    self.check_index(index)
    ring_index = (@start_idx + index) % @capacity
    @store[ring_index] = val
  end

  # O(1)
  def pop
    raise "index out of bounds" if @length <= 0
    ring_index = (@length - 1 + @start_idx) % @capacity
    popped = @store[ring_index]
    @store[ring_index] = nil
    @length -= 1
    popped
  end

  # O(1) ammortized
  def push(val)
    self.resize! if @capacity == @length
    ring_index = (@length + @start_idx) % @capacity
    @length += 1
    @store[ring_index] = val
  end

  # O(1)
  def shift
    raise "index out of bounds" if @length <= 0
    shift_num = @store[@start_idx]
    @store[@start_idx] = nil
    @length -= 1
    @start_idx = (@start_idx += 1) % @capacity
    # puts shift_num
    shift_num
  end

  # O(1) ammortized
  # []  [0]  [1, 0] [2, 1, 0]
  # length = 0, capacity = 8
  # start_idx = 0
  def unshift(val)
    self.resize! if @capacity == @length
    # @start_idx = @length == 0 ? 0 : @start_idx - 1
    new_start_idx = (@start_idx - 1) % @capacity
    @start_idx = new_start_idx
    # puts "unshift #{val} index #{new_start_idx}"
    @store[new_start_idx] = val
    @length += 1
    # puts @store[new_start_idx]
  end

  protected
  attr_accessor :capacity, :start_idx, :store
  attr_writer :length

  def check_index(index)
    raise "index out of bounds" if index >= @length
  end

  def resize!
    prev_capacity = @capacity
    @capacity *= 2
    new_store = StaticArray.new(@capacity)

    i = 0

    while i < @length
      new_store[i] = @store[(@start_idx + i) % prev_capacity]
      i += 1
      # p new_store
    end
    @store = new_store
    @start_idx = 0
  end
end
