module Fastlane
  module Actions
    class InferBundleIdentifierAction < Action

      # Given a build configuration
      # this script builds the corresponding bundle identifier
      # that should be used.

      # This is useful to validate the bundle identifiers chosen
      # during the kickoff are correct.

      # Format for bundle identifiers by build configuration.
      BUNDLE_IDENTIFIERS_FORMAT = {
        test: "com.%s.%s.debug",
        qa: "com.%s.%s.alpha",
        appstore: "com.%s.%s",
        production: "com.%s.%s"
      }.freeze

      # If the application is deployed in Wolox account choose Wolox
      # as owner, otherwise choose project name.
      DEPLOYED_IN_WOLOX_ACCOUNT = {
        test: true,
        qa: true,
        appstore: true,
        production: false
      }.freeze

      def self.run(params)
        # For legacy projects, just override the return value
        # with the desired bundle identifier.
        bundle_identifier_format = BUNDLE_IDENTIFIERS_FORMAT[params[:build_configuration]]
        team_name = DEPLOYED_IN_WOLOX_ACCOUNT[params[:build_configuration]] ? "Wolox" : ProjectNameAction.default_project_name
        bundle_identifier_format % [team_name, ProjectNameAction.default_project_name]
      end

      # Fastlane Action class required functions.

      def self.is_supported?(platform)
        true
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :build_configuration, optional: false, is_string: false)
        ]
      end

    end
  end
end
