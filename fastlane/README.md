fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

## Choose your installation method:

<table width="100%" >
<tr>
<th width="33%"><a href="http://brew.sh">Homebrew</a></td>
<th width="33%">Installer Script</td>
<th width="33%">Rubygems</td>
</tr>
<tr>
<td width="33%" align="center">macOS</td>
<td width="33%" align="center">macOS</td>
<td width="33%" align="center">macOS or Linux with Ruby 2.0.0 or above</td>
</tr>
<tr>
<td width="33%"><code>brew cask install fastlane</code></td>
<td width="33%"><a href="https://download.fastlane.tools">Download the zip file</a>. Then double click on the <code>install</code> script (or run it in a terminal window).</td>
<td width="33%"><code>sudo gem install fastlane -NV</code></td>
</tr>
</table>

# Available Actions
## iOS
### ios release_testflight
```
fastlane ios release_testflight
```
Releases a new version to `TestFlight`. This lane uses the configuration mapped to `:testflight`.



It has basically 3 main responsabilities: build/version number managing, app building, and deploy.



- Reads the build/version number from `'CURRENT_BUILD_NUMBER'/'CURRENT_VERSION_NUMBER'` 
xcode user defined build configuration for the configuration in use.

- Increments and saves these new values in the xcode user defined build configuration.

- Sets these incremented build and version values in the `Info.plist` to be used to build the app.

- Builds the app using `gym` and `match` to get the signing identity. The provisioning profile in use is the one selected in xcode for the configuration mapped by `:testflight`.

- Uploads the generated `.dsym` file to `Rollbar`.

- Discards the changes in `Info.plist`. Given this file is used for every configuration, these values are stored in xcode user defined build configuration and just reflected in `Info.plist` during building.

- Uploads the application to `TestFlight` using `pilot`.



Receives a parameter `bump_type` representing the type of deploy. It can be any of ["build", "patch", "minor", "major"]

Check [here](http://semver.org/) for reference about versioning.

Build is initialized in 0, and version in 0.0.0, so first deploy must be major
### ios test
```
fastlane ios test
```
Executes the tests for the project using `scan`. This lane uses the configuration mapped to `:test`.
### ios create_development_app
```
fastlane ios create_development_app
```
Creates the `App ID` and `Provisioning Profile` for the configurations mapped to `:test` and `:qa`.
### ios create_testflight_app
```
fastlane ios create_testflight_app
```
Creates the `App ID` and `Provisioning Profile` for the configuration mapped to `:testflight`.
### ios add_device
```
fastlane ios add_device
```
Adds a new device and regenerates the `Provisioning Profile`s to include it.

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
