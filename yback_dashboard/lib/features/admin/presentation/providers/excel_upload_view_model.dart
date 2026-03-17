// lib/features/admin/presentation/providers/excel_upload_view_model.dart

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/dio_provider.dart';
import 'excel_upload_state.dart';

part 'excel_upload_view_model.g.dart';

@riverpod
class ExcelUploadViewModel extends _$ExcelUploadViewModel {
  @override
  ExcelUploadState build() => const ExcelUploadState();

  void setGroupName(String name) => state = state.copyWith(groupName: name);

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
      withData: kIsWeb, // 웹에서는 bytes가 필수
    );

    if (result != null) {
      state = state.copyWith(
        selectedFile: result.files.first,
        isSuccess: false,
        errorMessage: null,
      );
    }
  }

  Future<void> uploadExcel() async {
    if (state.selectedFile == null || state.groupName.isEmpty) {
      state = state.copyWith(errorMessage: "그룹명과 파일을 확인해라.");
      return;
    }

    state = state.copyWith(isUploading: true, errorMessage: null);
    final dio = ref.read(dioProvider);

    try {
      final dynamic fileData = kIsWeb
          ? MultipartFile.fromBytes(state.selectedFile!.bytes!, filename: state.selectedFile!.name)
          : await MultipartFile.fromFile(state.selectedFile!.path!, filename: state.selectedFile!.name);

      final formData = FormData.fromMap({
        "serviceGroup": state.groupName,
        "file": fileData,
        if (state.selectedImage != null)
            "image": kIsWeb 
                ? MultipartFile.fromBytes(state.selectedImage!.bytes!, filename: state.selectedImage!.name)
                : await MultipartFile.fromFile(state.selectedImage!.path!, filename: state.selectedImage!.name),
      });

      await dio.post("/users/upload", data: formData);
      state = state.copyWith(isUploading: false, isSuccess: true, selectedFile: null);
    } catch (e) {
      state = state.copyWith(isUploading: false, errorMessage: "업로드 실패: $e");
    }
  }

  Future<void> pickImage() async {
  final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      state = state.copyWith(selectedImage: result.files.first);
    }
  }

  void reset() => state = const ExcelUploadState();
}