enum RunTypes {
  shortRun,
  longRun,
  runWalk,
}

extension RunTypesExtension on RunTypes {
  String get title {
    switch (this) {
      case RunTypes.shortRun:
        return 'Short Run';
      case RunTypes.longRun:
        return 'Long Run';
      case RunTypes.runWalk:
        return 'Run/Walk';
      default:
        return '';
    }
  }
}
