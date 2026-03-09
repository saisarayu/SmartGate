import 'package:flutter/material.dart';
import '../../../core/app_theme.dart';
import '../../guard/screens/guard_dashboard.dart';
import '../../resident/screens/resident_dashboard.dart';
import '../../visitor/screens/visitor_entry_screen.dart';

class LoginScreen extends StatefulWidget {
  final String role; // 'guard', 'resident', 'visitor'
  const LoginScreen({super.key, required this.role});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _passController = TextEditingController();
  bool _obscurePass = true;

  String get _roleTitle {
    switch (widget.role) {
      case 'guard': return 'Security Guard';
      case 'resident': return 'Resident';
      default: return 'Visitor';
    }
  }

  Color get _roleColor {
    switch (widget.role) {
      case 'guard': return AppTheme.primaryNavy;
      case 'resident': return AppTheme.accentEmerald;
      default: return AppTheme.accentOrange;
    }
  }

  IconData get _roleIcon {
    switch (widget.role) {
      case 'guard': return Icons.local_police_outlined;
      case 'resident': return Icons.home_work_outlined;
      default: return Icons.qr_code_2;
    }
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      Widget dest;
      if (widget.role == 'guard') {
        dest = const GuardDashboard();
      } else if (widget.role == 'resident') {
        dest = const ResidentDashboard();
      } else {
        dest = const VisitorEntryScreen();
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => dest),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surfaceLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.textDark),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                // Role Badge
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: _roleColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(_roleIcon, color: _roleColor, size: 36),
                ),
                const SizedBox(height: 20),
                Text(
                  "Sign in as",
                  style: TextStyle(fontSize: 16, color: AppTheme.textMuted),
                ),
                Text(
                  _roleTitle,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: _roleColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Enter your credentials to access the Smart Gate system.",
                  style: const TextStyle(fontSize: 14, color: AppTheme.textMuted, height: 1.5),
                ),
                const SizedBox(height: 36),

                // ID Field
                const Text(
                  "Employee / Resident ID",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppTheme.textDark),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _idController,
                  decoration: InputDecoration(
                    hintText: "e.g. SG-001 or RES-402",
                    prefixIcon: Icon(Icons.badge_outlined, color: _roleColor),
                  ),
                  validator: (v) => v == null || v.isEmpty ? "ID is required" : null,
                ),
                const SizedBox(height: 20),

                // Password Field
                const Text(
                  "Password",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppTheme.textDark),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _passController,
                  obscureText: _obscurePass,
                  decoration: InputDecoration(
                    hintText: "Enter your password",
                    prefixIcon: Icon(Icons.lock_outline, color: _roleColor),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePass ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: AppTheme.textMuted,
                      ),
                      onPressed: () => setState(() => _obscurePass = !_obscurePass),
                    ),
                  ),
                  validator: (v) => v == null || v.isEmpty ? "Password is required" : null,
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text("Forgot Password?", style: TextStyle(color: _roleColor)),
                  ),
                ),
                const SizedBox(height: 24),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(backgroundColor: _roleColor),
                    child: const Text("SIGN IN"),
                  ),
                ),
                const SizedBox(height: 24),

                // Info Note
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: _roleColor.withOpacity(0.07),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _roleColor.withOpacity(0.15)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: _roleColor, size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          widget.role == 'visitor'
                              ? "Visitors: Enter your registered phone number as ID."
                              : "Use credentials provided by your society admin.",
                          style: TextStyle(fontSize: 13, color: _roleColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _idController.dispose();
    _passController.dispose();
    super.dispose();
  }
}
