import 'package:flutter/material.dart';
import '../../../core/app_theme.dart';
import '../../../core/models/visitor.dart';
import '../../../core/services/app_database.dart';
import 'blacklist_screen.dart';

class ResidentDashboard extends StatefulWidget {
  const ResidentDashboard({super.key});

  @override
  State<ResidentDashboard> createState() => _ResidentDashboardState();
}

class _ResidentDashboardState extends State<ResidentDashboard> {
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

  List<Visitor> get _pending => _db.pendingVisitors;
  List<Visitor> get _history => _db.allVisitors.where((v) => v.status != VisitorStatus.pending).toList();

  void _approve(Visitor v) {
    _db.approveVisitor(v.id);
    _showSnackbar("✅ ${v.name} approved for entry", AppTheme.accentEmerald);
  }

  void _reject(Visitor v) {
    _db.rejectVisitor(v.id);
    _showSnackbar("❌ ${v.name} rejected", AppTheme.danger);
  }

  void _showSnackbar(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surfaceLight,
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildDashboardTab(),
          _buildHistoryTab(),
          BlacklistScreen(db: _db),
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
          selectedItemColor: AppTheme.accentEmerald,
          unselectedItemColor: AppTheme.textMuted,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          items: [
            const BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: "Home"),
            const BottomNavigationBarItem(icon: Icon(Icons.history_outlined), activeIcon: Icon(Icons.history), label: "History"),
            BottomNavigationBarItem(
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.block_outlined),
                  if (_db.blacklist.isNotEmpty)
                    Positioned(
                      right: -4, top: -4,
                      child: Container(
                        width: 10, height: 10,
                        decoration: const BoxDecoration(color: AppTheme.danger, shape: BoxShape.circle),
                      ),
                    ),
                ],
              ),
              activeIcon: const Icon(Icons.block),
              label: "Blacklist",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardTab() {
    final approved = _db.allVisitors.where((v) => v.status == VisitorStatus.approved || v.status == VisitorStatus.checkedIn || v.status == VisitorStatus.checkedOut).length;
    final rejected = _db.allVisitors.where((v) => v.status == VisitorStatus.rejected).length;

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          // ─── Header ────────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xFF059669), Color(0xFF10B981)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(28), bottomRight: Radius.circular(28)),
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
                          const Text("Good Morning,", style: TextStyle(color: Colors.white70, fontSize: 14)),
                          const Text("Flat 402 — Resident", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
                          Text(_todayLabel(), style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12)),
                        ],
                      ),
                      Row(
                        children: [
                          Stack(
                            children: [
                              IconButton(icon: const Icon(Icons.notifications_outlined, color: Colors.white), onPressed: () {}),
                              if (_pending.isNotEmpty)
                                Positioned(
                                  right: 8, top: 8,
                                  child: Container(
                                    width: 18, height: 18,
                                    decoration: const BoxDecoration(color: AppTheme.danger, shape: BoxShape.circle),
                                    child: Center(child: Text("${_pending.length}", style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700))),
                                  ),
                                ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () => Navigator.of(context).popUntil((route) => route.isFirst),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
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
                      _buildStatChip("${_pending.length}", "Pending"),
                      const SizedBox(width: 12),
                      _buildStatChip("$approved", "Approved"),
                      const SizedBox(width: 12),
                      _buildStatChip("$rejected", "Rejected"),
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
                  // Pending Requests
                  Row(
                    children: [
                      const Text("Pending Approvals", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textDark)),
                      const SizedBox(width: 8),
                      if (_pending.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(color: AppTheme.danger, borderRadius: BorderRadius.circular(10)),
                          child: Text("${_pending.length}", style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  if (_pending.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
                      child: const Column(children: [
                        Icon(Icons.check_circle_outline, size: 48, color: AppTheme.accentEmerald),
                        SizedBox(height: 10),
                        Text("No pending requests", style: TextStyle(color: AppTheme.textMuted, fontWeight: FontWeight.w500, fontSize: 15)),
                        SizedBox(height: 4),
                        Text("You're all caught up!", style: TextStyle(color: AppTheme.textMuted, fontSize: 12)),
                      ]),
                    )
                  else
                    ..._pending.map((v) => _buildRequestCard(v)),

                  const SizedBox(height: 28),

                  // Recent visits preview
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Recent Activity", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textDark)),
                      TextButton(onPressed: () => setState(() => _selectedIndex = 1), child: const Text("View All", style: TextStyle(color: AppTheme.accentEmerald))),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ..._history.take(3).map((v) => _buildRecentCard(v)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(14)),
        child: Column(
          children: [
            Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 22)),
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestCard(Visitor v) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.warning.withOpacity(0.3)),
        boxShadow: [BoxShadow(color: AppTheme.warning.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppTheme.accentEmerald.withOpacity(0.1),
                child: Text(v.name[0], style: const TextStyle(color: AppTheme.accentEmerald, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(v.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppTheme.textDark)),
                    Text("${v.purpose}  •  ${v.timeLabel}", style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                    Text("📞 ${v.phone}", style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: AppTheme.warning.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                child: const Text("Pending", style: TextStyle(fontSize: 11, color: AppTheme.warning, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _reject(v),
                  icon: const Icon(Icons.close, size: 16),
                  label: const Text("REJECT"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.danger,
                    side: BorderSide(color: AppTheme.danger.withOpacity(0.5)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _approve(v),
                  icon: const Icon(Icons.check, size: 16),
                  label: const Text("APPROVE"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentEmerald,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentCard(Visitor v) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: v.status.color.withOpacity(0.1),
            child: Icon(
              v.status == VisitorStatus.checkedOut || v.status == VisitorStatus.approved || v.status == VisitorStatus.checkedIn
                  ? Icons.check_circle_outline
                  : Icons.cancel_outlined,
              color: v.status.color,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(v.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppTheme.textDark)),
                Text("${v.purpose}  •  ${v.dateLabel}", style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
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
    );
  }

  Widget _buildHistoryTab() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Visit History", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppTheme.textDark)),
            const SizedBox(height: 4),
            const Text("All visitor activity for Flat 402", style: TextStyle(color: AppTheme.textMuted)),
            const SizedBox(height: 20),
            _history.isEmpty
                ? const Center(child: Text("No history yet", style: TextStyle(color: AppTheme.textMuted)))
                : Expanded(child: ListView(children: _history.map((v) => _buildRecentCard(v)).toList())),
          ],
        ),
      ),
    );
  }

  static String _todayLabel() {
    final now = DateTime.now();
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${now.day} ${months[now.month - 1]} ${now.year}';
  }
}
