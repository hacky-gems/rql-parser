require 'active_interaction'

# Base module of the parser
module RqlParser
  # Parent class for all objects
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

require 'rql_parser/version'
