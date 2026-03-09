import 'package:flutter/material.dart';
import '../../../core/app_theme.dart';
import 'visitor_otp_screen.dart';

class VisitorEntryScreen extends StatefulWidget {
  const VisitorEntryScreen({super.key});

  @override
  State<VisitorEntryScreen> createState() => _VisitorEntryScreenState();
}

class _VisitorEntryScreenState extends State<VisitorEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _flatController = TextEditingController();
  String _selectedPurpose = "Guest";
  final List<String> _purposes = ["Guest", "Delivery", "Repair", "Cab/Taxi", "Other"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surfaceLight,
      appBar: AppBar(
        title: const Text("Visitor Entry"),
        backgroundColor: AppTheme.accentOrange,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Step progress
              _buildStepIndicator(1),
              const SizedBox(height: 24),

              // Header
              const Text(
                "Enter Your Details",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppTheme.textDark),
              ),
              const SizedBox(height: 6),
              const Text(
                "Fill in your information to begin the entry process.",
                style: TextStyle(color: AppTheme.textMuted, height: 1.5, fontSize: 14),
              ),
              const SizedBox(height: 28),

              _buildLabel("Full Name"),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: "Your full name",
                  prefixIcon: Icon(Icons.person_outline, color: AppTheme.accentOrange),
                ),
                validator: (v) => v == null || v.isEmpty ? "Name is required" : null,
              ),
              const SizedBox(height: 16),

              _buildLabel("Mobile Number"),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                decoration: const InputDecoration(
                  hintText: "10-digit mobile number",
                  prefixIcon: Icon(Icons.phone_android_outlined, color: AppTheme.accentOrange),
                  counterText: "",
                ),
                validator: (v) => (v == null || v.length != 10) ? "Enter valid 10-digit number" : null,
              ),
              const SizedBox(height: 16),

              _buildLabel("Visiting Flat / House"),
              TextFormField(
                controller: _flatController,
                decoration: const InputDecoration(
                  hintText: "e.g. Flat 402, B-Block",
                  prefixIcon: Icon(Icons.home_outlined, color: AppTheme.accentOrange),
                ),
                validator: (v) => v == null || v.isEmpty ? "Flat number is required" : null,
              ),
              const SizedBox(height: 16),

              _buildLabel("Purpose of Visit"),
              DropdownButtonFormField<String>(
                value: _selectedPurpose,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.business_center_outlined, color: AppTheme.accentOrange),
                ),
                items: _purposes.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                onChanged: (v) => setState(() => _selectedPurpose = v!),
              ),
              const SizedBox(height: 32),

              ElevatedButton.icon(
                onPressed: _proceed,
                icon: const Icon(Icons.arrow_forward),
                label: const Text("PROCEED TO OTP VERIFICATION"),
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentOrange),
              ),

              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.accentOrange.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: AppTheme.accentOrange, size: 16),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "An OTP will be sent to your mobile number for verification before entry.",
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

  void _proceed() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VisitorOtpScreen(
            name: _nameController.text,
            phone: _phoneController.text,
            flat: _flatController.text,
            purpose: _selectedPurpose,
          ),
        ),
      );
    }
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppTheme.textDark)),
    );
  }

  Widget _buildStepIndicator(int current) {
    const steps = ["Details", "OTP", "Selfie", "QR Pass"];
    return Row(
      children: List.generate(steps.length, (i) {
        final isActive = i + 1 == current;
        final isDone = i + 1 < current;
        return Expanded(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: isDone
                          ? AppTheme.accentEmerald
                          : isActive
                              ? AppTheme.accentOrange
                              : Colors.grey.shade200,
                      child: isDone
                          ? const Icon(Icons.check, color: Colors.white, size: 14)
                          : Text(
                              "${i + 1}",
                              style: TextStyle(
                                color: isActive ? Colors.white : AppTheme.textMuted,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      steps[i],
                      style: TextStyle(
                        fontSize: 10,
                        color: isActive ? AppTheme.accentOrange : AppTheme.textMuted,
                        fontWeight: isActive ? FontWeight.w700 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              if (i < steps.length - 1)
                Expanded(
                  child: Container(
                    height: 2,
                    color: isDone ? AppTheme.accentEmerald : Colors.grey.shade200,
                    margin: const EdgeInsets.only(bottom: 16),
                  ),
                ),
            ],
          ),
        );
      }),
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
