# The env variables are contained in an `.env.default` file.
fastlane_version "2.62.0"
default_platform :ios

# Default path formatters
project_plist_path = "%s/Info.plist"
project_xcconfig_path = "%s/ConfigurationFiles/%s.xcconfig"
dsym_zip_path = "%s.app.dSYM.zip"

# Default build configuration by action
build_configurations = {
  test: "Debug",
  qa: "Alpha",
  appstore: "Release",
  production: "Production"
}

# Default match types by build configuration
match_types = {
  test: "development",
  qa: "appstore",
  appstore: "appstore",
  production: "appstore"
}

# Default App ID names by build configuration
app_names = {
  test: "%s Dev",
  qa: "%s Alpha",
  appstore: "%s",
  production: "%s"
}

platform :ios do

  # Run this before doing anything else
  before_all do

    desc "Validate the project name and main target are properly configured."
    UI.message "Running lane for project: `%s`" % project_name

    desc "Validate the configured bundle identifiers match the expected ones."
    expected_bundle_identifiers = Hash[build_configurations.values.uniq.map { |each| [each, []] }]
    build_configurations.each do |key, value|
      expected_bundle_identifiers[value].push(infer_bundle_identifier(build_configuration: key))
    end
    expected_bundle_identifiers.each do |key, value|
      found_bundle_identifier = read_project_property(
        build_configuration: key, 
        build_setting: 'PRODUCT_BUNDLE_IDENTIFIER'
      )
      UI.message "Validating bundle identifier for '#{key}'. Expected: '#{value}', found: '#{found_bundle_identifier}'."
      unless value.include?(found_bundle_identifier)
        UI.abort_with_message! "Aborting due to mismatching in bundle identifier for build configuration '#{value}'."
      end
    end

  end

  # After all the steps have completed succesfully, run this.
  after_all do |lane|

    desc "Remove all build artifacts created by fastlane to upload."
    clean_build_artifacts

  end

  # If there was an error, run this.
  error do |lane, exception|

    desc "Remove all build artifacts created by fastlane to upload."
    clean_build_artifacts

  end

  desc "New release to `TestFlight` for Appstore."
  desc "Parameters:"
  desc "- bump_type (optional): represents the type of deploy. If not specified, the user will be asked for it."
  lane :release_appstore do |options|
    release build_configuration: :appstore, bump_type: options[:bump_type]
  end

  desc "New release to `TestFlight` for QA(Alpha). This lane will never update the version, only the build number."
  lane :release_qa do
    release build_configuration: :qa
  end

  desc "Releases a new version to `TestFlight`. This lane must receive the following parameters:"
  desc "- build_configuration: A build configuration to deploy. Can be any of: `%s`" % build_configurations.keys.to_s
  desc "- bump_type (optional): represents the type of deploy. If not specified, the user will be asked for it.
  Its allowed values depend on the configuration: `%s`" % Actions::CheckBumpTypeAction::BUILD_CONFIGURATION_ALLOWED_BUMP_TYPES.to_s
  desc ""
  desc "It has basically 3 main responsabilities: build/version number managing, app building, and deploy."
  desc ""
  desc "- Gets the latest version and build number from `TestFlight`"
  desc "- Sets these version and build values in the `Info.plist` to be used to build the app."
  desc "- Builds the app using `gym` and `match` to get the signing identity. The provisioning profile in use is the one \
selected in xcode for the selected configuration"
  desc "- Uploads the generated `.dsym` file to `Rollbar`."
  desc "- Discards the changes in `Info.plist`. Given this file is used for every configuration, these values are just \
reflected in `Info.plist` during building."
  desc "- Uploads the application to `TestFlight` using `pilot`."
  desc ""
  desc "Check [here](http://semver.org/) for reference about versioning."
  desc "Build is initialized in `%s`" % Actions::CheckBumpTypeAction::FIRST_BUILD
  desc "Version is initialized in `%s`" % Actions::CheckBumpTypeAction::FIRST_VERSION
  desc "First deploy must always be a `%s`" % :major
  private_lane :release do |options|

    build_configuration = options[:build_configuration]

    if Actions::CheckBumpTypeAction.bump_type_allowed? build_configuration, options[:bump_type]
      allowed_bump_types = Actions::CheckBumpTypeAction::BUILD_CONFIGURATION_ALLOWED_BUMP_TYPES[build_configuration]
      UI.user_error! "The bump_type specified for this lane can only be one of `%s`" % allowed_bump_types.to_s
    end

    desc "Read bundle identifier from project configuration."
    bundle_identifier = read_project_property(
      build_configuration: build_configurations[build_configuration],
      build_setting: 'PRODUCT_BUNDLE_IDENTIFIER'
    )

    desc "Read current version number from `TestFlight`."
    current_version_version = latest_testflight_version(
      bundle_id: bundle_identifier
    )
    if current_version_version.nil?
      current_version_version = Actions::CheckBumpTypeAction::FIRST_VERSION
    end

    desc "Read current build number from `TestFlight`."
    current_build_version = latest_testflight_build_number(
      app_identifier: bundle_identifier,
      version: current_version_version,
      initial_build_number: Actions::CheckBumpTypeAction::FIRST_BUILD
    ).to_i

    bump_type = check_bump_type(
      build_configuration: build_configuration,
      version: current_version_version,
      bump_type: options[:bump_type]
    ).to_s

    UI.message "Will release app increasing bump type: `%s`" % bump_type

    desc "Define next build number depending on bump_type."
    current_build_number = bump_type == "build" ? current_build_version : Actions::CheckBumpTypeAction::FIRST_BUILD
    next_build_number = current_build_number + 1

    desc "Set version and build number in Info.plist"
    set_info_plist_version(
      version_number: current_version_version,
      build_number: next_build_number
    )

    desc "Update version number in `Info.plist` depending in bump_type."
    if bump_type != "build"
      current_version_version = increment_version_number(bump_type: bump_type)
    end

    begin
      desc "Build"
      build_app(
        app_identifier: bundle_identifier,
        configuration: build_configurations[build_configuration],
        match_type: match_types[build_configuration]
      )

      desc "Get rollbar server access token from configuration file."
      rollbar_server_access_token = read_xcconfig_property(
        xcconfig_path: project_xcconfig_path % [project_name, build_configurations[build_configuration]],
        xcconfig_key: 'ROLLBAR_SERVER_ACCESS_TOKEN'
      )

      desc "In case rollbar server access token is present then do the uploading"
      unless rollbar_server_access_token.to_s.empty?

        desc "Upload dsym to rollbar."
        upload_dsym(
          access_token: rollbar_server_access_token,
          version: String(next_build_number),
          bundle_identifier: bundle_identifier,
          dsym_zip_path: dsym_zip_path % project_name
        )

      end

      desc "Upload the built app to TestFlight."
      UI.message "Uploading version `%s` build `%s`" % [current_version_version, next_build_number]
      publish_testflight
    ensure
      desc "Put back the default version number and build number in `Info.plist`."
      set_info_plist_version(
        version_number: Actions::CheckBumpTypeAction::FIRST_VERSION,
        build_number: Actions::CheckBumpTypeAction::FIRST_BUILD
      )
    end
  end

  desc "Sets the version and build number in the Info.plist"
  desc "Parameters:"
  desc "- version_number: The version to set in the Info.plist"
  desc "- build_number: The build number to set in the Info.plist"

  private_lane :set_info_plist_version do |options|
    version_number = options[:version_number]
    build_number = options[:build_number]

    if version_number.nil? || build_number.nil?
      UI.user_error! "Both the version and build number must be provided"
    end

    desc "Set version number in `Info.plist`."
    set_info_plist_value(
      path: project_plist_path % project_name,
      key: 'CFBundleShortVersionString',
      value: version_number.to_s
    )

    desc "Set build number in `Info.plist`."
    set_info_plist_value(
      path: project_plist_path % project_name,
      key: 'CFBundleVersion',
      value: build_number.to_s
    )
  end

  desc "Executes the tests for the project using `scan`. This lane uses the configuration mapped to `:test`."
  lane :test do

    desc "Run scan with default project and scheme"
    scan(
      configuration: build_configurations[:test],
      # Because of a supposed Apple bug, CI builds fail if it doesn't run in iPhoneSE: travis-ci/travis-ci#6422
      devices: ['iPhone SE'],
      clean: false
    )

  end

  desc "Creates the `App ID` and `Provisioning Profile` for the configurations mapped to `:test` and `:qa`."
  lane :create_development_app do

    desc "Remember after this point to choose this profile in xCode Signing (Development)"
    create_app(
      app_name: app_names[:test] % project_name,
      build_configuration: build_configurations[:test],
      skip_itc: true,
      match_type: match_types[:test],
    )

    desc "Remember after this point to choose this profile in xCode Signing (Alpha)"
    create_app(
      app_name: app_names[:qa] % project_name,
      build_configuration: build_configurations[:qa],
      skip_itc: false,
      match_type: match_types[:qa],
    )

  end

  desc "Creates the `App ID` and `Provisioning Profile` for the configuration mapped to `:appstore`."
  lane :create_appstore_app do
    
    desc "Remember after this point to choose this profile in xCode Signing (Beta)"
    create_app(
      app_name: app_names[:appstore] % project_name,
      build_configuration: build_configurations[:appstore],
      skip_itc: false,
      match_type: match_types[:appstore],
    )

  end

  desc "Adds a new device and regenerates the `Provisioning Profile`s to include it."
  lane :add_device do

    desc "Ask the user for device name and device UUID"
    device_name = prompt(text: 'Enter the device name: ')
    device_udid = prompt(text: 'Enter the device UDID: ')
    device_hash = {}
    device_hash[device_name] = device_udid

    desc "Register new device."
    register_devices(
      devices: device_hash
    )

    desc "Refresh provisioning profiles adding the new device."
    match(
      force_for_new_devices: true
    )

  end

  desc "Builds the app creating the `.ipa` and `.dsym` files"
  private_lane :build_app do |options|

    desc "Download provisioning profiles"
    match(
      app_identifier: options[:app_identifier],
      type: options[:match_type],
      readonly: true
    )

    desc "Build the app using default project and scheme"
    gym(
      configuration: options[:configuration],
      include_symbols: true,
      # bitcode is disabled for the dsym file to keep valid after app is uploaded to app store
      # http://krausefx.com/blog/download-dsym-symbolication-files-from-itunes-connect-for-bitcode-ios-apps
      include_bitcode: false
    )

  end

  desc "Create App ID and Provisioning Profile in Member Center"
  desc "Keep these new certificates and profiles in sync with Match repository"
  private_lane :create_app do |options|

    desc "Bundle identifier from xCode project"
    bundle_identifier = read_project_property(
      build_configuration: options[:build_configuration],
      build_setting: 'PRODUCT_BUNDLE_IDENTIFIER'
    )

    UI.message "Attempting to create application for build configuration '#{options[:build_configuration]}'."
    UI.message "Using name: '#{options[:app_name]}' and bundle ID: '#{bundle_identifier}'"
    confirmation = UI.input "If the parameters are correct, proceed: Y/n"
    unless confirmation.empty? || confirmation.downcase == "y"
      UI.user_error! "Aborting due to parameters misconfiguration. Correct them and run the lane again."
    end

    desc "Create App ID in developer center"
    produce(
      app_name: options[:app_name],
      app_identifier: bundle_identifier,
      skip_itc: options[:skip_itc]
    )

    desc "Generate provisioning profile if no present"
    match(
      app_identifier: bundle_identifier,
      type: options[:match_type],
      readonly: false
    )

  end

  desc "Publish to testflight"
  private_lane :publish_testflight do |options|

    pilot(
      skip_waiting_for_build_processing: true
    )

  end

end
