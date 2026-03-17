// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DashboardViewModel)
const dashboardViewModelProvider = DashboardViewModelProvider._();

final class DashboardViewModelProvider
    extends $AsyncNotifierProvider<DashboardViewModel, List<UserEntity>> {
  const DashboardViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dashboardViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dashboardViewModelHash();

  @$internal
  @override
  DashboardViewModel create() => DashboardViewModel();
}

String _$dashboardViewModelHash() =>
    r'37ce2b9d5abd3e5b335552e0f25029a19d539c6e';

abstract class _$DashboardViewModel extends $AsyncNotifier<List<UserEntity>> {
  FutureOr<List<UserEntity>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<List<UserEntity>>, List<UserEntity>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<UserEntity>>, List<UserEntity>>,
              AsyncValue<List<UserEntity>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
