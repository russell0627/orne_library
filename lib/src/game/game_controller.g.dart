// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$gameControllerHash() => r'9efb22955ba8f5e7816fca595c0945b4c5d18a74';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$GameController
    extends BuildlessAutoDisposeNotifier<GameState> {
  late final GameSetup setup;

  GameState build(GameSetup setup);
}

/// See also [GameController].
@ProviderFor(GameController)
const gameControllerProvider = GameControllerFamily();

/// See also [GameController].
class GameControllerFamily extends Family<GameState> {
  /// See also [GameController].
  const GameControllerFamily();

  /// See also [GameController].
  GameControllerProvider call(GameSetup setup) {
    return GameControllerProvider(setup);
  }

  @override
  GameControllerProvider getProviderOverride(
    covariant GameControllerProvider provider,
  ) {
    return call(provider.setup);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'gameControllerProvider';
}

/// See also [GameController].
class GameControllerProvider
    extends AutoDisposeNotifierProviderImpl<GameController, GameState> {
  /// See also [GameController].
  GameControllerProvider(GameSetup setup)
      : this._internal(
        () => GameController()..setup = setup,
        from: gameControllerProvider,
        name: r'gameControllerProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$gameControllerHash,
        dependencies: GameControllerFamily._dependencies,
        allTransitiveDependencies:
            GameControllerFamily._allTransitiveDependencies,
        setup: setup,
      );

  GameControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.setup,
  }) : super.internal();

  final GameSetup setup;

  @override
  GameState runNotifierBuild(covariant GameController notifier) {
    return notifier.build(setup);
  }

  @override
  Override overrideWith(GameController Function() create) {
    return ProviderOverride(
      origin: this,
      override: GameControllerProvider._internal(
        () => create()..setup = setup,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        setup: setup,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<GameController, GameState>
  createElement() {
    return _GameControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GameControllerProvider && other.setup == setup;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, setup.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GameControllerRef on AutoDisposeNotifierProviderRef<GameState> {
  /// The parameter `setup` of this provider.
  GameSetup get setup;
}

class _GameControllerProviderElement
    extends AutoDisposeNotifierProviderElement<GameController, GameState>
    with GameControllerRef {
  _GameControllerProviderElement(super.provider);

  @override
  GameSetup get setup => (origin as GameControllerProvider).setup;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
