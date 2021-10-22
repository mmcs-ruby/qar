require "qbit"
require "vector_helper"

class Entanglement
  attr_reader :qubits, :size, :nov

  include QuantumException

  def initialize(*qubits)
    raise EmptyEntanglementException if qubits.empty?
    @qubits = qubits
    @size = @qubits.size
    # number of variants
    @nov = 1 << @size

    @qubits.each do |q|
      check_entanglement_constraint(q)
      bind_qubit_with_entanglement(q)
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
    raise NormalizationException
  end

  def measured?
    !@measuring.nil?
  end

  def to_s(digits = 3)
    if measured?
      out = "|#{@measuring.to_s(2).rjust(@size, "0")}>"
    else
      out = ""
      (0...@nov).each do |i|
        probability_amplitude = 1
        (0...@size).each { |bit_index| probability_amplitude *= @qubits[bit_index].vector[i[bit_index], 0] }
        next if probability_amplitude.zero?

        out << " + " unless out.empty?
        out << "#{probability_amplitude.round(digits).to_s}|#{i.to_s(2).rjust(@size, "0")}>"
      end
    end
    out
  end

  def push(qubit)
    extend_entanglement_by(qubit, :right)
  end

  alias add push

  def unshift(qubit)
    extend_entanglement_by(qubit, :left)
  end

=begin
  def *(other)
    self
  end
=end

  private

  def check_entanglement_constraint(object)
    case object
    when Qubit
      raise ReEntanglementException if !object.entanglement.nil? && object.entanglement.include?(self)

    when Entanglement
      object.qubits.each { |q| check_entanglement_constraint(q) }

    end
    self
  end

  def bind_qubit_with_entanglement(qubit)
    if qubit.entanglement.nil?
      qubit.instance_variable_set(:@entanglement, [self])
    else
      qubit.instance_exec(self) { |this| @entanglement << this }
    end
    self
  end

  def update_current_measuring(object, where)
    if object.measured? && measured?
      case object
      when Qubit
        @measuring = (@measuring << 1) + object.one_el if where == :right
        @measuring += (object.one_el << @size - 1) if where == :left && !object.one_el.zero?

      when Entanglement
        @measuring = (@measuring << object.size) + object.instance_variable_get(:@measuring) if where == :right
        @measuring += (object.one_el << @size - object.size) if where == :left && !object.instance_variable_get(:@measuring).zero?

      end
    else
      # how can we improve this, optimize this?
      @measuring = nil
    end
    self
  end

  def extend_entanglement_by(object, where)
    check_entanglement_constraint(object)
    case object
    when Qubit
      bind_qubit_with_entanglement(object)
      @qubits << object if where == :right
      @qubits.unshift(object) if where == :left
      @size += 1
      @nov <<= 1

    when Entanglement
      @qubits += object.qubits if where == :right
      @qubits = object.qubits + @qubits if where == :left
      @size += object.size
      @nov <<= object.size

    end
    update_current_measuring(object, where)
    self
  end
end

State = Entanglement
