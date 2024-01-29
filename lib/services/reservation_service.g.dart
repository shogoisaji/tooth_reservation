// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$reservationListStreamHash() =>
    r'2db33cd56bf58b6c01971a679de23b36ec8283fa';

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
String _$reservationListHash() => r'472316a8c1e34fff5610d16c7e3220b5d83a924c';

/// See also [reservationList].
@ProviderFor(reservationList)
final reservationListProvider =
    AutoDisposeProvider<List<Reservation>?>.internal(
  reservationList,
  name: r'reservationListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$reservationListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ReservationListRef = AutoDisposeProviderRef<List<Reservation>?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
