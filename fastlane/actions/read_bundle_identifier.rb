require 'xcodeproj'

module Fastlane
  module Actions
    class ReadBundleIdentifierAction < Action

      # Given a project, a scheme, and a build configuration
      # this script returns the corresponding 
      # product bundle identifier.

      def self.run(params)
        Xcodeproj::Project.open(params[:project])
          .native_targets.find { |each| each.name == params[:scheme] }
          .build_configurations.find { |each| each.name == params[:build_configuration] }
          .build_settings['PRODUCT_BUNDLE_IDENTIFIER']
      end

      # Fastlane Action class required functions.

      def self.is_supported?(platform)
        true
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :project, optional: true, default_value: default_project),
          FastlaneCore::ConfigItem.new(key: :scheme, optional: true, default_value: default_scheme),
          FastlaneCore::ConfigItem.new(key: :build_configuration, optional: false),
        ]
      end

      # Available options default_value helpers

      # In case there is a single '.xcodeproj' in the default directory
      # it can be automatically inferred by the script 
      # if no parameter project is received.
      def self.default_project
        projects = Dir.entries('.').select { |each| each.end_with? '.xcodeproj' }
        projects.length == 1 ? projects.first : nil
      end

      # In case there is a scheme matching project's name
      # it can be automatically inferred by the script 
      # if no parameter scheme is received.
      def self.default_scheme
        default_project.split('.').first
      end

    end
  end
end
