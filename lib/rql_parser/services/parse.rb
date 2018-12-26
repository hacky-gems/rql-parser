# frozen_string_literal: true

module RqlParser
  module Services
    class Parse < BaseInteraction
      string :rql

      def execute
        formatted = perform(Format.run(inputs))
        expression(formatted) || errors.add(:rql) unless errors.any?
      end

      private

      def expression(str)
        group(str) || or_expression(str)
      end

      def group(str)
        res = false
        if /\A\(.+\)\z/.match?(str)
          res = or_expression(str[1..-2])
          if res
            res = { type: :group, args: res } if res[:args].size > 1
          end
        end
        res
      end

      def or_expression(str)
        res = []
        split = str.split(/[;|]/)
        temp = ''
        while split.any?
          temp += split.shift
          temp_and_exp = and_expression(temp)
          if temp_and_exp
            res.push(temp_and_exp)
            temp = ''
          else
            temp += '|'
          end
        end
        return false if temp.present?

        res.size > 1 ? { type: :function, identifier: 'or', args: res } : res.first
      end

      def and_expression(str)
        res = []
        split = str.split(/,/)
        temp = ''
        while split.any?
          temp += split.shift
          temp_and_exp = function(temp) || group(temp) || and_strict(temp)
          if temp_and_exp
            res.push(temp_and_exp)
            temp = ''
          else
            temp += ','
          end
        end
        return false if temp.present?

        res.size > 1 ? { type: :function, identifier: 'and', args: res } : res.first
      end

      def and_strict(str)
        res = []
        split = str.split(/&/)
        temp = ''
        while split.any?
          temp += split.shift
          temp_and_exp = function(temp) || group(temp)
          if temp_and_exp
            res.push(temp_and_exp)
            temp = ''
          else
            temp += ','
          end
        end
        return false if temp.present?

        res.size > 1 ? { type: :function, identifier: 'and', args: res } : res.first
      end

      def function(str)
        res = false
        if /\A[a-z]+\(.+\)\z/.match?(str)
          identifier = str.match(/\A([a-z]+)/)[1]
          args = str.match(/\A[a-z]+\((.+)\)\z/)[1]
          temp_args = args(args)
          res = { type: :function, identifier: identifier, args: temp_args } if temp_args
        end
        res
      end

      def args(str)
        res = []
        split = str.split(',')
        temp = ''
        while split.any?
          temp += split.shift
          temp_arg = arg(temp)
          if temp_arg
            res.push(temp_arg)
            temp = ''
          else
            temp += ','
          end
        end
        return false if temp.present?

        res
      end

      def arg(str)
        expression(str) || array_of_values(str) || value(str)
      end

      def array_of_values(str)
        return false unless /\A\(.+\)\z/.match?(str)

        res = []
        split = str[1..-2].split(',')
        temp = ''
        while split.any?
          temp += split.shift
          temp_arg = value(temp)
          if temp_arg
            res.push(temp_arg)
            temp = ''
          else
            temp += ','
          end
        end
        return false if temp.present?

        { arg_array: res }
      end

      def value(str)
        if str.match?(/\A[_0-9a-zA-Z]+\z/)
          { arg: str }
        else
          false
        end
      end
    end
  end
end
