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
### ios release_appstore
```
fastlane ios release_appstore
```
New release to `TestFlight` for Appstore.

Parameters:

- bump_type (optional): represents the type of deploy. If not specified, the user will be asked for it.
### ios release_qa
```
fastlane ios release_qa
```
New release to `TestFlight` for QA(Alpha). This lane will never update the version, only the build number.
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
### ios create_appstore_app
```
fastlane ios create_appstore_app
```
Creates the `App ID` and `Provisioning Profile` for the configuration mapped to `:appstore`.
### ios add_device
```
fastlane ios add_device
```
Adds a new device and regenerates the `Provisioning Profile`s to include it.

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
