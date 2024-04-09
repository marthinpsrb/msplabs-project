import 'dart:convert';
import 'dart:io';

Future<void> main(List<String> args) async {
  const String pubspecFile = 'pubspec.yaml';

  final pubspecMap = await readYamlFile(pubspecFile);

  //Read the Global dependencies-versions.yaml file, that has the list of all the dependencies used in the project
  final commonDepsMap = await readYamlFile(args.first);

  //To check if the item is present in the deps file and has same version
  compareDeps(pubspecMap, commonDepsMap);
}

//Reads the yaml file and return a Map
Future<Map> readYamlFile(String fileName) async {
  //e = (evaluate) , -o=j (output as json) , -I=0 (No formatting) using yq
  var result = await Process.run('yq', ['e', '-o=j', '-I=0', fileName]);
  final map = json.decode(result.stdout);
  if (result.exitCode == 0) {
    return map;
  }
  throw result.stderr;
}

/*
  A function that checks if globalDep (dependencies-versions.yaml) file contains all elements of pubspec.yaml
*/
void compareDeps(Map pubspecDeps, Map globalDeps) {
  const String keyDeps = 'dependencies';
  const String keyDevDeps = 'dev_dependencies';
  const String keyDepOverrides = 'dependency_overrides';

  final dependencies = pubspecDeps[keyDeps];
  final devDependencies = pubspecDeps[keyDevDeps];
  final dependencyOverrides = pubspecDeps[keyDepOverrides];

  //Filter the map and remove YamlMap type entries. eg.local dependencies
  if (dependencies != null) {
    dependencies.removeWhere((key, value) =>
        (value.runtimeType != String) &&
        (!value.containsKey('git')) &&
        (!value.containsKey('hosted')));
  }

  if (devDependencies != null) {
    devDependencies.removeWhere((key, value) =>
        (value.runtimeType != String) &&
        (!value.containsKey('git')) &&
        (!value.containsKey('hosted')));
  }
  if (dependencyOverrides != null) {
    dependencyOverrides.removeWhere((key, value) =>
        (value.runtimeType != String) &&
        (!value.containsKey('git')) &&
        (!value.containsKey('hosted')));
  }

  final commonDependencies = globalDeps[keyDeps];
  final commonDevDependencies = globalDeps[keyDevDeps];
  final commonDependencyOverrides = globalDeps[keyDepOverrides];

  var missingDependencies = <String>[];
  var unmatchingDependencies = <String>[];
  if (dependencies != null) {
    dependencies.keys.forEach((element) {
      if (commonDependencies != null &&
          commonDependencies.containsKey(element)) {
        if (dependencies[element].toString() !=
            commonDependencies[element].toString()) {
          print(
              'dependency is ${dependencies[element].toString()}, common dependency is ${commonDependencies[element].toString()}');
          unmatchingDependencies.add(element);
        }
      } else {
        missingDependencies.add(element);
      }
    });
  }

  if (devDependencies != null) {
    devDependencies.keys.forEach((element) {
      if (commonDevDependencies != null &&
          commonDevDependencies.containsKey(element)) {
        if (devDependencies[element].toString() !=
            commonDevDependencies[element].toString()) {
          unmatchingDependencies.add(element);
        }
      } else {
        missingDependencies.add(element);
      }
    });
  }

  if (dependencyOverrides != null) {
    dependencyOverrides.keys.forEach((element) {
      if (commonDependencyOverrides != null &&
          commonDependencyOverrides.containsKey(element)) {
        if (dependencyOverrides[element].toString() !=
            commonDependencyOverrides[element].toString()) {
          unmatchingDependencies.add(element);
        }
      } else {
        missingDependencies.add(element);
      }
    });
  }

  if (missingDependencies.isNotEmpty || unmatchingDependencies.isNotEmpty) {
    const joinString = ',\n- ';

    if (unmatchingDependencies.isNotEmpty) {
      final string = unmatchingDependencies.join(joinString);
      print(
          'Following dependency(ies) versions is/are mismatching in pubspec.yaml from global dependencies-versions.yaml:\n- $string');
    }

    if (missingDependencies.isNotEmpty) {
      final string = missingDependencies.join(joinString);
      print(
          'Following dependency(ies) is/are missing in global dependencies-versions.yaml:\n- $string');
    }

    print(
        'Run `melos run unify:dependencies:formatted` or `melos run unify:dependencies` to unify dependency(ies)');
    exit(1);
  }

  exit(0);
}
