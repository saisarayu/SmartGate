import 'package:flutter/material.dart';
import '../../../core/app_theme.dart';
import 'visitor_pass_screen.dart';

class VisitorSelfieScreen extends StatefulWidget {
  final String name;
  final String phone;
  final String flat;
  final String purpose;

  const VisitorSelfieScreen({
    super.key,
    required this.name,
    required this.phone,
    required this.flat,
    required this.purpose,
  });

  @override
  State<VisitorSelfieScreen> createState() => _VisitorSelfieScreenState();
}

class _VisitorSelfieScreenState extends State<VisitorSelfieScreen> {
  bool _selfieCaptured = false;

  void _captureSelfie() {
    setState(() => _selfieCaptured = true);
  }

  void _proceed() {
    if (!_selfieCaptured) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Please capture your selfie first"),
          backgroundColor: AppTheme.danger,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VisitorPassScreen(
          name: widget.name,
          phone: widget.phone,
          flat: widget.flat,
          purpose: widget.purpose,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surfaceLight,
      appBar: AppBar(
        title: const Text("Capture Selfie"),
        backgroundColor: AppTheme.accentOrange,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStepIndicator(3),
            const SizedBox(height: 32),

            const Text("Capture Your Selfie",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppTheme.textDark)),
            const SizedBox(height: 6),
            const Text("Your photo will be attached to the visitor pass for identity verification.",
                style: TextStyle(color: AppTheme.textMuted, height: 1.5, fontSize: 14)),
            const SizedBox(height: 32),

            // Camera Viewfinder
            Center(
              child: GestureDetector(
                onTap: _selfieCaptured ? null : _captureSelfie,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _selfieCaptured ? AppTheme.accentEmerald.withOpacity(0.1) : Colors.white,
                    border: Border.all(
                      color: _selfieCaptured ? AppTheme.accentEmerald : AppTheme.accentOrange,
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (_selfieCaptured ? AppTheme.accentEmerald : AppTheme.accentOrange).withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _selfieCaptured ? Icons.check_circle : Icons.camera_alt_outlined,
                        size: 60,
                        color: _selfieCaptured ? AppTheme.accentEmerald : AppTheme.accentOrange,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _selfieCaptured ? "✓ Selfie Captured" : "Tap to\nCapture",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _selfieCaptured ? AppTheme.accentEmerald : AppTheme.accentOrange,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            if (!_selfieCaptured)
              Center(
                child: ElevatedButton.icon(
                  onPressed: _captureSelfie,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text("OPEN CAMERA"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentOrange,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  ),
                ),
              )
            else
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppTheme.accentEmerald.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.check_circle, color: AppTheme.accentEmerald, size: 20),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text("Selfie captured successfully! Proceed to get your visitor pass.",
                              style: TextStyle(fontSize: 13, color: AppTheme.textMuted)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _proceed,
                    icon: const Icon(Icons.qr_code),
                    label: const Text("GET MY VISITOR PASS"),
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentEmerald),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => setState(() => _selfieCaptured = false),
                    child: const Text("Retake Photo", style: TextStyle(color: AppTheme.accentOrange)),
                  ),
                ],
              ),
          ],
        ),
      ),
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
                      backgroundColor: isDone ? AppTheme.accentEmerald : isActive ? AppTheme.accentOrange : Colors.grey.shade200,
                      child: isDone
                          ? const Icon(Icons.check, color: Colors.white, size: 14)
                          : Text("${i + 1}",
                              style: TextStyle(color: isActive ? Colors.white : AppTheme.textMuted, fontSize: 12, fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(height: 4),
                    Text(steps[i],
                        style: TextStyle(
                          fontSize: 10,
                          color: isActive ? AppTheme.accentOrange : AppTheme.textMuted,
                          fontWeight: isActive ? FontWeight.w700 : FontWeight.normal,
                        )),
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
}
