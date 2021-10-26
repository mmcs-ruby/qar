# frozen_string_literal: true

require_relative "test_helper"

class EntanglementTest < Minitest::Test
  include QuantumException

  def test_size_counting_is_right
    e = Entanglement.new(Qubit.generate, Qubit.generate, Qubit.generate)
    assert_equal 3, e.size
  end

  def test_nov_counting_is_right
    e = Entanglement.new(Qubit.generate, Qubit.generate, Qubit.generate)
    assert_equal 8, e.number_of_variants
  end

  def test_a_qubits_refer_array_created_right_1
    q1 = Qubit.generate
    e = Entanglement.new(q1)
    assert_equal [e], q1.entanglement
  end

  def test_a_qubits_refer_array_created_right_2
    q1, q2 = Qubit.generate, Qubit.generate
    e = Entanglement.new(q1, q2)
    another = Entanglement.new(q2)
    assert_equal [e, another], q2.entanglement
  end

  def test_a_qubits_refer_array_created_right
    e = Entanglement.new(Qubit.generate)
    q_right = Qubit.generate
    e.push!(q_right)
    assert_equal [e], q_right.entanglement
  end

  def test_pushing_adding_qubit_with_the_right_side
    e = Entanglement.new(Qubit.generate)
    q_right = Qubit.generate
    e.push!(q_right)
    assert_equal q_right, e.qubits[1]
  end

  def test_pushing_changes_size_right
    e = Entanglement.new(Qubit.generate)
    q_right = Qubit.generate
    e.push!(q_right)
    assert_equal 2, e.size
  end

  def test_pushing_changes_nov_right
    e = Entanglement.new(Qubit.generate)
    q_right = Qubit.generate
    e.push!(q_right)
    assert_equal 4, e.number_of_variants
  end

  def test_a_qubits_refer_array_created_right_after_unshifting
    e = Entanglement.new(Qubit.generate)
    q_left = Qubit.generate
    e.unshift!(q_left)
    assert_equal [e], q_left.entanglement
  end

  def test_unshifting_adding_qubit_with_the_right_side
    e = Entanglement.new(Qubit.generate)
    q_left = Qubit.generate
    e.unshift!(q_left)
    assert_equal q_left, e.qubits[0]
  end

  def test_unshifting_changes_size_right
    e = Entanglement.new(Qubit.generate)
    q_left = Qubit.generate
    e.unshift!(q_left)
    assert_equal 2, e.size
  end

  def test_unshifting_changes_nov_right
    e = Entanglement.new(Qubit.generate)
    q_left = Qubit.generate
    e.unshift!(q_left)
    assert_equal 4, e.number_of_variants
  end

  def test_multiple_qubits_pushing_adds_qubit_with_the_right_side
    q1, q2, q3 = Qubit.generate, Qubit.generate, Qubit.generate
    e = Entanglement.new(q1)
    e.push!(q2, q3)
    assert_equal [q1, q2, q3], e.qubits
  end

  def test_multiple_qubits_pushing_changes_size_right
    q1, q2, q3 = Qubit.generate, Qubit.generate, Qubit.generate
    e = Entanglement.new(q1)
    e.push!(q2, q3)
    assert_equal 3, e.size
  end

  def test_multiple_qubits_pushing_changes_nov_right
    q1, q2, q3 = Qubit.generate, Qubit.generate, Qubit.generate
    e = Entanglement.new(q1)
    e.push!(q2, q3)
    assert_equal 8, e.number_of_variants
  end

  def test_multiple_unshifting_adding_qubits_with_the_right_side
    q1, q2, q3 = Qubit.generate, Qubit.generate, Qubit.generate
    e = Entanglement.new(q1)
    e.unshift!(q2, q3)
    assert_equal [q2, q3, q1], e.qubits
  end

  def test_multiple_unshifting_changes_size_right
    q1, q2, q3 = Qubit.generate, Qubit.generate, Qubit.generate
    e = Entanglement.new(q1)
    e.unshift!(q2, q3)
    assert_equal 3, e.size
  end

  def test_multiple_unshifting_changes_nov_right
    q1, q2, q3 = Qubit.generate, Qubit.generate, Qubit.generate
    e = Entanglement.new(q1)
    e.unshift!(q2, q3)
    assert_equal 8, e.number_of_variants
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

  def test_qbit_is_entangled
    q = Qubit.generate
    e = Entanglement.new(q)
    assert_equal true, q.entangled?
  end

  def test_qbit_is_also_entangled_if_locates_in_2_entanglements
    q = Qubit.generate
    e = Entanglement.new(q)
    e2 = Entanglement.new(q)
    assert_equal true, q.entangled?
    assert_equal [e, e2], q.entanglement
  end

  def test_qbit_is_measured_if_its_entanglement_was_measured
    q = Qubit.generate
    e = Entanglement.new(q)
    e.measure!
    assert_equal true, e.measured?
    assert_equal true, q.measured?
  end

  def test_measuring_with_side_effect_free
    e = Entanglement.new(Qubit.generate)
    e2 = e.measure
    assert_equal false, e.measured?
    assert_equal true, e2.measured?
  end

  def test_pushing_with_side_effect_free
    e = Entanglement.new(Qubit.generate)
    e2 = e.push(Qubit.generate)
    assert e.size == 1
    assert e2.size == 2
  end

  def test_unshift_with_side_effect_free
    e = Entanglement.new(Qubit.generate)
    e2 = e.unshift(Qubit.generate)
    assert e.size == 1
    assert e2.size == 2
  end

  def test_entanglement_multiple_qubit
    q1, q2 = Qubit.generate, Qubit.generate
    e = Entanglement.new(q1)
    e2 = e * q2
    assert e.size == 1
    assert e2.size == 2
  end

  def test_to_str
    assert_equal "1|1>", "" + Entanglement.new(Qubit.new(0, 1))
  end
end
