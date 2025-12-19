import 'package:flutter/material.dart';

class DashboardFilterSection extends StatelessWidget {
  final String selectedServiceType;
  final List<String> serviceOptions;
  final ValueChanged<String?> onServiceTypeChanged;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;

  const DashboardFilterSection({
    super.key,
    required this.selectedServiceType,
    required this.serviceOptions,
    required this.onServiceTypeChanged,
    required this.searchController,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    // [핵심] Container로 감싸고 width: double.infinity (width: 100%) 부여
    return Container(
      width: double.infinity, 
      padding: const EdgeInsets.only(bottom: 16), // 아래쪽 여백 살짝 추가
      child: Wrap(
        // 이제 부모가 꽉 찼으니, 여기서 center가 비로소 화면 중앙이 됩니다.
        alignment: WrapAlignment.center, 
        
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 16,
        runSpacing: 10,
        
        children: [
          // 드롭다운
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedServiceType,
                items: serviceOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: onServiceTypeChanged,
              ),
            ),
          ),
          
          // 검색창
          SizedBox(
            width: 300, 
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: "이름 검색",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
                isDense: true,
                contentPadding: EdgeInsets.all(12),
              ),
              onChanged: onSearchChanged,
            ),
          ),
        ],
      ),
    );
  }
}