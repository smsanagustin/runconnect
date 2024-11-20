// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'run_event_creator.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$eventCreatorHash() => r'd5bbbf5108a0b8129082d9d3832dc542bc855120';

/// See also [eventCreator].
@ProviderFor(eventCreator)
final eventCreatorProvider = AutoDisposeProvider<AppUser?>.internal(
  eventCreator,
  name: r'eventCreatorProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$eventCreatorHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef EventCreatorRef = AutoDisposeProviderRef<AppUser?>;
String _$creatorNotifierHash() => r'887d99e2b62ca6bad0f82c9e3639bd54e19915b8';

/// See also [CreatorNotifier].
@ProviderFor(CreatorNotifier)
final creatorNotifierProvider =
    AutoDisposeNotifierProvider<CreatorNotifier, Set<AppUser>>.internal(
  CreatorNotifier.new,
  name: r'creatorNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$creatorNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CreatorNotifier = AutoDisposeNotifier<Set<AppUser>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
