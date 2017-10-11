module Fastlane
  module Actions
    class ReadXcconfigPropertyAction < Action

      # Based on a xcconfig file path and a key name,
      # reads and returns the value for key in the corresponding xcconfig.

      # This is useful in case sensitive data stored in xcconfig files
      # is needed to be accessed from a fastlane script.

      def self.run(params)
        if !File.exist?(params[:xcconfig_path])
          return nil
        end
        line = File.open(params[:xcconfig_path])
          .find { |each| each.start_with? params[:xcconfig_key] }
        line.to_s.empty? ? nil : line.split('=').last.strip
      end

      # Fastlane Action class required functions.

      def self.is_supported?(platform)
        true
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :xcconfig_path, optional: false),
          FastlaneCore::ConfigItem.new(key: :xcconfig_key, optional: false),
        ]
      end

    end
  end
end
