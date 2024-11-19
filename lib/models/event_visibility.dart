enum EventVisibility {
  public,
  followers,
}

extension EventVisibilityExtension on EventVisibility {
  String get visibility {
    switch (this) {
      case EventVisibility.public:
        return 'Public';
      case EventVisibility.followers:
        return 'Followers';
      default:
        return '';
    }
  }
}
