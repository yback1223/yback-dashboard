// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'excel_upload_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ExcelUploadViewModel)
const excelUploadViewModelProvider = ExcelUploadViewModelProvider._();

final class ExcelUploadViewModelProvider
    extends $NotifierProvider<ExcelUploadViewModel, ExcelUploadState> {
  const ExcelUploadViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'excelUploadViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$excelUploadViewModelHash();

  @$internal
  @override
  ExcelUploadViewModel create() => ExcelUploadViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExcelUploadState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExcelUploadState>(value),
    );
  }
}

String _$excelUploadViewModelHash() =>
    r'd62d3bc82e509c44797099f742e8f7715a86c3c5';

abstract class _$ExcelUploadViewModel extends $Notifier<ExcelUploadState> {
  ExcelUploadState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ExcelUploadState, ExcelUploadState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ExcelUploadState, ExcelUploadState>,
              ExcelUploadState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
