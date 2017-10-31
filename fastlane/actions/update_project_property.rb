require 'xcodeproj'

module Fastlane
  module Actions
    class UpdateProjectPropertyAction < Action

      # Given a project, a scheme, and a build configuration
      # this script updates the provided build setting
      # with the provided build setting value.

      def self.run(params)
        project = Xcodeproj::Project.open(params[:project])
        build_configuration = project
          .targets.find { |each| each.name == params[:scheme] }
          .build_configurations.find { |each| each.name == params[:build_configuration] }

        if build_configuration.nil?
          UI.abort_with_message! "Build configuration '#{params[:build_configuration]}' is not configured."
        end

        build_configuration.build_settings[params[:build_setting]] = params[:build_setting_value]
        project.save
      end

      # Fastlane Action class required functions.

      def self.is_supported?(platform)
        true
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :project, optional: true, default_value: ProjectNameAction.default_project_filename),
          FastlaneCore::ConfigItem.new(key: :scheme, optional: true, default_value: ProjectNameAction.default_project_name),
          FastlaneCore::ConfigItem.new(key: :build_configuration, optional: false),
          FastlaneCore::ConfigItem.new(key: :build_setting, optional: false),
          FastlaneCore::ConfigItem.new(key: :build_setting_value, optional: false),
        ]
      end

    end
  end
end
