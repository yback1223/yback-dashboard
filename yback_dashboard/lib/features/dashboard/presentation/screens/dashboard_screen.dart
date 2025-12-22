import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/dashboard_view_model.dart';
import '../../domain/entities/user_entity.dart';
import '../widgets/dashboard_filter_section.dart';
import '../widgets/dashboard_table.dart';
import 'package:yback_dashboard/features/auth/data/providers/auth_provider.dart';
import 'package:yback_dashboard/core/constants/app_assets.dart';
import 'dart:async';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  // UI 상태
  String _searchQuery = "";
  String _selectedServiceType = "전체";
  Timer? _debounce;
  
  // ❌ [삭제됨] 하드코딩된 리스트 제거
  // final List<String> _serviceOptions = ["전체", "GPT", "Poe"]; 

  final TextEditingController _searchController = TextEditingController();

  // 정렬 상태
  int? _sortColumnIndex;
  bool _isAscending = true;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSort(int columnIndex, bool ascending) {
    setState(() {
      if (_sortColumnIndex == columnIndex) {
        if (_isAscending) {
          _isAscending = false;
        } else {
          _sortColumnIndex = null;
          _isAscending = true;
        }
      } else {
        _sortColumnIndex = columnIndex;
        _isAscending = true;
      }
    });
  }

  List<UserEntity> _sortUsers(List<UserEntity> users) {
    if (_sortColumnIndex == null) return users;

    final sortedUsers = List<UserEntity>.from(users);
    sortedUsers.sort((a, b) {
      int comparison = 0;
      switch (_sortColumnIndex) {
        case 0:
          comparison = a.name.compareTo(b.name);
          break;
        case 4:
          comparison = a.dDay.compareTo(b.dDay);
          break;
        default:
          comparison = 0;
      }
      return _isAscending ? comparison : -comparison;
    });
    return sortedUsers;
  }

  List<UserEntity> _filterUsers(List<UserEntity> users) {
    if (_searchQuery.isNotEmpty) {
      return users.where((user) => 
        user.name.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }
    if (_selectedServiceType == "전체") {
      return users;
    } else {
      return users.where((user) => user.serviceType == _selectedServiceType).toList();
    }
  }

  String _getUniversityLogoPath(String? universityName) {
    if (universityName == "건국대학교") {
      return AppAssets.konkukNameLogo;
    }
    return AppAssets.konkukNameLogo;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dashboardViewModelProvider);
    final session = ref.watch(authProvider);
    
    final universityName = session.value?.university ?? '';
    final username = session.value?.username ?? '';

    // ✅ [추가] 받아온 데이터(state)를 스캔해서 동적으로 옵션 리스트 생성
    final List<String> dynamicServiceOptions = state.maybeWhen(
      data: (users) {
        // 1. users 리스트에서 serviceType만 뽑아냄 ("GPT", "Poe", "GPT", ...)
        // 2. toSet()으로 중복 제거 ({"GPT", "Poe"})
        // 3. toList()로 다시 리스트 변환
        final distinctTypes = users.map((u) => u.serviceType).toSet().toList();
        
        // 4. 가나다순 정렬 (깔끔하게 보이기 위해)
        distinctTypes.sort();
        
        // 5. 맨 앞에 "전체" 옵션 추가
        return ["전체", ...distinctTypes];
      },
      orElse: () => ["전체"], // 데이터 로딩 전이나 에러 시 안전하게 기본값
    );

    // 🛡️ [안전장치] 만약 선택된 타입("GPT")이 데이터 갱신 후 사라졌다면? -> "전체"로 리셋
    // (build 안에 setState를 직접 쓸 수 없으므로, 위젯 렌더링 시 값만 보정해서 전달)
    final safeSelectedServiceType = dynamicServiceOptions.contains(_selectedServiceType)
        ? _selectedServiceType
        : "전체";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 250, 
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Row(
            children: [
              Image.asset(
                _getUniversityLogoPath(universityName),
                height: 40,
                width: 40,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 8),
              Text(
                universityName,
                style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
        title: const Text(
          "AI 솔루션 계정 현황",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            tooltip: "새로고침",
            onPressed: () => ref.read(dashboardViewModelProvider.notifier).refresh(),
          ),
          const SizedBox(width: 16),
          if (session.value != null)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "$username 님",
                  style: const TextStyle(
                    color: Colors.black87, 
                    fontWeight: FontWeight.bold, 
                    fontSize: 14
                  ),
                ),
                const Text(
                  "관리자",
                  style: TextStyle(color: Colors.grey, fontSize: 10),
                ),
              ],
            ),
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            tooltip: "로그아웃",
            onPressed: () => ref.read(authProvider.notifier).logout(),
          ),
          const SizedBox(width: 16),
        ],
      ),
      
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // ---------------------------------------------------------
            // 필터 섹션에 동적 옵션 전달
            // ---------------------------------------------------------
            DashboardFilterSection(
              // 만약 기존 선택값이 목록에 없으면 "전체"를 보여줌
              selectedServiceType: safeSelectedServiceType, 
              
              // 여기서 만든 동적 리스트를 전달
              serviceOptions: dynamicServiceOptions, 
              
              searchController: _searchController,
              onServiceTypeChanged: (value) {
                if (value != null) {
                   setState(() => _selectedServiceType = value);
                }
              },
              onSearchChanged: (value) {
                // 1. 만약 이미 동작 중인 타이머가 있다면 취소 (타이핑 중이라는 뜻)
                if (_debounce?.isActive ?? false) _debounce!.cancel();

                // 2. 0.5초(500ms) 뒤에 실행되도록 타이머 예약
                _debounce = Timer(const Duration(milliseconds: 500), () {
                  // 3. 0.5초 동안 추가 입력이 없으면 비로소 setState 실행
                  setState(() {
                    _searchQuery = value;
                  });
                });
              },
            ),
            
            const SizedBox(height: 16),

            Expanded(
              child: state.when(
                data: (users) {
                  // 필터링 할 때도 safeSelectedServiceType을 써야 안전함
                  // (하지만 여기선 _selectedServiceType을 써도 "전체"가 아니면 필터링이 안 될 뿐 에러는 안 남)
                  final filteredUsers = _filterUsers(users);
                  final sortedAndFilteredUsers = _sortUsers(filteredUsers);
                  
                  return DashboardTable(
                    users: sortedAndFilteredUsers,
                    sortColumnIndex: _sortColumnIndex,
                    sortAscending: _isAscending,
                    onSort: _onSort,
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text("에러: $err")),
              ),
            ),
          ],
        ),
      ),
    );
  }
}