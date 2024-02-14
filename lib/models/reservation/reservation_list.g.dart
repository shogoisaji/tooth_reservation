// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation_list.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$reservationListStreamHash() =>
    r'8e3d5c03e936528396554dc68fe773b2c4a99a57';

/// See also [reservationListStream].
@ProviderFor(reservationListStream)
final reservationListStreamProvider =
    AutoDisposeStreamProvider<List<Reservation>?>.internal(
  reservationListStream,
  name: r'reservationListStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$reservationListStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ReservationListStreamRef
    = AutoDisposeStreamProviderRef<List<Reservation>?>;
String _$reservationListHash() => r'b583ceaa3786d772fc540f7554cff527c7ed0feb';

/// See also [reservationList].
@ProviderFor(reservationList)
final reservationListProvider =
    AutoDisposeProvider<ReservationListState>.internal(
  reservationList,
  name: r'reservationListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$reservationListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ReservationListRef = AutoDisposeProviderRef<ReservationListState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
