# Changelog

## [2.0.1] & [2.0.2] - 2021-03-26
### DEPRECATED
This plugin is now deprecated and will not be updated anymore in the future.homepage
Use the license_generator -> https://pub.dartlang.org/packages/license_generator
We have built this from the ground up. With yml & lock syncing & better errorhandling & documentation

## [2.0.0] - 2021-03-26
### Breaking
-Version & LicenseUrl can return null from now on
### Added
-Support for importing extra dependencies that are not included in the pubspec. (Android or iOS specific code for example)
-Nullsafe flag again
-Stric mode codebase
### Fixed
-Example android v2 embedding
-Example android x migration

## [1.1.1] - 2021-03-07
### Fixed
-Required url in License object

## [1.1.0] - 2021-03-07
### Removed
-Nullsafe flag

## [1.0.1] - 2021-03-07
### Fixed
-Nullsafe code migration with nullabel homepage & repository

## [1.0.0] - 2021-03-04
### Added
-Nullsafe code migration stable release

## [1.0.0-nullsafety.0] - 2021-03-04
### Added
-Nullsafe code migration

## [0.0.8] - 2021-02-09
### Fixed
-Fixed crash if `licenses` was not set in yaml

## [0.0.7] - 2021-02-09
### Added
-Support generating code with nullsafety

## [0.0.6] - 2020-01-08
### Fixed
-False positive when a repository is defined

## [0.0.5] - 2020-01-08
### Added
-Url to pub.dev to make sure it is easy to find missing licenses

## [0.0.4] - 2020-01-08
### Added
-Better docs en example

## [0.0.3] - 2020-01-08
### Fixed
-Fixed a null pointer exception

## [0.0.2] - 2020-01-08
### Fixed
-Fixed a bug where the repository was never used to detect the license

## [0.0.1] - 2020-01-07
### Added
-Initial release
