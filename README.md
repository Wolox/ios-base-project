%project-name iOS
----------------

%project-ci-badge
%project-codestats-badge

%project-description

# Project info & resources

* **Project Manager**: %pm-full-name - %pm-email-address
* **Technical Leader**: %tl-full-name - %tl-email-address

  * [Trello board](%project-trello-url): Project issues and current status.
  * [Google Drive](%project-google-drive-url): Design resources and assets.


# Setup

## Create a GitHub access token
You will also need to create a GitHub access token for the bootstrap script. Check [this](https://help.github.com/articles/creating-an-access-token-for-command-line-use/) tutorial on how to do that.
The boostrap script requires GitHub credentials to be able to download private dependencies.

## Configure CarthageCache

This project uses [CarthageCache](https://github.com/guidomb/carthage_cache) to cache Carthage's build folder and speed up total build time. The boostrap script will [try](https://github.com/guidomb/ios-scripts#carthage-cache) to generate the `.carthage-cache.yml` file. It will prompt you for the AWS credentials and region. Ask the project's manager to generate a set of crendetials before bootstrapping the project. If you don't configure CarthageCache the boostrap script will tell Carthage to download and build all dependencies.

## Bootstrap project

After setting up the required accounts from all third party service, run the following commands:

```
git clone %project-git-ssh-url
cd %project-root-directory-name
script/bootstrap
open %project-xcodeproj-file
```

If any of the previous commands fail please submit an [issue](%project-github-url/issues/new) specifying the command output, OS X version and XCode version.

## Scripts

Inside the `script` folder there are several scripts to facilitate the development process. For up to date documentation of this scripts check [this](http://github.com/guidomb/ios-scripts) repository. The most relevant scripts are:

  * `script/bootstrap`: Bootstraps the project for the first time.
  * `script/test`: Runs the project's tests
  * `script/update`: Updates the project's dependencies.

# Guidelines

Please before adding any code read the [pull request template](./pull_request_template.md) on how to submit a pull request with the proper format to be able to be merged upstream and also the [coding guidelines](https://github.com/Wolox/ios-style-guide) that must be followed.
