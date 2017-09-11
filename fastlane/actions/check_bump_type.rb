module Fastlane
  module Actions
    class CheckBumpTypeAction < Action

      # Get the type of release desired
      # If there's only one bump_type allowed it will use that one
      # If there isn't a bump_type specified and there are many allowed bump_types, it will ask the user

      FIRST_VERSION = "0.0.0".freeze
      ALL_BUMP_TYPES = %i(build patch minor major).freeze
      BUILD_CONFIGURATION_ALLOWED_BUMP_TYPES = {
        test: [],
        qa: [:build],
        testflight: ALL_BUMP_TYPES,
        release: ALL_BUMP_TYPES 
      }.freeze

      def self.run(params)
        is_first_deploy = params[:version] == FIRST_VERSION
        allowed_bump_types = BUILD_CONFIGURATION_ALLOWED_BUMP_TYPES[params[:build_configuration]]

        if is_first_deploy
          return :major
        end

        if allowed_bump_types.count == 1
          return allowed_bump_types.first # The only allowed bump type possible
        end

        bump_type = params[:bump_type]
        while not allowed_bump_types.include? bump_type do
          bump_type = UI.input "Choose the `bump_type` representing the type of deploy. It can be any of %s" % allowed_bump_types.to_s
        end

        if bump_type != :major
          UI.important "This seems to be your first deploy. It must be done as `%s`." % :major
          if (UI.input "Do you want to make it as `%s`? y/N" % :major) == "y"
            bump_type = allowed_bump_types.last
          else
            UI.user_error! "The first depoy must be done as %s. Please try again later." % :major
          end
        end

        bump_type
      end

      # Fastlane Action class required functions.
      def self.is_supported?(platform)
        true
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :build_configuration, optional: false, type: Symbol),
          FastlaneCore::ConfigItem.new(key: :version, optional: false),
          FastlaneCore::ConfigItem.new(key: :bump_type, optional: true, default_value: nil),
        ]
      end

      def self.bump_type_allowed?(build_configuration, bump_type)
        return BUILD_CONFIGURATION_ALLOWED_BUMP_TYPES[build_configuration].include? bump_type
      end

    end
  end
end
