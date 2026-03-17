// lib/features/admin/presentation/providers/excel_upload_state.dart

import 'package:file_picker/file_picker.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'excel_upload_state.freezed.dart';

@freezed
abstract class ExcelUploadState with _$ExcelUploadState {
  const factory ExcelUploadState({
    @Default('') String groupName,
    @Default(null) PlatformFile? selectedFile,
    @Default(false) bool isUploading,
    @Default(false) bool isSuccess,
    @Default(null) String? errorMessage,
    @Default(null) PlatformFile? selectedImage,
  }) = _ExcelUploadState;
}