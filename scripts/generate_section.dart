import 'dart:io';

const _reset = '\x1B[0m';
const _white = '\x1B[37m';
const _green = '\x1B[32m';
const _yellow = '\x1B[33m';
const _red = '\x1B[31m';

void printInfo(String msg) => print('$_white$msg$_reset');
void printSuccess(String msg) => print('$_green$msg$_reset');
void printWarning(String msg) => print('$_yellow$msg$_reset');
void printError(String msg) => print('$_red$msg$_reset');

void main(List<String> args) {
  if (args.isEmpty) {
    printError('Usage: dart scripts/generate_section.dart <section_name>');
    exit(1);
  }

  final foo = args[0].toLowerCase();
  final Foo = foo[0].toUpperCase() + foo.substring(1);

  final config = {
    'foo': foo,
    'Foo': Foo,
    'baseDir': _readPackageName(),
    'baseClassesDir': 'base',
    'sectionsDir': 'sections',
    'domainDir': 'domain',
    'dataDir': 'data',
    'applicationDir': 'application',
    'blocDir': 'bloc',
    'screenDir': 'screen',
    'repositoryDir': 'repository',
  };

  final dirMapping = {
    'domain': config['domainDir']!,
    'data': config['dataDir']!,
    'application': config['applicationDir']!,
    'bloc': config['blocDir']!,
    'screen': config['screenDir']!,
    'repository': config['repositoryDir']!,
  };

  final templateDir = Directory('scripts/generate_section');
  final outputDir = Directory('lib/${config['sectionsDir']}/$foo');

  if (outputDir.existsSync()) {
    printError('Section "$foo" already exists at ${outputDir.path}');
    exit(1);
  }

  for (final entity in templateDir.listSync(recursive: true)) {
    if (entity is! File) continue;

    var relativePath = entity.path.replaceFirst('${templateDir.path}/', '');

    for (final entry in dirMapping.entries) {
      relativePath = relativePath.replaceAll(entry.key, entry.value);
    }
    relativePath = relativePath.replaceAll('foo', foo);

    final targetFile = File('${outputDir.path}/$relativePath');
    targetFile.parent.createSync(recursive: true);

    var content = entity.readAsStringSync();
    for (final entry in config.entries) {
      content = content.replaceAll('\$${entry.key}\$', entry.value);
    }

    targetFile.writeAsStringSync(content);
    printInfo(targetFile.path);
  }

  printSuccess('\nSection "$foo" generated at ${outputDir.path}');
}

String _readPackageName() {
  final pubspec = File('pubspec.yaml');
  if (!pubspec.existsSync()) return 'app';
  for (final line in pubspec.readAsLinesSync()) {
    if (line.startsWith('name:')) {
      return line.replaceFirst('name:', '').trim();
    }
  }
  return 'app';
}
