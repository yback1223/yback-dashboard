// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_users_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DashboardUsersViewModel)
const dashboardUsersViewModelProvider = DashboardUsersViewModelProvider._();

final class DashboardUsersViewModelProvider
    extends $NotifierProvider<DashboardUsersViewModel, DashboardUsersState> {
  const DashboardUsersViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dashboardUsersViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dashboardUsersViewModelHash();

  @$internal
  @override
  DashboardUsersViewModel create() => DashboardUsersViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DashboardUsersState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DashboardUsersState>(value),
    );
  }
}

String _$dashboardUsersViewModelHash() =>
    r'5cd6da28374cf47ca3d16549b8a3bc61e27f4409';

abstract class _$DashboardUsersViewModel
    extends $Notifier<DashboardUsersState> {
  DashboardUsersState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<DashboardUsersState, DashboardUsersState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DashboardUsersState, DashboardUsersState>,
              DashboardUsersState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
