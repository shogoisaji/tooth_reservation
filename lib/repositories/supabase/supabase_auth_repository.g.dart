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
    r'79e0ac33f71f7819a1cd3b80948793b63110bf3a';

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
String _$sessionStateHash() => r'd5ba036bbbe6fddd87b40240e2fa0fef1bf3bd4a';

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
