import 'package:flutter/material.dart';
import '../app_theme.dart';

enum VisitorStatus { pending, approved, rejected, checkedIn, checkedOut }

extension VisitorStatusExt on VisitorStatus {
  String get label {
    switch (this) {
      case VisitorStatus.pending: return 'Pending';
      case VisitorStatus.approved: return 'Approved';
      case VisitorStatus.rejected: return 'Rejected';
      case VisitorStatus.checkedIn: return 'Checked In';
      case VisitorStatus.checkedOut: return 'Checked Out';
    }
  }

  Color get color {
    switch (this) {
      case VisitorStatus.pending: return AppTheme.warning;
      case VisitorStatus.approved: return AppTheme.accentEmerald;
      case VisitorStatus.rejected: return AppTheme.danger;
      case VisitorStatus.checkedIn: return AppTheme.accentEmerald;
      case VisitorStatus.checkedOut: return AppTheme.textMuted;
    }
  }
}

class Visitor {
  final String id;
  final String name;
  final String phone;
  final String purpose;
  final String residentFlat;
  final DateTime registrationTime;
  DateTime? checkInTime;
  DateTime? checkOutTime;
  VisitorStatus status;
  bool hasSelfie;

  Visitor({
    required this.id,
    required this.name,
    required this.phone,
    required this.purpose,
    required this.residentFlat,
    required this.registrationTime,
    this.status = VisitorStatus.pending,
    this.checkInTime,
    this.checkOutTime,
    this.hasSelfie = false,
  });

  /// For display: "9 Mar 2026"
  String get dateLabel {
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${registrationTime.day} ${months[registrationTime.month - 1]} ${registrationTime.year}';
  }

  /// For display: "10:30 AM"
  String get timeLabel => _formatTime(registrationTime);
  String get checkInLabel => checkInTime != null ? _formatTime(checkInTime!) : '-';
  String get checkOutLabel => checkOutTime != null ? _formatTime(checkOutTime!) : '-';

  static String _formatTime(DateTime dt) {
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final min = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour < 12 ? 'AM' : 'PM';
    return '$hour:$min $ampm';
  }

  /// Unique visitor pass ID
  String get passId => 'SG-${id.substring(id.length - 4).toUpperCase()}';
}
