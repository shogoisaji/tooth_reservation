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
String _$loggedInUserHash() => r'8220a299ef194d36bfa4195037821246e6b3dc21';

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
String _$detailSelectStateHash() => r'82a7baeee4c0f3c4827f4fefaa8da9c71c5f0794';

/// See also [DetailSelectState].
@ProviderFor(DetailSelectState)
final detailSelectStateProvider =
    AutoDisposeNotifierProvider<DetailSelectState, bool>.internal(
  DetailSelectState.new,
  name: r'detailSelectStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$detailSelectStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DetailSelectState = AutoDisposeNotifier<bool>;
String _$selectedDateHash() => r'bd5bfdc5c0202498b5cd755e663769f3ce1df8fa';

/// See also [SelectedDate].
@ProviderFor(SelectedDate)
final selectedDateProvider = NotifierProvider<SelectedDate, DateTime>.internal(
  SelectedDate.new,
  name: r'selectedDateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$selectedDateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedDate = Notifier<DateTime>;
String _$businessHoursHash() => r'274c74f2d974d811f5c92e680bca15cab1b0479f';

/// See also [BusinessHours].
@ProviderFor(BusinessHours)
final businessHoursProvider =
    AutoDisposeNotifierProvider<BusinessHours, List<Map<String, int>>>.internal(
  BusinessHours.new,
  name: r'businessHoursProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$businessHoursHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$BusinessHours = AutoDisposeNotifier<List<Map<String, int>>>;
String _$dragStateHash() => r'1e32b57e507aa4c7050643892541fd31e53da4af';

/// See also [DragState].
@ProviderFor(DragState)
final dragStateProvider = AutoDisposeNotifierProvider<DragState, bool>.internal(
  DragState.new,
  name: r'dragStateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$dragStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DragState = AutoDisposeNotifier<bool>;
String _$timerNotifierHash() => r'3ad6019d148cb60bf26f63839291d4b364a33cec';

/// See also [TimerNotifier].
@ProviderFor(TimerNotifier)
final timerNotifierProvider =
    AutoDisposeNotifierProvider<TimerNotifier, bool>.internal(
  TimerNotifier.new,
  name: r'timerNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$timerNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TimerNotifier = AutoDisposeNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
