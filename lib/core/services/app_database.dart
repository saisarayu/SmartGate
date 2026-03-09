import 'package:flutter/foundation.dart';
import '../models/visitor.dart';

/// Singleton in-memory database that all screens read from and write to.
/// In a real app, this would be replaced by an API service / SQLite / Firebase.
class AppDatabase extends ChangeNotifier {
  AppDatabase._internal();
  static final AppDatabase instance = AppDatabase._internal();

  // ─── Visitors ──────────────────────────────────────────────────────────────

  final List<Visitor> _visitors = [
    Visitor(
      id: 'v0001',
      name: 'Rajesh Kumar',
      phone: '9876543210',
      purpose: 'Guest',
      residentFlat: 'Flat 402',
      registrationTime: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
      status: VisitorStatus.pending,
    ),
    Visitor(
      id: 'v0002',
      name: 'Priya Sharma',
      phone: '8765432109',
      purpose: 'Delivery',
      residentFlat: 'Flat 101',
      registrationTime: DateTime.now().subtract(const Duration(hours: 2, minutes: 45)),
      status: VisitorStatus.checkedIn,
      checkInTime: DateTime.now().subtract(const Duration(hours: 2, minutes: 30)),
      hasSelfie: true,
    ),
    Visitor(
      id: 'v0003',
      name: 'Arun Verma',
      phone: '7654321098',
      purpose: 'Guest',
      residentFlat: 'Flat 205',
      registrationTime: DateTime.now().subtract(const Duration(hours: 3)),
      status: VisitorStatus.checkedOut,
      checkInTime: DateTime.now().subtract(const Duration(hours: 2, minutes: 50)),
      checkOutTime: DateTime.now().subtract(const Duration(hours: 1)),
      hasSelfie: true,
    ),
    Visitor(
      id: 'v0004',
      name: 'Meena Joshi',
      phone: '6543210987',
      purpose: 'Repair',
      residentFlat: 'Flat 310',
      registrationTime: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
      status: VisitorStatus.checkedOut,
      checkInTime: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
      checkOutTime: DateTime.now().subtract(const Duration(days: 1)),
      hasSelfie: true,
    ),
    Visitor(
      id: 'v0005',
      name: 'Suresh Nair',
      phone: '5432109876',
      purpose: 'Guest',
      residentFlat: 'Flat 501',
      registrationTime: DateTime.now().subtract(const Duration(days: 1, hours: 5)),
      status: VisitorStatus.rejected,
      hasSelfie: true,
    ),
    Visitor(
      id: 'v0006',
      name: 'Anita Roy',
      phone: '4321098765',
      purpose: 'Cab/Taxi',
      residentFlat: 'Flat 102',
      registrationTime: DateTime.now().subtract(const Duration(days: 2, hours: 3)),
      status: VisitorStatus.checkedOut,
      checkInTime: DateTime.now().subtract(const Duration(days: 2, hours: 3)),
      checkOutTime: DateTime.now().subtract(const Duration(days: 2, hours: 2, minutes: 40)),
      hasSelfie: false,
    ),
  ];

  // ─── Blacklist ──────────────────────────────────────────────────────────────

  final List<Map<String, String>> _blacklist = [
    {"name": "Mark Unknown", "reason": "Suspicious behavior", "date": "10 Feb 2026"},
  ];

  // ─── Getters ────────────────────────────────────────────────────────────────

  List<Visitor> get allVisitors => List.unmodifiable(_visitors);

  List<Visitor> get pendingVisitors =>
      _visitors.where((v) => v.status == VisitorStatus.pending).toList();

  List<Visitor> get insideVisitors =>
      _visitors.where((v) => v.status == VisitorStatus.checkedIn).toList();

  List<Visitor> get todayVisitors {
    final now = DateTime.now();
    return _visitors.where((v) {
      return v.registrationTime.year == now.year &&
          v.registrationTime.month == now.month &&
          v.registrationTime.day == now.day;
    }).toList();
  }

  List<Map<String, String>> get blacklist => List.unmodifiable(_blacklist);

  // ─── Visitor Actions ────────────────────────────────────────────────────────

  /// Guard registers a new visitor → creates with Pending status
  Visitor registerVisitor({
    required String name,
    required String phone,
    required String purpose,
    required String residentFlat,
    bool hasSelfie = false,
  }) {
    final id = 'v${DateTime.now().millisecondsSinceEpoch}';
    final visitor = Visitor(
      id: id,
      name: name,
      phone: phone,
      purpose: purpose,
      residentFlat: residentFlat,
      registrationTime: DateTime.now(),
      status: VisitorStatus.pending,
      hasSelfie: hasSelfie,
    );
    _visitors.insert(0, visitor);
    notifyListeners();
    return visitor;
  }

  /// Resident approves a visitor request → status becomes Approved
  void approveVisitor(String visitorId) {
    final v = _findById(visitorId);
    if (v != null) {
      v.status = VisitorStatus.approved;
      notifyListeners();
    }
  }

  /// Resident rejects a visitor request → status becomes Rejected
  void rejectVisitor(String visitorId) {
    final v = _findById(visitorId);
    if (v != null) {
      v.status = VisitorStatus.rejected;
      notifyListeners();
    }
  }

  /// Guard checks in an approved visitor → status becomes CheckedIn
  void checkInVisitor(String visitorId) {
    final v = _findById(visitorId);
    if (v != null && v.status == VisitorStatus.approved) {
      v.status = VisitorStatus.checkedIn;
      v.checkInTime = DateTime.now();
      notifyListeners();
    }
  }

  /// Guard checks out a visitor who is inside → status becomes CheckedOut
  void checkOutVisitor(String visitorId) {
    final v = _findById(visitorId);
    if (v != null && v.status == VisitorStatus.checkedIn) {
      v.status = VisitorStatus.checkedOut;
      v.checkOutTime = DateTime.now();
      notifyListeners();
    }
  }

  // ─── Blacklist Actions ──────────────────────────────────────────────────────

  void addToBlacklist({required String name, required String reason}) {
    _blacklist.add({"name": name, "reason": reason, "date": _todayLabel()});
    notifyListeners();
  }

  void removeFromBlacklist(int index) {
    _blacklist.removeAt(index);
    notifyListeners();
  }

  // ─── Helpers ────────────────────────────────────────────────────────────────

  Visitor? _findById(String id) {
    try {
      return _visitors.firstWhere((v) => v.id == id);
    } catch (_) {
      return null;
    }
  }

  static String _todayLabel() {
    final now = DateTime.now();
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${now.day} ${months[now.month - 1]} ${now.year}';
  }
}
