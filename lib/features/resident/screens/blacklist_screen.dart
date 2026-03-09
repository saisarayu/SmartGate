import 'package:flutter/material.dart';
import '../../../core/app_theme.dart';
import '../../../core/services/app_database.dart';

class BlacklistScreen extends StatefulWidget {
  final AppDatabase? db;
  const BlacklistScreen({super.key, this.db});

  @override
  State<BlacklistScreen> createState() => _BlacklistScreenState();
}

class _BlacklistScreenState extends State<BlacklistScreen> {
  late final AppDatabase _db;

  @override
  void initState() {
    super.initState();
    _db = widget.db ?? AppDatabase.instance;
    _db.addListener(_onDbChange);
  }

  @override
  void dispose() {
    _db.removeListener(_onDbChange);
    super.dispose();
  }

  void _onDbChange() => setState(() {});

  void _addToBlacklist() {
    String name = "";
    String reason = "";
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(children: [
          Icon(Icons.block, color: AppTheme.danger, size: 20),
          SizedBox(width: 8),
          Text("Blacklist Visitor", style: TextStyle(fontWeight: FontWeight.w700)),
        ]),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(hintText: "Visitor name", prefixIcon: Icon(Icons.person_outline)),
              textCapitalization: TextCapitalization.words,
              onChanged: (v) => name = v,
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(hintText: "Reason for blacklisting", prefixIcon: Icon(Icons.info_outline)),
              onChanged: (v) => reason = v,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("CANCEL")),
          ElevatedButton(
            onPressed: () {
              final trimName = name.trim();
              final trimReason = reason.trim();
              if (trimName.isNotEmpty && trimReason.isNotEmpty) {
                _db.addToBlacklist(name: trimName, reason: trimReason);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("$trimName added to blacklist"),
                  backgroundColor: AppTheme.danger,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ));
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.danger),
            child: const Text("BLACKLIST"),
          ),
        ],
      ),
    );
  }

  void _removeFromBlacklist(int index) {
    final name = _db.blacklist[index]["name"] ?? "";
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text("Remove from Blacklist?", style: TextStyle(fontWeight: FontWeight.w700)),
        content: Text("Are you sure you want to remove \"$name\" from the blacklist?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("CANCEL")),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _db.removeFromBlacklist(index);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("$name removed from blacklist"),
                backgroundColor: AppTheme.accentEmerald,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ));
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentEmerald),
            child: const Text("REMOVE"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = _db.blacklist;
    return Scaffold(
      backgroundColor: AppTheme.surfaceLight,
      appBar: AppBar(
        title: const Text("Blacklist Management"),
        backgroundColor: AppTheme.danger,
        automaticallyImplyLeading: false,
      ),
      body: list.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppTheme.danger.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.verified_user_outlined, size: 64, color: AppTheme.danger),
                  ),
                  const SizedBox(height: 16),
                  const Text("No Blacklisted Visitors", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17, color: AppTheme.textDark)),
                  const SizedBox(height: 6),
                  const Text("Society is clear!", style: TextStyle(color: AppTheme.textMuted)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: list.length,
              itemBuilder: (context, index) {
                final item = list[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.danger.withOpacity(0.15)),
                    boxShadow: [BoxShadow(color: AppTheme.danger.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 3))],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: AppTheme.danger.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                        child: const Icon(Icons.block, color: AppTheme.danger, size: 22),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item["name"]!, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppTheme.textDark)),
                            const SizedBox(height: 3),
                            Text(item["reason"]!, style: const TextStyle(fontSize: 13, color: AppTheme.textMuted)),
                            const SizedBox(height: 2),
                            Text("Added: ${item["date"]!}", style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete_outline, color: Colors.grey.shade400),
                        onPressed: () => _removeFromBlacklist(index),
                        tooltip: "Remove from blacklist",
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addToBlacklist,
        backgroundColor: AppTheme.danger,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Add to Blacklist", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      ),
    );
  }
}
