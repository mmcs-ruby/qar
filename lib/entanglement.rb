require "qbit"
require "vector_helper"

# The +Entanglement+ class represents a combination of qubits' superpositions.
# It contains an array of qubits.
#
class Entanglement
  attr_reader :qubits, :size, :number_of_variants

  include QuantumException

  # Takes an array of qubits.
  # Qubits must be normalized.
  def initialize(*qubits)
    raise EmptyEntanglementException if qubits.empty?
    @qubits = qubits
    @size = @qubits.size
    # number of variants
    @number_of_variants = 1 << @size

    @qubits.each do |qubit|
      check_entanglement_constraint(qubit)
      bind_qubit_with_entanglement(qubit)
    end
    self
  end

  # Measures the entanglement, result is stored as integer.
  # Every bit of the integer represent a state of every entanglement's qubit.
  def measure!
    return self if measured?
    r = rand + 1e-10

    # a kind of a weak tensor product
    generally_probability = 0
    (0...@number_of_variants).each do |i|
      probability_amplitude = 1
      (0...@size).each { |bit_index| probability_amplitude *= @qubits[bit_index].vector[i[bit_index], 0] }
      generally_probability += probability_amplitude.abs2
      next if generally_probability < r

      (0...@size).each { |bit_index| @qubits[bit_index].vector = (i[bit_index].zero? ? [1, 0] : [0, 1]) }
      @measuring = i
      return self
    end
    raise NormalizationException
  end

  # Returns a measured deep copy of this instance.
  def measure
    deep_dup.measure!
  end

  # Checks whether this instance was measured.
  def measured?
    !@measuring.nil?
  end

  # Returns a string representation of this instance.
  # Hides possibility amplitudes if they are zero.
  def to_s(digits = 3)
    if measured?
      out = "|#{@measuring.to_s(2).rjust(@size, "0")}>"
    else
      out = ""
      (0...@number_of_variants).each do |i|
        probability_amplitude = 1
        (0...@size).each { |bit_index| probability_amplitude *= @qubits[bit_index].vector[i[bit_index], 0] }
        next if probability_amplitude.zero?

        out << " + " unless out.empty?
        out << "#{probability_amplitude.round(digits).to_s}|#{i.to_s(2).rjust(@size, "0")}>"
      end
    end
    out
  end

  # Adds a qubit to right side of sequence of qubits.
  def push!(*qubits)
    extend_entanglement_by(*qubits, :right)
  end

  # Returns the entanglement with qubits added to right side.
  def push(*qubits)
    deep_dup.send(:extend_entanglement_by, *qubits, :right)
  end

  alias add push

  # Adds a qubit to left side of sequence of qubits.
  def unshift!(*qubits)
    extend_entanglement_by(*qubits, :left)
  end

  # Returns the entanglement with qubits added to left side.
  def unshift(*qubits)
    deep_dup.send(:extend_entanglement_by, *qubits, :left)
  end

  # Same as push.
  def *(qubit)
    deep_dup.push(qubit)
  end

  # Returns deep copy of the entanglement.
  def deep_dup
    (tmp = dup).instance_variable_set(:@qubits, @qubits.map { |qubit| qubit.dup })
    tmp
  end

  def to_str
    to_s
  end

  private

  # Checks entanglement requirement:
  # a sum of | products of possibility amplitudes of different qubits |^2 must be equal 1.
  def check_entanglement_constraint(*qubits)
    qubits.each { |qubit| raise ReEntanglementException if qubit.entangled? && qubit.entanglement.include?(self) }
    self
  end

  # Adds qubit reference to specified entanglement.
  def bind_qubit_with_entanglement(qubit)
    if qubit.entanglement.nil?
      qubit.instance_variable_set(:@entanglement, [self])
    else
      qubit.instance_exec(self) { |this| @entanglement << this }
    end
    self
  end

  # Updates measuring parameter.
  def update_current_measuring(*qubits, where)
    if qubits.all? { |qubit| qubit.measured? } && measured?

      qubits_measuring = Entanglement.new(*qubits).measure!.instance_variable_get(:@measuring)
      @measuring = (@measuring << qubits.size) + qubits_measuring if where == :right
      @measuring += qubits_measuring if where == :left && !qubits_measuring.zero?
    else
      @measuring = nil
    end
    self
  end

  # Combine some private methods for extending the entanglement with a specified side.
  def extend_entanglement_by(*qubits, where)
    check_entanglement_constraint(*qubits)
    qubits.each { |qubit| bind_qubit_with_entanglement(qubit) }

    @qubits += qubits if where == :right
    @qubits = qubits + @qubits if where == :left
    @size += qubits.size
    @number_of_variants <<= qubits.size

    update_current_measuring(*qubits, where)
    self
  end
end

State = Entanglement
