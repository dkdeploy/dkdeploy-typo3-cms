# frozen_string_literal: true

module Dkdeploy
  module Typo3
    module Cms
      module Helpers
        # Erb related helpers
        module Erb
          # Remove "<?php" at beginning and "?>" at end of string
          #
          # @param php_code [String] PHP Code to sanitize
          # @return [String]
          def sanitize_php(php_code)
            php_code.strip.reverse.chomp('php?<').reverse.chomp('?>').strip.concat("\n")
          end

          # Return path to default template file for "AdditionalConfiguration.php" at gem
          #
          # @return [String]
          def default_template_file
            File.join(__dir__, '..', '..', '..', '..', '..', 'vendor', 'AdditionalConfiguration.php.erb')
          end
        end
      end
    end
  end
end
