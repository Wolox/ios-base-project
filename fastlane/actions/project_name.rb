require 'xcodeproj'

module Fastlane
  module Actions
    class ProjectNameAction < Action

      PROJECT_EXTENSION = ".xcodeproj".freeze

      # This script returns the application name
      # if there is a scheme that matches the project name.
      # Otherwise, it assumes the project name should be specified 
      # by the user and fails.

      def self.run(params)
        default_project_name
      end

      # Fastlane Action class required functions.

      def self.is_supported?(platform)
        true
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :project_name, optional: false)
        ]
      end

      # Available options default_value helpers

      # In case there is a single '.xcodeproj' in the default directory
      # it can be automatically inferred by the script 
      # if no parameter project is received.
      def self.default_project
        projects = Dir.entries('.').select { |each| File.extname(each) == PROJECT_EXTENSION }
        if projects.length == 0
          UI.abort_with_message! "No projects with extension %s found in root directory." % PROJECT_EXTENSION
        end
        if projects.length > 1
          UI.abort_with_message! "Multiple projects with extension %s found in root directory." % PROJECT_EXTENSION
        end
        projects.first
      end

      # In case there is a scheme matching project's name
      # it can be automatically inferred by the script 
      # if no parameter scheme is received.
      def self.matching_scheme
        target = Xcodeproj::Project.open(default_project)
          .targets
          .find { |each| each.name == File.basename(default_project, File.extname(default_project)) }
        if target.nil?
          UI.abort_with_message! "No target matching project name %s found." % PROJECT_EXTENSION
        end
        target.name
      end

      # Just a wrapper for the matching scheme function.
      def self.default_project_name
        matching_scheme
      end

      # Name of the project file.
      def self.default_project_filename
        matching_scheme + PROJECT_EXTENSION
      end

    end
  end
end
