module Dkdeploy
  module Typo3
    module Cms
      module Helpers
        # MySQL Helpers
        module Mysql
          # Escape special character in string for MySQL.
          # copied from https://github.com/tmtm/ruby-mysql/blob/2.9.14/lib/mysql.rb#L56
          # @param [String]
          # @return [String]
          def mysql_escape_string(str)
            str.gsub(/[\0\n\r\\\'\"\x1a]/) do |s|
              case s
              when "\0" then '\\0'
              when "\n" then '\\n'
              when "\r" then '\\r'
              when "\x1a" then '\\Z'
              else "\\#{s}"
              end
            end
          end
        end
      end
    end
  end
end
