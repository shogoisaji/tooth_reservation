// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$supabaseClientHash() => r'36e9cae00709545a85bfe4a5a2cb98d8686a01ea';

/// See also [supabaseClient].
@ProviderFor(supabaseClient)
final supabaseClientProvider = AutoDisposeProvider<SupabaseClient>.internal(
  supabaseClient,
  name: r'supabaseClientProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$supabaseClientHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SupabaseClientRef = AutoDisposeProviderRef<SupabaseClient>;
String _$sessionResponseHash() => r'0905adf3ae598ff2aa1a02d8c94bb37e38fa780d';

/// See also [sessionResponse].
@ProviderFor(sessionResponse)
final sessionResponseProvider = AutoDisposeStreamProvider<Session?>.internal(
  sessionResponse,
  name: r'sessionResponseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sessionResponseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SessionResponseRef = AutoDisposeStreamProviderRef<Session?>;
String _$userHash() => r'ab2df5873e3ef7f2c712e327805bedfeab043ca4';

/// See also [user].
@ProviderFor(user)
final userProvider = AutoDisposeProvider<User?>.internal(
  user,
  name: r'userProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$userHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UserRef = AutoDisposeProviderRef<User?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
