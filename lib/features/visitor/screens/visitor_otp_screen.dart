import 'package:flutter/material.dart';
import '../../../core/app_theme.dart';
import 'visitor_selfie_screen.dart';

class VisitorOtpScreen extends StatefulWidget {
  final String name;
  final String phone;
  final String flat;
  final String purpose;

  const VisitorOtpScreen({
    super.key,
    required this.name,
    required this.phone,
    required this.flat,
    required this.purpose,
  });

  @override
  State<VisitorOtpScreen> createState() => _VisitorOtpScreenState();
}

class _VisitorOtpScreenState extends State<VisitorOtpScreen> {
  final List<TextEditingController> _otpControllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  bool _isVerifying = false;
  int _resendSeconds = 30;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  void _startResendTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _resendSeconds > 0) {
        setState(() => _resendSeconds--);
        _startResendTimer();
      }
    });
  }

  String get _otp => _otpControllers.map((c) => c.text).join();

  void _verifyOtp() {
    if (_otp.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter the complete 6-digit OTP"), backgroundColor: AppTheme.danger),
      );
      return;
    }

    setState(() => _isVerifying = true);

    // Simulate OTP verification
    Future.delayed(const Duration(seconds: 1), () {
      setState(() => _isVerifying = false);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VisitorSelfieScreen(
            name: widget.name,
            phone: widget.phone,
            flat: widget.flat,
            purpose: widget.purpose,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surfaceLight,
      appBar: AppBar(
        title: const Text("OTP Verification"),
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
            _buildStepIndicator(2),
            const SizedBox(height: 32),

            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFD97706), Color(0xFFF59E0B)],
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  const Icon(Icons.sms_outlined, color: Colors.white, size: 40),
                  const SizedBox(height: 12),
                  const Text("OTP Sent!", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  Text(
                    "We sent a 6-digit code to\n+91 ${widget.phone}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            const Text("Enter OTP",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textDark)),
            const SizedBox(height: 16),

            // OTP Input
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (i) {
                return SizedBox(
                  width: 46,
                  child: TextField(
                    controller: _otpControllers[i],
                    focusNode: _focusNodes[i],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppTheme.textDark),
                    decoration: InputDecoration(
                      counterText: "",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppTheme.accentOrange, width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onChanged: (v) {
                      if (v.isNotEmpty && i < 5) {
                        _focusNodes[i + 1].requestFocus();
                      } else if (v.isEmpty && i > 0) {
                        _focusNodes[i - 1].requestFocus();
                      }
                      setState(() {});
                    },
                  ),
                );
              }),
            ),

            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: _isVerifying ? null : _verifyOtp,
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentOrange),
              child: _isVerifying
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text("VERIFY OTP"),
            ),

            const SizedBox(height: 16),

            Center(
              child: _resendSeconds > 0
                  ? Text(
                      "Resend OTP in ${_resendSeconds}s",
                      style: const TextStyle(color: AppTheme.textMuted),
                    )
                  : TextButton(
                      onPressed: () {
                        setState(() => _resendSeconds = 30);
                        _startResendTimer();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("OTP resent"), backgroundColor: AppTheme.accentOrange),
                        );
                      },
                      child: const Text("Resend OTP", style: TextStyle(color: AppTheme.accentOrange, fontWeight: FontWeight.w700)),
                    ),
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

  @override
  void dispose() {
    for (final c in _otpControllers) c.dispose();
    for (final f in _focusNodes) f.dispose();
    super.dispose();
  }
}
