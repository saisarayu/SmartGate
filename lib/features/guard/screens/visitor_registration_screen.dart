import 'package:flutter/material.dart';
import '../../../core/app_theme.dart';
import '../../../core/services/app_database.dart';

class VisitorRegistrationScreen extends StatefulWidget {
  final VoidCallback? onRegistered;
  const VisitorRegistrationScreen({super.key, this.onRegistered});

  @override
  State<VisitorRegistrationScreen> createState() => _VisitorRegistrationScreenState();
}

class _VisitorRegistrationScreenState extends State<VisitorRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _flatController = TextEditingController();
  String _selectedPurpose = "Guest";
  bool _selfieCaptured = false;
  bool _isSubmitting = false;

  final List<String> _purposes = ["Guest", "Delivery", "Repair", "Cab/Taxi", "Other"];
  final AppDatabase _db = AppDatabase.instance;

  void _capturePhoto() {
    setState(() => _selfieCaptured = true);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("📷 Selfie captured successfully"),
      backgroundColor: AppTheme.accentEmerald,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ));
  }

  void _submitRegistration() {
    if (!_formKey.currentState!.validate()) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final otpController = TextEditingController();
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text("OTP Verification", style: TextStyle(fontWeight: FontWeight.w700)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.accentEmerald.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.sms_outlined, color: AppTheme.accentEmerald, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text("OTP sent to ${_phoneController.text}",
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: otpController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 6,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, letterSpacing: 8),
                decoration: InputDecoration(
                  hintText: "------",
                  hintStyle: const TextStyle(letterSpacing: 8, color: AppTheme.textMuted),
                  counterText: "",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("CANCEL")),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // ✅ Write to the shared database
                _db.registerVisitor(
                  name: _nameController.text.trim(),
                  phone: _phoneController.text.trim(),
                  purpose: _selectedPurpose,
                  residentFlat: _flatController.text.trim(),
                  hasSelfie: _selfieCaptured,
                );
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("✅ ${_nameController.text} registered! Approval request sent to ${_flatController.text}."),
                  backgroundColor: AppTheme.accentEmerald,
                  duration: const Duration(seconds: 3),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ));
                _resetForm();
                widget.onRegistered?.call(); // Navigate back to dashboard tab
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentEmerald),
              child: const Text("VERIFY & REGISTER"),
            ),
          ],
        );
      },
    );
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _nameController.clear();
    _phoneController.clear();
    _flatController.clear();
    setState(() {
      _selectedPurpose = "Guest";
      _selfieCaptured = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surfaceLight,
      appBar: AppBar(title: const Text("Register Visitor"), automaticallyImplyLeading: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Selfie Section
              _buildSectionHeader(Icons.camera_alt_outlined, "Capture Selfie", AppTheme.accentEmerald),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: _selfieCaptured ? null : _capturePhoto,
                child: Container(
                  width: double.infinity,
                  height: 100,
                  decoration: BoxDecoration(
                    color: _selfieCaptured ? AppTheme.accentEmerald.withOpacity(0.08) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _selfieCaptured ? AppTheme.accentEmerald : Colors.grey.shade200,
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _selfieCaptured ? Icons.check_circle : Icons.add_a_photo_outlined,
                        size: 32,
                        color: _selfieCaptured ? AppTheme.accentEmerald : AppTheme.textMuted,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _selfieCaptured ? "Selfie Captured ✓" : "Tap to Capture Visitor Selfie",
                        style: TextStyle(
                          color: _selfieCaptured ? AppTheme.accentEmerald : AppTheme.textMuted,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),
              _buildSectionHeader(Icons.person_outline, "Visitor Info", AppTheme.primaryNavy),
              const SizedBox(height: 14),
              _buildLabel("Full Name"),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(hintText: "Visitor's full name", prefixIcon: Icon(Icons.person_outline, color: AppTheme.textMuted)),
                textCapitalization: TextCapitalization.words,
                validator: (v) => v == null || v.trim().isEmpty ? "Name is required" : null,
              ),
              const SizedBox(height: 14),
              _buildLabel("Phone Number"),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                decoration: const InputDecoration(hintText: "10-digit mobile number", prefixIcon: Icon(Icons.phone_android_outlined, color: AppTheme.textMuted), counterText: ""),
                validator: (v) => (v == null || v.trim().length != 10) ? "Enter valid 10-digit number" : null,
              ),
              const SizedBox(height: 14),
              _buildLabel("Purpose of Visit"),
              DropdownButtonFormField<String>(
                value: _selectedPurpose,
                decoration: const InputDecoration(prefixIcon: Icon(Icons.business_center_outlined, color: AppTheme.textMuted)),
                items: _purposes.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                onChanged: (v) => setState(() => _selectedPurpose = v!),
              ),

              const SizedBox(height: 22),
              _buildSectionHeader(Icons.home_outlined, "Meeting Resident", AppTheme.accentOrange),
              const SizedBox(height: 14),
              _buildLabel("Flat / House Number"),
              TextFormField(
                controller: _flatController,
                decoration: const InputDecoration(hintText: "e.g. Flat 402", prefixIcon: Icon(Icons.home_outlined, color: AppTheme.textMuted)),
                textCapitalization: TextCapitalization.words,
                validator: (v) => v == null || v.trim().isEmpty ? "Flat number is required" : null,
              ),

              const SizedBox(height: 28),
              ElevatedButton.icon(
                onPressed: _isSubmitting ? null : _submitRegistration,
                icon: const Icon(Icons.send_outlined),
                label: const Text("SEND OTP & REGISTER VISITOR"),
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryNavy),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: AppTheme.primaryNavy.withOpacity(0.05), borderRadius: BorderRadius.circular(12)),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: AppTheme.primaryNavy, size: 16),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "After OTP verification, the resident will receive an instant approval request notification.",
                        style: TextStyle(fontSize: 12, color: AppTheme.textMuted, height: 1.5),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 10),
        Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: color)),
      ],
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppTheme.textDark)),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _flatController.dispose();
    super.dispose();
  }
}
