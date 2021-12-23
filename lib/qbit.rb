require "matrix"
require_relative "vector_helper"
require_relative "qar/extensions/extensions"

ZERO_PROB = "|0>".freeze
ONE_PROB = "|1>".freeze

# Qubit class is quantum bit abstraction. It contains 2 - dimensional vector
# which represents probability of 0 and 1
# Qubit can be measured or multiplicative
class Qbit
  attr_reader :vector
  attr_reader :entanglement

  include VectorHelper

  # Initialization by two probability of zero and one
  # Probabilities should be normalized: |a|^2 + |b|^2 = 1
  def initialize(zero_prob, one_prob)
    self.vector = [zero_prob, one_prob]
    @entanglement = nil
  end

  def self.generate
    r = rand(0.0...1.0)

    zero_prob = Math.sqrt(r)
    one_prob = 1 - Math.sqrt(r)

    r2 = rand(0.0...zero_prob)
    zero_real_prob = Math.sqrt(r2)
    zero_img_prob = Math.sqrt(zero_prob - r2)

    r3 = rand(0.0...one_prob)
    one_real_prob = Math.sqrt(r3)
    one_img_prob = Math.sqrt(one_prob - r3)

    Qbit.new(Complex(zero_real_prob,zero_img_prob), \
             Complex(one_real_prob, one_img_prob))
  end

  def vector=(vector)
    @vector = Matrix.column_vector(vector)
    raise NormalizationException unless normalized?
  end

  def nil_entanglement()
    @entanglement = nil
  end

  # Measurement give information about current qubit that is
  # use probabilities of one and zero to give the answer what
  # qubit contains now
  def measure
    return (zero_el.zero? ? 1 : 0) if measured?
    if rand <= @vector[0, 0].abs2
      set_zero
    else
      set_one
    end
  end

  # Returns zero element
  def zero_el
    @vector[0, 0].round(ACCURACY)
  end

  # Returns one element
  def one_el
    @vector[1, 0].round(ACCURACY)
  end

  # Returns true if entangled with another bit
  def entangled?
    !@entanglement.nil?
  end

  def measured?
    [0, 1].include?(zero_el)
  end

  def to_s
    left = zero_string
    return one_string if left.empty?

    right = one_string
    right.empty? ? left : "#{left} + #{right}"
  end

  #Empty if zero probability is 0
  def zero_string
    zero_el.zero? ? '' : zero_el.to_s + ZERO_PROB
  end

  def one_string
    one_el.zero? ? '' : one_el.to_s + ONE_PROB
  end

  def to_str
    to_s
  end

  def set_zero
    self.vector = [1, 0]
    0
  end

  def set_one
    self.vector = [0, 1]
    1
  end

  def set_value(value)
    set_zero if value == 0
    set_one if value == 1
  end

end

Qubit = Qbit