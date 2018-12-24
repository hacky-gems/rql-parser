# frozen_string_literal: true

module RqlParser
  #
  # some doc
  class FromParams < BaseInteraction
    hash :params, strip: false

    def execute
      perform RqlParser::Parse.run(rql: to_rql(params))
    end

    private

    def to_rql(params)
      params.except(:controller, :action).map do |k, v|
        [k, v].compact.join('=')
      end.join('&')
    end
  end
end
