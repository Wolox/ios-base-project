module Fastlane
  module Actions
    class LatestTestflightVersionAction < Action

      # Retrieves the latest version uploaded to ItunesConnect

      def self.run(params)
        Spaceship::Tunes.login
        app = Spaceship::Tunes::Application.find(params[:bundle_id])
        if app.nil?
          UI.abort_with_message! "The application is not yet created in iTunes Connect."
        end
        app.all_build_train_numbers.max
      end

      # Fastlane Action class required functions.

      def self.is_supported?(platform)
        true
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :bundle_id, optional: false),
        ]
      end

    end
  end
end
