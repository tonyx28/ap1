require_relative "static_array"

class DynamicArray
  attr_reader :length

  def initialize(length = 0, capacity = 8)
    @length = length
    @store = StaticArray.new(length)
    @capacity = capacity
  end

  # O(1)
  def [](index)
    self.check_index(index)
    @store[index]
  end

  # O(1)
  def []=(index, value)
    self.check_index(index)
    @store[index] = value
  end

  # O(1)
  def pop
    raise "index out of bounds" if @length <= 0
    @store[@length - 1] = nil
    @length -= 1
  end

  # O(1) ammortized; O(n) worst case. Variable because of the possible
  # resize.
  def push(val)
    self.resize! if @capacity == @length
    @store[@length] = val
    @length += 1
  end

  # O(n): has to shift over all the elements.
def shift
    raise "index out of bounds" if @length <= 0
    shift_num = @store[0]
    i = 1
    while i < @length
      @store[i - 1] = @store[i]
      i += 1
    end
    @length -= 1
    shift_num
  end

  # O(n): has to shift over all the elements.
  def unshift(val)
    self.resize! if @capacity == @length
    @length += 1
    i = @length
    while i > 0
      @store[i] = @store[i - 1]
      i -= 1
    end
    @store[0] = val
  end

  protected
  attr_accessor :capacity, :store
  attr_writer :length

  def check_index(index)
    raise "index out of bounds" if index >= @length || index < 0
  end

  # O(n): has to copy over all the elements to the new store.
  def resize!
    new_store = StaticArray.new(@length)
    @capacity = @capacity * 2
    i = 0
    while i < @length
      new_store[i] = @store[i]
      i += 1
    end

    @store = new_store
  end
end
