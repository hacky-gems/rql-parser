module RqlParser
  module Services
    # Service that performs the parse operation
    class Parse < BaseInteraction
      string :rql

      DELIMITERS = '&,;'.freeze
      OR_DELIMITERS = /[;|]/.freeze
      COMMA_DELIMITER = /,/.freeze
      AND_STRICT_DELIMITERS = /&/.freeze
      BRACES_REGEX = /\A\(.+\)\z/.freeze
      FUNCTION_REGEX = /\A[a-z]+\(.+\)\z/.freeze
      FUNCTION_IDENTIFIER = /\A([a-z]+)/.freeze
      FUNCTION_ARGS = /\A[a-z]+\((.+)\)\z/.freeze
      VALUE_REGEX = /\A[_0-9a-zA-Z]+\z/.freeze

      def execute
        formatted = perform(Format.run(inputs))
        expression(formatted) || errors.add(:rql) unless errors.any?
      end

      private

      def expression(str)
        group(str) || or_expression(str)
      end

      def group(str)
        return false unless BRACES_REGEX.match?(str)

        or_expression(str[1..-2]) || false
      end

      def or_expression(str)
        result = repeat_pattern(str, OR_DELIMITERS) { |s| and_expression(s) }
        return false unless result

        result.size > 1 ? { type: :function, identifier: :or, args: result } : result.first
      end

      def and_expression(str)
        result = repeat_pattern(str, COMMA_DELIMITER) { |s| function(s) || group(s) || and_strict(s) }
        return false unless result

        result.size > 1 ? { type: :function, identifier: :and, args: result } : result.first
      end

      def and_strict(str)
        result = repeat_pattern(str, AND_STRICT_DELIMITERS) { |s| function(s) || group(s) }
        return false unless result

        result.size > 1 ? { type: :function, identifier: :and, args: result } : result.first
      end

      def function(str)
        return false unless FUNCTION_REGEX.match?(str)

        identifier = str.match(FUNCTION_IDENTIFIER)[1]
        args = args(str.match(FUNCTION_ARGS)[1])

        return false unless args

        { type: :function, identifier: identifier.to_sym, args: args }
      end

      def args(str)
        repeat_pattern(str, COMMA_DELIMITER) { |s| arg(s) }
      end

      def arg(str)
        expression(str) || array_of_values(str) || value(str)
      end

      def array_of_values(str)
        return false unless BRACES_REGEX.match?(str)

        result = repeat_pattern(str[1..-2], COMMA_DELIMITER) { |s| value(s) }
        return false unless result

        { arg_array: result }
      end

      def value(str)
        if str.match?(VALUE_REGEX)
          { arg: str }
        else
          false
        end
      end

      def repeat_pattern(str, split_regex)
        split = str.split(split_regex)
        result = []
        expression = ''
        while split.any?
          expression += split.shift
          bin_tree = yield(expression)
          if bin_tree
            result.push(bin_tree)
            expression = ''
          else
            expression += compose_char(split_regex)
          end
        end
        expression.blank? && result
      end

      def compose_char(regex)
        DELIMITERS.match(regex)[0]
      end
    end
  end
end
