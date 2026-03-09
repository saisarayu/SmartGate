import 'package:flutter/material.dart';
import '../../../core/app_theme.dart';
import '../../../core/models/visitor.dart';
import '../../../core/services/app_database.dart';

class VisitorHistoryScreen extends StatefulWidget {
  const VisitorHistoryScreen({super.key});

  @override
  State<VisitorHistoryScreen> createState() => _VisitorHistoryScreenState();
}

class _VisitorHistoryScreenState extends State<VisitorHistoryScreen> {
  final _searchController = TextEditingController();
  String _filter = "All";
  final AppDatabase _db = AppDatabase.instance;

  @override
  void initState() {
    super.initState();
    _db.addListener(_onDbChange);
  }

  @override
  void dispose() {
    _db.removeListener(_onDbChange);
    _searchController.dispose();
    super.dispose();
  }

  void _onDbChange() => setState(() {});

  List<Visitor> get _filtered {
    final query = _searchController.text.toLowerCase();
    return _db.allVisitors.where((v) {
      final matchesFilter = _filter == "All" || v.status.label == _filter;
      final matchesSearch = query.isEmpty ||
          v.name.toLowerCase().contains(query) ||
          v.residentFlat.toLowerCase().contains(query) ||
          v.purpose.toLowerCase().contains(query);
      return matchesFilter && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surfaceLight,
      appBar: AppBar(title: const Text("Visitor History"), automaticallyImplyLeading: false),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: "Search by name, flat or purpose...",
                prefixIcon: const Icon(Icons.search, color: AppTheme.textMuted),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(icon: const Icon(Icons.clear, color: AppTheme.textMuted), onPressed: () { _searchController.clear(); setState(() {}); })
                    : null,
              ),
            ),
          ),

          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: ["All", "Pending", "Approved", "Checked In", "Checked Out", "Rejected"].map((label) {
                final isSelected = _filter == label;
                final color = _statusColor(label);
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _filter = label),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? color : color.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(label, style: TextStyle(fontSize: 13, color: isSelected ? Colors.white : color, fontWeight: FontWeight.w600)),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Row(children: [
              Text("${_filtered.length} records  •  ${_db.allVisitors.length} total", style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
            ]),
          ),

          Expanded(
            child: _filtered.isEmpty
                ? const Center(
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(Icons.search_off, size: 60, color: AppTheme.textMuted),
                      SizedBox(height: 12),
                      Text("No records found", style: TextStyle(color: AppTheme.textMuted)),
                    ]),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    itemCount: _filtered.length,
                    itemBuilder: (ctx, i) => _buildHistoryCard(_filtered[i]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(Visitor v) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppTheme.primaryNavy.withOpacity(0.1),
                child: Text(v.name[0], style: const TextStyle(color: AppTheme.primaryNavy, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(v.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppTheme.textDark)),
                    Text("${v.residentFlat} • ${v.purpose}", style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: v.status.color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                child: Text(v.status.label, style: TextStyle(fontSize: 11, color: v.status.color, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(height: 1, color: Color(0xFFF0F0F0)),
          const SizedBox(height: 10),
          Row(
            children: [
              _infoChip(Icons.calendar_today_outlined, v.dateLabel),
              const SizedBox(width: 14),
              _infoChip(Icons.login, "In: ${v.checkInLabel}"),
              const SizedBox(width: 14),
              _infoChip(Icons.logout, "Out: ${v.checkOutLabel}"),
              if (v.hasSelfie) ...[
                const SizedBox(width: 14),
                _infoChip(Icons.photo_camera_outlined, "Selfie"),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoChip(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 12, color: AppTheme.textMuted),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
      ],
    );
  }

  Color _statusColor(String label) {
    switch (label) {
      case "Pending": return AppTheme.warning;
      case "Approved": return AppTheme.accentEmerald;
      case "Checked In": return AppTheme.accentEmerald;
      case "Checked Out": return AppTheme.textMuted;
      case "Rejected": return AppTheme.danger;
      default: return AppTheme.primaryNavy;
    }
  }
}
