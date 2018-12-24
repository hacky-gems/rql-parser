module RqlParser
  class BaseInteraction < ActiveInteraction::Base
    private

    def perform(interaction)
      if interaction.valid?
        interaction.result
      else
        errors.merge!(interaction.errors)
      end
    end
  end
end
