import 'dart:io';
import 'dart:convert';

const _spaceRegEx = ' '; // RegExp(r'^\s{1,}');

Future<void> main(List<String> args) async {
  final file = File(args.first);
  final fileString = await file.readAsString();
  final lines = LineSplitter.split(fileString)
      .where((element) => element.isNotEmpty)
      .toList();

  // Format files only when there are more than 2 lines
  if (lines.length > 2) {
    final String modifiedString;
    if (!args.isEmpty || args.last == 'v1') {
      modifiedString = _formattedStringV1(lines);
    } else {
      modifiedString = _formattedStringV2(lines);
    }
    file.writeAsString(modifiedString);
  } else {
    return Future(() => null);
  }
}

String _formattedStringV1(List<String> lines) {
  var modifiedLines = <String>[];
  const spaceRegEx = _spaceRegEx;

  modifiedLines.add('${lines.first}\n');

  for (var i = 1; (i < (lines.length - 1)); i++) {
    final previousLine = lines[i - 1];
    final currentLine = lines[i];
    final nextLine = lines[i + 1];

    if (!previousLine.startsWith(spaceRegEx) &&
        !currentLine.startsWith(spaceRegEx) &&
        !nextLine.startsWith(spaceRegEx)) {
      modifiedLines.add('${currentLine}\n');
    } else if (!currentLine.startsWith(spaceRegEx)) {
      if (currentLine.startsWith("#")) {
        modifiedLines.add('\n${currentLine}');
      } else {
        modifiedLines.add('\n${currentLine}\n');
      }
    } else {
      modifiedLines.add('${currentLine}\n');
    }
  }
  modifiedLines.add('${lines.last}\n');
  return modifiedLines.join();
}

String _formattedStringV2(List<String> lines) {
  var modifiedLines = <String>[];

  modifiedLines.add('${lines.first}\n');

  for (var i = 1; (i < lines.length); i++) {
    final currentLine = lines[i];

    if (!currentLine.startsWith(_spaceRegEx)) {
      if (currentLine.startsWith("#")) {
        modifiedLines.add('\n${currentLine}');
      } else {
        modifiedLines.add('\n${currentLine}\n');
      }
    } else {
      modifiedLines.add('${currentLine}\n');
    }
  }
  return modifiedLines.join();
}
