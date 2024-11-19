enum RunTypes {
  shortRun,
  runWalk,
  longRun,
  speedRun,
}

extension RunTypesExtension on RunTypes {
  String get title {
    switch (this) {
      case RunTypes.shortRun:
        return 'Short Run';
      case RunTypes.runWalk:
        return 'Run/Walk';
      case RunTypes.longRun:
        return 'Long Run';
      case RunTypes.speedRun:
        return 'Speed Run';
      default:
        return '';
    }
  }
}
