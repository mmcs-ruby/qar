# frozen_string_literal: true

require_relative "test_helper"

class EntanglementTest < Minitest::Test
  include QuantumException
  def test_entanglement_constructor
    assert_nothing_raised Exception do
      Entanglement.new(Qubit.generate, Qubit.generate, Qubit.generate)
    end
  end

  def test_attributes_counting_is_right
    e = Entanglement.new(Qubit.generate, Qubit.generate, Qubit.generate)
    assert_equal 3, e.size
    assert_equal 1 << 3, e.nov
  end

  def test_qubits_refer_to_correct_entanglement
    q1, q2 = Qubit.generate, Qubit.generate
    e = Entanglement.new(q1, q2)
    Entanglement.new(q2)
    assert_equal [e], q1.entanglement
    assert_equal true, q2.entanglement.include?(e)
  end

  def test_qubit_pushing_is_working_correctly
    e = Entanglement.new(Qubit.generate)
    q_right = Qubit.generate
    e.push(q_right)
    assert_equal [e], q_right.entanglement
    assert_equal e.qubits[1], q_right
    assert_equal e.size, 2
    assert_equal e.nov, 1 << 2
  end

  def test_qubit_shifting_is_working_correctly
    e = Entanglement.new(Qubit.generate)
    q_left = Qubit.generate
    e.unshift(q_left)
    assert_equal [e], q_left.entanglement
    assert_equal e.qubits[0], q_left
    assert_equal e.size, 2
    assert_equal e.nov, 1 << 2
  end

  def test_entanglement_pushing_is_working_correctly
    q1, q2, q3 = Qubit.generate, Qubit.generate, Qubit.generate
    e1 = Entanglement.new(q1)
    e2 = Entanglement.new(q2, q3)
    e1.push(e2)
    assert_equal e1.qubits, [q1, q2, q3]
    assert_equal e1.size, 3
    assert_equal e1.nov, 1 << 3
  end

  def test_entanglement_shifting_is_working_correctly
    q1, q2, q3 = Qubit.generate, Qubit.generate, Qubit.generate
    e1 = Entanglement.new(q1)
    e2 = Entanglement.new(q2, q3)
    e1.unshift(e2)
    assert_equal e1.qubits, [q2, q3, q1]
    assert_equal e1.size, 3
    assert_equal e1.nov, 1 << 3
  end

  def test_check_measuring_after_adding
    # some stub
  end

  def test_entangled_qubit_initializing_without_the_exception
    q1 = Qubit.generate
    Entanglement.new(q1)
    assert_nothing_raised ReEntanglementException do
      Entanglement.new(q1)
    end
  end

  def test_entangled_qubit_initializing_with_the_exception
    q1 = Qubit.generate
    assert_raises ReEntanglementException do
      Entanglement.new(q1, q1)
    end
  end

  def test_measuring_of_a_random_entanglement
    e = Entanglement.new(Qubit.generate, Qubit.generate, Qubit.generate)
    assert_nothing_raised NotImplementedError do
      e.measure
    end
  end

  def test_measured_is_working_right
    e = Entanglement.new(Qubit.generate, Qubit.generate, Qubit.generate)
    assert_equal false, e.measured?
    e.measure
    assert_equal true, e.measured?
  end

  def test_measuring_of_defined_entanglements
    e = Entanglement.new( Qubit.new(1, 0),
                          Qubit.new(1, 0),
                          Qubit.new(1, 0))
    assert_equal "|000>", e.measure.to_s

    e = Entanglement.new( Qubit.new(0, 1),
                          Qubit.new(1, 0),
                          Qubit.new(0, 1))
    assert_equal "|101>", e.measure.to_s

    # ...
  end

  def test_measuring_singlton_state
    # I m looking for certain probability amplitudes for qubits
  end

  def test_something_is_connected_with_Bell_states
    # ...
  end

end
