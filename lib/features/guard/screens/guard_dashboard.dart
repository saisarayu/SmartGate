import 'package:flutter/material.dart';
import '../../../core/app_theme.dart';
import '../../../core/models/visitor.dart';
import '../../../core/services/app_database.dart';
import 'visitor_registration_screen.dart';
import 'visitor_history_screen.dart';

class GuardDashboard extends StatefulWidget {
  const GuardDashboard({super.key});

  @override
  State<GuardDashboard> createState() => _GuardDashboardState();
}

class _GuardDashboardState extends State<GuardDashboard> {
  int _selectedIndex = 0;
  final AppDatabase _db = AppDatabase.instance;

  @override
  void initState() {
    super.initState();
    _db.addListener(_onDbChange);
  }

  @override
  void dispose() {
    _db.removeListener(_onDbChange);
    super.dispose();
  }

  void _onDbChange() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surfaceLight,
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildDashboardTab(),
          VisitorRegistrationScreen(onRegistered: () => setState(() => _selectedIndex = 0)),
          const VisitorHistoryScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 20, offset: const Offset(0, -4))],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (i) => setState(() => _selectedIndex = i),
          backgroundColor: Colors.white,
          selectedItemColor: AppTheme.primaryNavy,
          unselectedItemColor: AppTheme.textMuted,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), activeIcon: Icon(Icons.dashboard), label: "Dashboard"),
            BottomNavigationBarItem(icon: Icon(Icons.person_add_outlined), activeIcon: Icon(Icons.person_add), label: "Register"),
            BottomNavigationBarItem(icon: Icon(Icons.history_outlined), activeIcon: Icon(Icons.history), label: "History"),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardTab() {
    final today = _db.todayVisitors;
    final pending = _db.pendingVisitors;
    final inside = _db.insideVisitors;

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          // ─── Header ────────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              decoration: const BoxDecoration(
                color: AppTheme.primaryNavy,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Good Morning,", style: TextStyle(color: Colors.white60, fontSize: 14)),
                          const Text("Security Guard", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                          const SizedBox(height: 2),
                          Text(_todayLabel(), style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12)),
                        ],
                      ),
                      Row(
                        children: [
                          Stack(
                            children: [
                              IconButton(icon: const Icon(Icons.notifications_outlined, color: Colors.white), onPressed: () {}),
                              if (pending.isNotEmpty)
                                Positioned(
                                  right: 8, top: 8,
                                  child: Container(
                                    width: 16, height: 16,
                                    decoration: const BoxDecoration(color: AppTheme.danger, shape: BoxShape.circle),
                                    child: Center(
                                      child: Text("${pending.length}", style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () => Navigator.of(context).popUntil((route) => route.isFirst),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                              child: const Icon(Icons.logout, color: Colors.white, size: 20),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      _buildStatChip("${today.length}", "Today", Icons.people_outline),
                      const SizedBox(width: 12),
                      _buildStatChip("${inside.length}", "Inside", Icons.login),
                      const SizedBox(width: 12),
                      _buildStatChip("${pending.length}", "Pending", Icons.hourglass_top_outlined),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ─── Body ──────────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quick Actions
                  const Text("Quick Actions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textDark)),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      _buildActionButton(icon: Icons.person_add_outlined, label: "Register\nVisitor", color: AppTheme.accentEmerald, onTap: () => setState(() => _selectedIndex = 1)),
                      const SizedBox(width: 12),
                      _buildActionButton(icon: Icons.qr_code_scanner, label: "Scan\nQR Code", color: AppTheme.primaryNavy, onTap: _showQrScannerDialog),
                      const SizedBox(width: 12),
                      _buildActionButton(icon: Icons.notifications_active_outlined, label: "Alerts &\nBlacklist", color: AppTheme.danger, onTap: _showAlertsDialog),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // ─── Pending Approvals from Resident ─────────────────────
                  if (pending.isNotEmpty) ...[
                    Row(
                      children: [
                        const Text("Awaiting Resident Approval", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.textDark)),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(color: AppTheme.warning, borderRadius: BorderRadius.circular(10)),
                          child: Text("${pending.length}", style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ...pending.map((v) => _buildVisitorCard(v)),
                    const SizedBox(height: 20),
                  ],

                  // ─── Today's Visitors ─────────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Today's Visitors", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.textDark)),
                      TextButton(
                        onPressed: () => setState(() => _selectedIndex = 2),
                        child: const Text("View All", style: TextStyle(color: AppTheme.primaryNavy)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  if (today.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                      child: const Column(
                        children: [
                          Icon(Icons.group_outlined, size: 48, color: AppTheme.textMuted),
                          SizedBox(height: 8),
                          Text("No visitors today yet", style: TextStyle(color: AppTheme.textMuted)),
                        ],
                      ),
                    )
                  else
                    ...today.map((v) => _buildVisitorCard(v)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(String value, String label, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.12), borderRadius: BorderRadius.circular(14)),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(height: 6),
            Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 20)),
            Text(label, style: const TextStyle(color: Colors.white60, fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 8),
              Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w600, height: 1.3)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVisitorCard(Visitor visitor) {
    final status = visitor.status;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppTheme.primaryNavy.withOpacity(0.1),
            child: Text(visitor.name[0], style: const TextStyle(color: AppTheme.primaryNavy, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(visitor.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppTheme.textDark)),
                const SizedBox(height: 2),
                Text(
                  "${visitor.residentFlat} • ${visitor.purpose} • ${visitor.timeLabel}",
                  style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Status badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: status.color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                child: Text(status.label, style: TextStyle(fontSize: 11, color: status.color, fontWeight: FontWeight.w700)),
              ),
              // Action buttons
              if (status == VisitorStatus.approved) ...[
                const SizedBox(height: 6),
                _miniButton("Check-In", AppTheme.accentEmerald, () {
                  _db.checkInVisitor(visitor.id);
                  _showSnackbar("${visitor.name} checked in", AppTheme.accentEmerald);
                }),
              ] else if (status == VisitorStatus.checkedIn) ...[
                const SizedBox(height: 6),
                _miniButton("Check-Out", AppTheme.danger, () {
                  _db.checkOutVisitor(visitor.id);
                  _showSnackbar("${visitor.name} checked out", AppTheme.textMuted);
                }),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _miniButton(String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10), border: Border.all(color: color.withOpacity(0.3))),
        child: Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w700)),
      ),
    );
  }

  void _showSnackbar(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ));
  }

  void _showQrScannerDialog() {
    // Find an approved visitor to simulate scan
    final approved = _db.allVisitors.where((v) => v.status == VisitorStatus.approved).toList();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("QR Scanner", style: TextStyle(fontWeight: FontWeight.w700)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 160, height: 160,
              decoration: BoxDecoration(color: AppTheme.surfaceLight, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.primaryNavy.withOpacity(0.2))),
              child: const Center(child: Icon(Icons.qr_code_scanner, size: 80, color: AppTheme.primaryNavy)),
            ),
            const SizedBox(height: 14),
            if (approved.isNotEmpty)
              Text("${approved.first.name} (${approved.first.residentFlat})", textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            const Text("Simulating scan of approved visitor pass.", textAlign: TextAlign.center, style: TextStyle(color: AppTheme.textMuted, fontSize: 13)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Close")),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              if (approved.isNotEmpty) {
                _db.checkInVisitor(approved.first.id);
                _showSnackbar("${approved.first.name} scanned & checked in!", AppTheme.accentEmerald);
              } else {
                _showSnackbar("No approved visitors to scan", AppTheme.warning);
              }
            },
            child: const Text("Simulate Scan"),
          ),
        ],
      ),
    );
  }

  void _showAlertsDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(children: [
          Icon(Icons.warning_amber_rounded, color: AppTheme.danger, size: 22),
          SizedBox(width: 8),
          Text("Alerts & Blacklist", style: TextStyle(fontWeight: FontWeight.w700)),
        ]),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _db.blacklist.map((item) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppTheme.danger.withOpacity(0.07), borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  const Icon(Icons.block, color: AppTheme.danger, size: 18),
                  const SizedBox(width: 10),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(item["name"]!, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                    Text("${item["reason"]}  •  ${item["date"]}", style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                  ])),
                ],
              ),
            )).toList(),
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Close"))],
      ),
    );
  }

  static String _todayLabel() {
    final now = DateTime.now();
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    const days = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'];
    return '${days[now.weekday - 1]}, ${now.day} ${months[now.month - 1]} ${now.year}';
  }
}
