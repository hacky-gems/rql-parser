require 'active_interaction'

# Base module of the parser
module RqlParser
  def self.from_params(params)
    Services::FromParams.run(params)
  end

  def self.from_params!(params)
    Services::FromParams.run!(params)
  end

  def self.parse(rql)
    Services::Parse.run(rql)
  end

  def self.parse!(rql)
    Services::Parse.run!(rql)
  end
end

require 'rql_parser/version'
require 'rql_parser/base_interaction'
require 'rql_parser/services/from_params'
require 'rql_parser/services/format'
require 'rql_parser/services/parse'
