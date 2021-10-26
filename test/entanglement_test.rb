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
    assert_equal 1 << 3, e.number_of_variants
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
    e.push!(q_right)
    assert_equal [e], q_right.entanglement
    assert_equal e.qubits[1], q_right
    assert_equal e.size, 2
    assert_equal e.number_of_variants, 1 << 2
  end

  def test_qubit_shifting_is_working_correctly
    e = Entanglement.new(Qubit.generate)
    q_left = Qubit.generate
    e.unshift!(q_left)
    assert_equal [e], q_left.entanglement
    assert_equal e.qubits[0], q_left
    assert_equal e.size, 2
    assert_equal e.number_of_variants, 1 << 2
  end

  def test_qubits_pushing_is_working_correctly
    q1, q2, q3 = Qubit.generate, Qubit.generate, Qubit.generate
    e1 = Entanglement.new(q1)
    e1.push!(q2, q3)
    assert_equal e1.qubits, [q1, q2, q3]
    assert_equal e1.size, 3
    assert_equal e1.number_of_variants, 1 << 3
  end

  def test_entanglement_shifting_is_working_correctly
    q1, q2, q3 = Qubit.generate, Qubit.generate, Qubit.generate
    e1 = Entanglement.new(q1)
    e1.unshift!(q2, q3)
    assert_equal e1.qubits, [q2, q3, q1]
    assert_equal e1.size, 3
    assert_equal e1.number_of_variants, 1 << 3
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
      e.measure!
    end
  end

  def test_measured_is_working_right
    e = Entanglement.new(Qubit.generate, Qubit.generate, Qubit.generate)
    assert_equal false, e.measured?
    e.measure!
    assert_equal true, e.measured?
  end

  def test_measuring_of_defined_entanglements
    e = Entanglement.new( Qubit.new(1, 0),
                          Qubit.new(1, 0),
                          Qubit.new(1, 0))
    assert_equal "|000>", e.measure!.to_s

    e = Entanglement.new( Qubit.new(0, 1),
                          Qubit.new(1, 0),
                          Qubit.new(0, 1))
    assert_equal "|101>", e.measure!.to_s

    sh = Math.sqrt(0.5)
    e = Entanglement.new( Qubit.new(sh, sh),
                          Qubit.new(sh, -sh))
    assert_equal "0.5|00> + 0.5|01> + -0.5|10> + -0.5|11>", e.to_s

    # ...
  end

  def test_measuring_singlton_state
    # I m looking for certain probability amplitudes for qubits
  end

  def test_something_is_connected_with_Bell_states
    # ...
  end

  def test_entanglement_cannot_be_empty
    assert_raises EmptyEntanglementException do
      e = Entanglement.new
    end
  end

  def test_pushing_measured_qubit_right
    (q = Qubit.generate).measure
    e = Entanglement.new(Qubit.generate).measure!
    e.push!(q)
    assert_equal true, e.measured?
  end

  def test_pushing_measured_qubit_left
    (q = Qubit.generate).measure
    e = Entanglement.new(Qubit.generate).measure!
    e.unshift!(q)
    assert_equal true, e.measured?
  end

  def test_pushing_measured_qubits_right
    e1 = Entanglement.new(Qubit.generate).measure!
    q = [Qubit.new(1, 0), Qubit.new(1, 0), Qubit.new(0, 1)]
    e1.push!(*q)
    assert_equal true, e1.measured?
  end

  def test_pushing_measured_entanglement_left
    e1 = Entanglement.new(Qubit.generate).measure!
    q = [Qubit.new(1, 0), Qubit.new(1, 0), Qubit.new(0, 1)]
    e1.unshift!(*q)
    assert_equal true, e1.measured?
  end

  def test_qbit_is_entanglement
    q = Qubit.generate
    assert_equal false, q.entangled?
    e = Entanglement.new(q)
    assert_equal true, q.entangled?
  end

  def test_qbit_is_also_entangled_if_locates_in_2_entanglements
    q = Qubit.generate
    e = Entanglement.new(q)
    assert_equal true, q.entangled?
    e2 = Entanglement.new(q)
    assert_equal true, q.entangled?
    assert_equal [e, e2], q.entanglement
  end

  def test_qbit_is_measured_if_its_entanglement_was_measured
    q = Qubit.generate
    e = Entanglement.new(q)
    assert_equal false, q.measured?
    e.measure!
    assert_equal true, e.measured?
    assert_equal true, q.measured?
  end

  def test_measuring_with_side_effect_free
    e = Entanglement.new(Qubit.generate)
    assert_equal false, e.measured?
    e2 = e.measure
    assert_equal false, e.measured?
    assert_equal true, e2.measured?
  end

  def test_pushing_with_side_effect_free
    e = Entanglement.new(Qubit.generate)
    assert e.size == 1
    e2 = e.push(Qubit.generate)
    assert e.size == 1
    assert e2.size == 2
  end

  def test_unshift_with_side_effect_free
    e = Entanglement.new(Qubit.generate)
    assert e.size == 1
    e2 = e.unshift(Qubit.generate)
    assert e.size == 1
    assert e2.size == 2
  end

  def test_entanglement_multiple_qubit
    q1, q2 = Qubit.generate, Qubit.generate
    e = Entanglement.new(q1)
    assert e.size == 1
    e2 = e * q2
    assert e.size == 1
    assert e2.size == 2
  end

  def test_to_str
    assert_equal "1|1>", "" + Entanglement.new(Qubit.new(0, 1))
  end
end
