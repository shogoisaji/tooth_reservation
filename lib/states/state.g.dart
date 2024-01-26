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
String _$loggedInUserDataHash() => r'ec6b0a483e64861f7811b720997670639d6e4ba6';

/// See also [loggedInUserData].
@ProviderFor(loggedInUserData)
final loggedInUserDataProvider = AutoDisposeProvider<User?>.internal(
  loggedInUserData,
  name: r'loggedInUserDataProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$loggedInUserDataHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef LoggedInUserDataRef = AutoDisposeProviderRef<User?>;
String _$loggedInUserHash() => r'fe665faf28005eb37bdb2290215b70a6e0c3ef04';

/// See also [loggedInUser].
@ProviderFor(loggedInUser)
final loggedInUserProvider = AutoDisposeProvider<LoggedInUser?>.internal(
  loggedInUser,
  name: r'loggedInUserProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$loggedInUserHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef LoggedInUserRef = AutoDisposeProviderRef<LoggedInUser?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
