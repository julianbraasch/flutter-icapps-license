import 'dart:io';

import 'package:meta/meta.dart';

import '../extension/string_builder_extension.dart';
import '../model/dto/dependency.dart';
import '../model/dto/dependency_lock.dart';
import '../model/dto/extra_dependency.dart';
import '../model/pubspec.dart';
import '../repo/license_repository.dart';
import '../util/logger.dart';
import 'check_command.dart';

@immutable
class GenerateCommand {
  final LicenseRepository _licenseRepo;

  const GenerateCommand(
    this._licenseRepo,
  );

  Future<void> generateLicenses(Params params) async {
    if (params.checkBeforeGenerate) {
      const CheckCommand().checkDependencies(params);
      Logger.logInfo('\nYour pubspec.yaml & pubspec.lock are in sync. Generating the dart license file.\n');
    }
    final outputFile = File(params.fileOutputPath);
    if (!outputFile.existsSync()) {
      outputFile.createSync(recursive: true);
    }

    final sb = StringBuffer()
      ..writeln("import 'package:flutter/widgets.dart';")
      ..writeln()
      ..writeln('//============================================================//')
      ..writeln('//THIS FILE IS AUTO GENERATED. DO NOT EDIT//')
      ..writeln('//============================================================//')
      ..writeln()
      ..writeln('@immutable')
      ..writeln('class License {')
      ..writeln('  final String name;')
      ..writeln('  final String license;')
      ..writeln('  final String? version;')
      ..writeln('  final String? homepage;')
      ..writeln('  final String? repository;')
      ..writeln()
      ..writeln('  const License({')
      ..writeln('    required this.name,')
      ..writeln('    required this.license,')
      ..writeln('    this.version,')
      ..writeln('    this.homepage,')
      ..writeln('    this.repository,')
      ..writeln('  });')
      ..writeln('}')
      ..writeln();

    final allDependencies = <Dependency>[];
    allDependencies.addAll(params.dependencies);
    allDependencies.addAll(params.extraDependencies);

    final sortedDependencies = allDependencies..sort((a1, a2) => a1.name.compareTo(a2.name));

    sb
      ..writeln('class LicenseUtil {')
      ..writeln('  LicenseUtil._();')
      ..writeln()
      ..writeln('  static List<License> getLicenses() {')
      ..writeln('    return [');

    for (final dependency in sortedDependencies) {
      if (dependency is ExtraDependency) {
        sb.write(await _getExtraDependencyText(params, dependency));
      } else {
        final lockedDependency = params.pubspecLock.dependencies.firstWhere((element) => element.name == dependency.name);
        sb.write(await _getDependencyText(params, dependency, lockedDependency));
      }
    }

    sb
      ..writeln('    ];')
      ..writeln('  }')
      ..writeln('}');

    outputFile.writeAsStringSync(sb.toString());
  }

  Future<String> _getDependencyText(Params params, Dependency dependency, DependencyLock lockedDependency) async {
    final licenseData = await _licenseRepo.getLicenseDataForDependency(params, dependency, lockedDependency);
    final sb = StringBuffer()
      ..writeln('      License(')
      ..writelnWithQuotesOrNull('name', dependency.name)
      ..writeln('        license: r\'\'\'${licenseData.license}\'\'\',')
      ..writelnWithQuotesOrNull('version', dependency.getVersion(lockedDependency))
      ..writelnWithQuotesOrNull('homepage', licenseData.homepageUrl)
      ..writelnWithQuotesOrNull('repository', licenseData.repositoryUrl)
      ..writeln('      ),');
    return sb.toString();
  }

  Future<String> _getExtraDependencyText(Params params, ExtraDependency dependency) async {
    final licenseData = await _licenseRepo.getLicenseDataForExtraDependency(params, dependency);
    final sb = StringBuffer()
      ..writeln('      License(')
      ..writelnWithQuotesOrNull('name', dependency.name)
      ..writeln('        license: r\'\'\'${licenseData.license}\'\'\',')
      ..writelnWithQuotesOrNull('version', dependency.version)
      ..writelnWithQuotesOrNull('homepage', licenseData.homepageUrl)
      ..writelnWithQuotesOrNull('repository', licenseData.repositoryUrl)
      ..writeln('      ),');
    return sb.toString();
  }
}
