# frozen_string_literal: true

# Module with exceptions for qar gem
module QuantumException
  # Exception for signalisation of bad normalization
  class NormalizationException < StandardError
    def initialize(msg = "Normalization condition not implemented")
      super(msg)
    end
  end
end
