import 'package:flutter/material.dart';
import '../../../core/app_theme.dart';
import 'login_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surfaceLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              // Header
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryNavy,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.security, color: Colors.white, size: 26),
                  ),
                  const SizedBox(width: 14),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Smart Gate",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.primaryNavy,
                        ),
                      ),
                      Text(
                        "Digital Visitor Management",
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.textMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Banner Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.primaryNavy, Color(0xFF2D4A80)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Welcome! 👋",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Select your role to access the\nsystem securely.",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        _buildBadge(Icons.shield_outlined, "Secure"),
                        const SizedBox(width: 12),
                        _buildBadge(Icons.qr_code_scanner, "QR Enabled"),
                        const SizedBox(width: 12),
                        _buildBadge(Icons.notifications_outlined, "Real-time"),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 36),

              const Text(
                "Choose Your Role",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 16),

              // Role Cards
              _buildRoleCard(
                context,
                title: "Security Guard",
                subtitle: "Register visitors, verify OTPs\nand manage entry/exit",
                icon: Icons.local_police_outlined,
                gradient: [const Color(0xFF1A2A4A), const Color(0xFF2D4A80)],
                features: ["Approve Entry", "Check-In & Out", "Alerts & Blacklist"],
                role: "guard",
              ),
              const SizedBox(height: 16),
              _buildRoleCard(
                context,
                title: "Resident",
                subtitle: "Approve visitor requests and\nreceive instant notifications",
                icon: Icons.home_work_outlined,
                gradient: [const Color(0xFF059669), const Color(0xFF10B981)],
                features: ["Receive Requests", "Approve/Reject", "Visitor History"],
                role: "resident",
              ),
              const SizedBox(height: 16),
              _buildRoleCard(
                context,
                title: "Visitor",
                subtitle: "Enter details, get OTP verified\nand receive your digital pass",
                icon: Icons.qr_code_2,
                gradient: [const Color(0xFFD97706), const Color(0xFFF59E0B)],
                features: ["Enter Details", "OTP Verify", "Get QR Pass"],
                role: "visitor",
              ),

              const SizedBox(height: 32),
              const Center(
                child: Text(
                  "Smart Gate v1.0 • Secure & Smart",
                  style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 14),
          const SizedBox(width: 5),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildRoleCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Color> gradient,
    required List<String> features,
    required String role,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(role: role),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: gradient[0].withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: gradient),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: Colors.white, size: 30),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 13, color: AppTheme.textMuted, height: 1.4),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: features.map((f) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: gradient[0].withOpacity(0.08),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          f,
                          style: TextStyle(fontSize: 11, color: gradient[0], fontWeight: FontWeight.w600),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 15, color: Colors.grey.shade300),
          ],
        ),
      ),
    );
  }
}
