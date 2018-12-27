module RqlParser
  # Parent class for all objects
  class BaseInteraction < ActiveInteraction::Base
    private

    def perform(outcome)
      if outcome.valid?
        outcome.result
      else
        errors.merge!(outcome.errors)
      end
    end
  end
end
