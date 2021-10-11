# frozen_string_literal: true

require_relative "quantum_exception"
require_relative "extensions/extensions"

# Contains help methods for classes which use operations above vectors
# such as Qubit class
module VectorHelper
  include QuantumException

  ACCURACY = 10
  # Check if current vector is normalized: |x1| + |x2| + ... |xn| = 1
  # with current accuracy
  def normalized?
    @vector.inject(0) { |sum, el| sum + el.abs2 }.round(ACCURACY) == 1
  end
end
