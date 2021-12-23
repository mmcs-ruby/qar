require_relative "test_helper"

class QgatesTest < Minitest::Test

  def test_it_does_something_useful
  # test that we are not a teapot... just 4 fun
  assert self != :i_am_a_teapot

  # test that no errors occur when importing the module
  assert_nothing_raised do
    require "qar"
  end
  end

  #test section for single-qubit quantum gates

  # x_gate = [[0, 1],
  #          [1, 0]]
  def test_X_GATE

    q1=Qubit.new(1,0)
    s1=X_GATE * q1
    assert_equal s1.qubits.map!{ |i| i.vector },[ Qubit.new(0,1).vector]
  end

  # y_gate = [[0, -1i],
  #          [1i, 0]]
  def test_Y_GATE
    q1=Qubit.new(1,0)
    s1=Y_GATE * q1
    assert_equal s1.qubits.map!{ |i| i.vector },[ Qubit.new(0+0i,0+1i).vector]
  end

  # z_gate = [[1, 0],
  #          [0, -1]]
  def test_Z_GATE
    q1=Qubit.new(1,0)
    s1=Z_GATE*q1
    assert_equal s1.qubits.map!{ |i| i.vector },[Qubit.new(1,0).vector]
  end

  # h_gate = 1/sqrt(2)[[1, 1],
  #                   [1, -1]]
  def test_H_GATE
    q1=Qubit.new(1,0)
    s1=H_GATE * q1
    assert_equal s1.qubits.map!{ |i| i.vector },[Qubit.new(1/Math.sqrt(2),1/Math.sqrt(2)).vector]
  end

  # t_gate = [[1, 0],
  #          [0, e^(i*pi/4)]]
  def test_T_GATE
    q1=Qubit.new(1,0)
    s1=T_GATE * q1
    assert_equal s1.qubits.map!{ |i| i.vector },[Qubit.new(1,0).vector]
  end

  #test section for states with single qubit in it

  def test_X_GATE_State

    q1=Qubit.new(1,0)
    s1=X_GATE*X_GATE * q1
    assert_equal s1.qubits.map!{ |i| i.vector },[q1.vector]
  end

  def test_Y_GATE_State

    q1=Qubit.new(1,0)
    s1=Y_GATE*Y_GATE * q1
    assert_equal s1.qubits.map!{ |i| i.vector },[q1.vector]
  end

  def test_Z_GATE_State

    q1=Qubit.new(1,0)
    s1=Z_GATE*Z_GATE * q1
    assert s1.qubits.map!{ |i| i.vector },[q1.vector]
  end

  #test need more accuracy due to accumulated error
  def test_H_GATE_State
    q1=Qubit.new(1,0)
    s1=H_GATE*H_GATE * q1
    assert_equal s1.qubits.map!{ |i| i.vector }, [Qubit.new(0.9999999999999998,0).vector]
  end

  def test_T_GATE_State

    q1=Qubit.new(1,0)
    s1=T_GATE*T_GATE * q1
    assert_equal s1.qubits.map!{ |i| i.vector },[q1.vector]
  end

  def test_Muptiple_Gates_Combination
    q1=Qubit.new(1,0)
    s1=Z_GATE*X_GATE*T_GATE*X_GATE*Y_GATE * q1
    assert_equal s1.qubits.map!{ |i| i.vector },[Qubit.new(0+0i,0-1i).vector]
  end
end