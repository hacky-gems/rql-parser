module RqlParser
  class Format < BaseInteraction
    string :rql

    RQL_FORMAT = /\A[0-9A-Za-z_()|&,+\-!=<> ]+\z/.freeze

    validates :rql, format: { with: RQL_FORMAT }

    def execute
      res = remove_whitespace(rql)
      replace_shorthands(res)
    end

    private

    def remove_whitespace(rql)
      if /[0-9a-zA-Z] [0-9a-zA-Z(]/.match?(rql)
        errors.add(:rql_parser, 'has invalid whitespace')
      else
        rql.delete(' ')
      end
    end

    def replace_shorthands(rql)
      res = without_shorthands(rql)
      if /[!<>=]/.match?(res)
        errors.add(:rql_parser, 'has invalid shorthands')
      else
        res
      end
    end

    def without_shorthands(rql)
      rql.gsub(/([0-9A-Za-z_]+)=(eq|ne|lt|le|gt|ge)=([0-9A-Za-z_]+)/,
               '\2(\1,\3)')
         .gsub(/([0-9A-Za-z_]+)!=([0-9A-Za-z_]+)/, 'ne(\1,\2)')
         .gsub(/([0-9A-Za-z_]+)<([0-9A-Za-z_]+)/, 'lt(\1,\2)')
         .gsub(/([0-9A-Za-z_]+)<=([0-9A-Za-z_]+)/, 'le(\1,\2)')
         .gsub(/([0-9A-Za-z_]+)>([0-9A-Za-z_]+)/, 'gt(\1,\2)')
         .gsub(/([0-9A-Za-z_]+)>=([0-9A-Za-z_]+)/, 'ge(\1,\2)')
         .gsub(/([0-9A-Za-z_]+)=([0-9A-Za-z_]+)/, 'eq(\1,\2)')
    end
  end
end
