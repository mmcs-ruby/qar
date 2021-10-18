require_relative "test_helper"

class EntanglementTest < Minitest::Test
  include QuantumException
  def test_entanglement_constructor
    assert_nothing_raised Exception do
      Entanglement.new(Qubit.generate, Qubit.generate, Qubit.generate)
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
    assert_equal e.measured?, false
    e.measure
    assert_equal e.measured?, true
  end

  def test_measuring_of_defined_entanglements
    e = Entanglement.new( Qubit.new(1, 0),
                          Qubit.new(1, 0),
                          Qubit.new(1, 0))
    assert_equal e.measure.to_s, "|000>"

    e = Entanglement.new( Qubit.new(0, 1),
                          Qubit.new(1, 0),
                          Qubit.new(0, 1))
    assert_equal e.measure.to_s, "|101>"

    # ...
  end

  def test_measuring_singlton_state
    # I m looking for certain probability amplitudes for qubits
  end

  def test_something_is_connected_with_Bell_states
    # ...
  end



end
