module Dkdeploy
  module Typo3
    module Cms
      # Class for version number
      class Version
        MAJOR = 8
        MINOR = 0
        PATCH = 0

        def self.to_s
          [MAJOR, MINOR, PATCH].join('.')
        end
      end
    end
  end
end
