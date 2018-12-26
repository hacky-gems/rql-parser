require 'active_interaction'

# Base module of the parser
module RqlParser
  def from_params(params)
    Services::FromParams.run(params)
  end

  def from_params!(params)
    Services::FromParams.run!(params)
  end

  def parse(rql)
    Services::Parse.run(rql)
  end

  def parse!(rql)
    Services::Parse.run!(rql)
  end
end

require 'rql_parser/version'
