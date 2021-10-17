require "matrix"
require_relative "vector_helper"
require_relative "qar/extensions/qar/extensions"

ZERO_PROB = "|0>".freeze
ONE_PROB = "|1>".freeze

# Qubit class is quantum bit abstraction. It contains 2 - dimensional vector
# which represents probability of 0 and 1
# Qubit can be measured or multiplicative
class Qubit
  attr_reader :vector
  attr_accessor :entanglement

  include VectorHelper

  # Initialization by two probability of zero and one
  # Probabilities should be normalized: |a|^2 + |b|^2 = 1
  def initialize(zero_prob, one_prob)
    self.vector = [zero_prob, one_prob]
  end

  def vector=(vector)
    @vector = Matrix.column_vector(vector)
    raise NormalizationException unless normalized?
  end

  # Measurement give information about current qubit that is
  # use probabilities of one and zero to give the answer what
  # qubit contains now
  def measure
    if rand <= @vector[0, 0].abs2
      @vector = [1, 0]
      0
    else
      @vector = [0, 1]
      1
    end
  end

  # Returns zero's probability
  def zero_probability
    @vector[0, 0].round(ACCURACY)
  end

  # Returns one's probability
  def one_probability
    @vector[1, 0].round(ACCURACY)
  end

  # Returns true if entangled with another bit
  def entangled?
    @entanglement
  end

  def to_s
    return if entangled?

    zero = zero_probability
    one = one_probability

    str = ""

    str << zero.to_s << ZERO_PROB unless zero.zero?
    str << " + " unless zero.zero? || one.zero?
    str << one.to_s << ONE_PROB unless one.zero?

    str
  end
end
