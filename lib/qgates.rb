require "matrix"
require_relative "qar/extensions/extensions"

class Gate < Matrix

  include QuantumException
  def *(*args)
    if ((2*args.count)!=self.column_count)
      raise GateArgumentException
    end

    case args[0]
    when Qubit
      qubits = []
      args = args.map do |i|
        qubits << i
      end.reduce(:kronecker)
      State.new(*qubits)
    when State
      qubits = []
      args = args.map do |i|
        qubits << i.qubits
      end.reduce(:kronecker)
      State.new(qubits)
    else
      super(*args)
    end
  end

  # TEMP function for Kronecker Product
  def kronecker(m)
    res=Matrix[[1,0],[0,1]]
    return res
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
