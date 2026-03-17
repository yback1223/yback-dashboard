// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_users_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AdminUsersViewModel)
const adminUsersViewModelProvider = AdminUsersViewModelProvider._();

final class AdminUsersViewModelProvider
    extends $NotifierProvider<AdminUsersViewModel, AdminUsersState> {
  const AdminUsersViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminUsersViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminUsersViewModelHash();

  @$internal
  @override
  AdminUsersViewModel create() => AdminUsersViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AdminUsersState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AdminUsersState>(value),
    );
  }
}

String _$adminUsersViewModelHash() =>
    r'6e9e43f42c8c985ed8a88e998390f66737351132';

abstract class _$AdminUsersViewModel extends $Notifier<AdminUsersState> {
  AdminUsersState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AdminUsersState, AdminUsersState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AdminUsersState, AdminUsersState>,
              AdminUsersState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
