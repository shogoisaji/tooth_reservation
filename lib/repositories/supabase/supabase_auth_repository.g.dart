// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supabase_auth_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$supabaseAuthRepositoryHash() =>
    r'9a3eaef2981bb21de115a6349c7becaed3127d78';

/// See also [supabaseAuthRepository].
@ProviderFor(supabaseAuthRepository)
final supabaseAuthRepositoryProvider =
    Provider<SupabaseAuthRepository>.internal(
  supabaseAuthRepository,
  name: r'supabaseAuthRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$supabaseAuthRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SupabaseAuthRepositoryRef = ProviderRef<SupabaseAuthRepository>;
String _$sessionStateStreamHash() =>
    r'036fe9ca553f4d7f4f452ad4dd976968662601e1';

/// See also [sessionStateStream].
@ProviderFor(sessionStateStream)
final sessionStateStreamProvider = AutoDisposeStreamProvider<Session?>.internal(
  sessionStateStream,
  name: r'sessionStateStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sessionStateStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SessionStateStreamRef = AutoDisposeStreamProviderRef<Session?>;
String _$sessionStateHash() => r'2f9931fdadfa74cb2f24bba6a1d12a3252424aaa';

/// See also [sessionState].
@ProviderFor(sessionState)
final sessionStateProvider = AutoDisposeProvider<Session?>.internal(
  sessionState,
  name: r'sessionStateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$sessionStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SessionStateRef = AutoDisposeProviderRef<Session?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
