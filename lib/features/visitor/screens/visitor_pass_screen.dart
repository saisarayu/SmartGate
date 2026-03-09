import 'package:flutter/material.dart';
import '../../../core/app_theme.dart';

class VisitorPassScreen extends StatelessWidget {
  final String name;
  final String phone;
  final String flat;
  final String purpose;

  const VisitorPassScreen({
    super.key,
    this.name = "John Doe",
    this.phone = "98765-43210",
    this.flat = "402",
    this.purpose = "Guest",
  });

  @override
  Widget build(BuildContext context) {
    final visitorId = "SG-${DateTime.now().millisecondsSinceEpoch % 10000}";
    final date = "9 Mar 2026";

    return Scaffold(
      backgroundColor: AppTheme.primaryNavy,
      appBar: AppBar(
        title: const Text("Digital Visitor Pass"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.share_outlined, color: Colors.white), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Step 4 complete banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                decoration: BoxDecoration(
                  color: AppTheme.accentEmerald.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, color: AppTheme.accentEmerald, size: 18),
                    SizedBox(width: 8),
                    Text("Verification Complete! Your pass is ready.",
                        style: TextStyle(color: AppTheme.accentEmerald, fontWeight: FontWeight.w700, fontSize: 13)),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Pass Card
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 30, offset: const Offset(0, 15)),
                  ],
                ),
                child: Column(
                  children: [
                    // Card Header
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppTheme.primaryNavy, Color(0xFF2D4A80)],
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(28),
                          topRight: Radius.circular(28),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.security, color: Colors.white, size: 22),
                          const SizedBox(width: 10),
                          const Text("SMART GATE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, letterSpacing: 2)),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.accentEmerald.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text("VALID PASS",
                                style: TextStyle(color: AppTheme.accentEmerald, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1)),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          // Visitor Photo placeholder
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppTheme.primaryNavy.withOpacity(0.1),
                              border: Border.all(color: AppTheme.primaryNavy.withOpacity(0.2), width: 3),
                            ),
                            child: const Icon(Icons.person, size: 40, color: AppTheme.primaryNavy),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            name,
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppTheme.textDark),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "ID: $visitorId",
                            style: const TextStyle(color: AppTheme.textMuted, fontSize: 13),
                          ),

                          const SizedBox(height: 24),

                          // QR Code
                          Container(
                            width: 180,
                            height: 180,
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceLight,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                const Icon(Icons.qr_code_2, size: 160, color: AppTheme.primaryNavy),
                                // Corner decorations
                                Positioned(top: 8, left: 8,
                                    child: Container(width: 20, height: 20,
                                        decoration: BoxDecoration(border: Border(top: const BorderSide(color: AppTheme.accentEmerald, width: 3), left: const BorderSide(color: AppTheme.accentEmerald, width: 3))))),
                                Positioned(top: 8, right: 8,
                                    child: Container(width: 20, height: 20,
                                        decoration: BoxDecoration(border: Border(top: const BorderSide(color: AppTheme.accentEmerald, width: 3), right: const BorderSide(color: AppTheme.accentEmerald, width: 3))))),
                                Positioned(bottom: 8, left: 8,
                                    child: Container(width: 20, height: 20,
                                        decoration: BoxDecoration(border: Border(bottom: const BorderSide(color: AppTheme.accentEmerald, width: 3), left: const BorderSide(color: AppTheme.accentEmerald, width: 3))))),
                                Positioned(bottom: 8, right: 8,
                                    child: Container(width: 20, height: 20,
                                        decoration: BoxDecoration(border: Border(bottom: const BorderSide(color: AppTheme.accentEmerald, width: 3), right: const BorderSide(color: AppTheme.accentEmerald, width: 3))))),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),
                          const Divider(color: Color(0xFFF0F0F0)),
                          const SizedBox(height: 16),

                          // Details Grid
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildDetail("VISITING", flat),
                              _buildDetail("DATE", date),
                              _buildDetail("PURPOSE", purpose),
                              _buildDetail("PHONE", phone.length > 6 ? "${phone.substring(0, 5)}..." : phone),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Validity Badge
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                            decoration: BoxDecoration(
                              color: AppTheme.accentEmerald.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppTheme.accentEmerald.withOpacity(0.2)),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.timer_outlined, color: AppTheme.accentEmerald, size: 16),
                                SizedBox(width: 6),
                                Text("Valid for 4 hours • One-time use",
                                    style: TextStyle(color: AppTheme.accentEmerald, fontSize: 12, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                "Show this QR code to the Security Guard at the gate for instant entry.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white60, fontSize: 14, height: 1.5),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                  icon: const Icon(Icons.home_outlined, color: Colors.white70),
                  label: const Text("BACK TO HOME", style: TextStyle(color: Colors.white70)),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.white.withOpacity(0.3)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetail(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: AppTheme.textMuted, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppTheme.textDark)),
      ],
    );
  }
}
