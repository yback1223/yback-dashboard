// lib/features/admin/presentation/screens/excel_upload_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/excel_upload_view_model.dart';
import '../providers/excel_upload_state.dart';

class ExcelUploadScreen extends ConsumerWidget {
  const ExcelUploadScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(excelUploadViewModelProvider);
    final notifier = ref.read(excelUploadViewModelProvider.notifier);

    ref.listen(excelUploadViewModelProvider.select((s) => s.errorMessage), (prev, next) {
      if (next != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next), backgroundColor: Colors.red.shade700),
        );
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: state.isSuccess 
            ? _buildSuccessView(notifier) 
            : _buildUploadCard(context, state, notifier),
        ),
      ),
    );
  }

  Widget _buildUploadCard(BuildContext context, ExcelUploadState state, ExcelUploadViewModel notifier) {
    return Container(
      key: const ValueKey("upload_form"),
      width: 640, // 가로 레이아웃이므로 너비를 조금 더 넓힘
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 32, offset: const Offset(0, 12)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("유저 데이터 일괄 업로드", 
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
          const SizedBox(height: 48),

          // 1. 서비스 그룹 입력 (수평 배치)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildLabelSection("서비스 그룹명"),
              Expanded(
                child: TextField(
                  onChanged: notifier.setGroupName,
                  style: const TextStyle(fontSize: 15),
                  decoration: _inputDecoration("그룹명을 입력하세요"),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildLabelSection("그룹 이미지 (선택)"),
              Expanded(
                child: InkWell(
                  onTap: notifier.pickImage, // ViewModel에 정의 필요
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 56,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: state.selectedImage != null ? Colors.indigo.shade200 : Colors.transparent),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.image_outlined, size: 20, color: Colors.indigo.shade400),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            state.selectedImage?.name ?? "그룹 이미지를 선택하세요 (PNG, JPG)",
                            style: TextStyle(
                              color: state.selectedImage == null ? Colors.blueGrey.shade400 : Colors.indigo.shade700,
                              fontSize: 14,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        if (state.selectedImage != null)
                          const Icon(Icons.check_circle, size: 18, color: Colors.green),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // 2. 파일 선택 영역 (수평 배치)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildLabelSection("엑셀 파일 선택"),
              Expanded(
                child: InkWell(
                  onTap: state.isUploading ? null : notifier.pickFile,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 56, // TextField와 높이를 맞춰 일체감 부여
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.indigo.shade50),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.file_present, size: 20, color: Colors.indigo.shade400),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            state.selectedFile?.name ?? "파일 선택 (.xlsx, .xls)",
                            style: TextStyle(
                              color: state.selectedFile == null ? Colors.blueGrey.shade400 : Colors.indigo.shade700,
                              fontSize: 14,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 48),

          // 3. 전송 버튼
          Row(
            children: [
              const SizedBox(width: 140), // 라벨 영역만큼 띄워서 버튼 정렬
              Expanded(
                child: SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: (state.isUploading || state.selectedFile == null || state.groupName.isEmpty)
                        ? null 
                        : notifier.uploadExcel,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo.shade600,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.blueGrey.shade100,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: state.isUploading 
                      ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text("데이터 업로드 시작", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 🚨 [집행] 라벨의 너비를 고정하여 정렬 라인을 맞춤
  Widget _buildLabelSection(String text) {
    return SizedBox(
      width: 140, // 고정 너비 집행
      child: Text(
        text, 
        style: const TextStyle(
          fontWeight: FontWeight.w700, 
          color: Color(0xFF475569), 
          fontSize: 14
        )
      ),
    );
  }

  Widget _buildSuccessView(ExcelUploadViewModel notifier) {
    return Container(
      key: const ValueKey("success_view"),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 80),
          const SizedBox(height: 24),
          const Text("업로드가 완료되었습니다.", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 40),
          TextButton.icon(
            onPressed: notifier.reset,
            icon: const Icon(Icons.refresh),
            label: const Text("추가 업로드 하기"),
          )
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.blueGrey, fontSize: 14),
      filled: true,
      fillColor: const Color(0xFFF1F5F9), // 배경색 통일
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.transparent),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.indigo, width: 2),
      ),
    );
  }
}