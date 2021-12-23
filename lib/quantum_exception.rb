# frozen_string_literal: true

# Module with exceptions for qar gem
module QuantumException
  # Exception for signalisation of bad normalization
  class NormalizationException < StandardError
    def initialize(msg = "Normalization condition not implemented")
      super(msg)
    end
  end

  class ReEntanglementException < StandardError
    def initialize(msg = "Qubit cannot be entangled twice in the same entanglement")
      super(msg)
    end
  end

  class EmptyEntanglementException < StandardError
    def initialize(msg = "An entanglement cannot be empty")
      super(msg)
    end
  end

  class GateArgumentException < StandardError
    def initialize(msg = "Quantum gates arguments are incorrect")
      super(msg)
    end
  end
end
