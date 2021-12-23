require "matrix"
require_relative "qar/extensions/extensions"

# This class represents quantum logic gates as matrices.
# List of implemented quantum gates:
# X_GATE
# Y_GATE
# Z_GATE
# H_GATE
# T_GATE
# C_NOT_GATE
# SWAP_GATE
# TOFFOLI_GATE
class Gate < Matrix
  # Operation,that applies the effect on both qubits and states containing an array of qubits
  def *(*args)
    case args[0]
    when Qubit
      qubits = []
      args = args.map do |i|
          qubits << i
          i.vector
      end.inject{|p,a| Matrix.kronecker(p,a)}
      qubits=measure(qubits, super(args))
      State.new(*qubits)


    when State
      qubits = []
      temp=[]
      args.map do |i|
        i.qubits.map do |j|
          qubits << j
          temp << j.vector
          end
      end
      args=temp.inject{|p,a| Matrix.kronecker(p,a)}
      qubits=measure(qubits, super(args))
      State.new(*qubits)
    else
      super(*args)
    end
  end

  private
  # Function that takes array of qubits and their Kronecker product and calculates new state.
  # Works properly only for single qubits. For multiple qubits, Kronecker product of qubits become entangled
  def measure(qubits, vector)
    cnt=qubits.count()
    case cnt
    when 1
      vector=vector.to_a.flatten
      return [Qubit.new(vector[0],vector[1])]
    when 2
      vector=vector.to_a.flatten
      return [Qubit.new(vector[0],vector[1]),Qubit.new(vector[2],vector[3])]
    when 3
      vector=vector.to_a.flatten
      return [Qubit.new(vector[0],vector[1]),Qubit.new(vector[2],vector[3]),Qubit.new(vector[4],vector[5])]
    else
      return raise GateArgumentException
    end
  end
end

X_GATE = Gate[
  [0, 1],
  [1, 0]]

Y_GATE = Gate[
  [0, -1i],
  [1i, 0]]

Z_GATE = Gate[
  [1,  0],
  [0, -1]]

H_GATE = 1 / Math.sqrt(2) * Gate[
  [1,  1],
  [1, -1]]

T_GATE = Gate[
  [1,0],
  [0, Math::E**((1i * Math::PI) / 4)]]

CNOT_GATE = Gate[
  [1, 0, 0, 0],
  [0, 1, 0, 0],
  [0, 0, 0, 1],
  [0, 0, 1, 0]]

SWAP_GATE = Gate[
  [1, 0, 0, 0],
  [0, 0, 1, 0],
  [0, 1, 0, 0],
  [0, 0, 0, 1]]

TOFFOLI_GATE = Gate[
  [1, 0, 0, 0, 0, 0, 0, 0],
  [0, 1, 0, 0, 0, 0, 0, 0],
  [0, 0, 1, 0, 0, 0, 0, 0],
  [0, 0, 0, 1, 0, 0, 0, 0],
  [0, 0, 0, 0, 1, 0, 0, 0],
  [0, 0, 0, 0, 0, 1, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 1],
  [0, 0, 0, 0, 0, 0, 1, 0]]
