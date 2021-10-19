require "qbit"
require "vector_helper"

class Entanglement
  attr_accessor :qubits

  include QuantumException

  def initialize(*qubits)
    @qubits = qubits
    @size = @qubits.size
    # number of variants
    @nov = 2**@size

    @qubits.each do |q|
      if q.entanglement.nil?
        q.entanglement = [self]
      elsif q.entanglement.include? self
        raise ReEntanglementException
      else
        q.entanglement << self
      end
    end

    self
  end

  def measure
    r = rand + 1e-10

    # a kind of a weak tensor product
    generally_probability = 0
    (0...@nov).each do |i|
      probability_amplitude = 1
      (0...@size).each { |bit_index| probability_amplitude *= @qubits[bit_index].vector[i[bit_index], 0] }
      generally_probability += probability_amplitude.abs2
      next if generally_probability < r

      (0...@size).each { |bit_index| @qubits[bit_index].vector = (i[bit_index].zero? ? [1, 0] : [0, 1]) }
      @measuring = i
      return self
    end
    self
  end

  def measured?
    !@measuring.nil?
  end

  def to_s(digits = 3)
    if measured?
      out = "|"
      out << @measuring.to_s(2).rjust(@size, "0")
      out << ">"
    else
      out = ""
      (0...@nov).each do |i|
        probability_amplitude = 1
        (0...@size).each { |bit_index| probability_amplitude *= @qubits[bit_index].vector[i[bit_index], 0] }
        next if probability_amplitude.zero?

        out << probability_amplitude.round(digits).to_s
        out << "|"
        out << i.to_s(2).rjust(@size, "0")
        out << ">"
        out << " + " unless i == @nov - 1
      end
    end
    out
  end

end

State = Entanglement
