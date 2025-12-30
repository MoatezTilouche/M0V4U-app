import 'package:app_m0v4u/constants/styles.dart';
import 'package:app_m0v4u/shared/widgets/appbar/custom_navbar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/assets.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';

class GenerateRequestTokenScreen extends StatelessWidget {
  const GenerateRequestTokenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: AppStyles.secondaryColor,
      body: SafeArea(
        child: Center(
          child: auth.isLoading
              ? const CircularProgressIndicator()
              : Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Image.asset(Assets.appLogoIcon, height: 100, width: 100),
                const SizedBox(height: 30),

                const Text(
                  "Welcome to TMDB Login",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 20),

                const Text(
                  "To use features like watchlists and favorites, you’ll need to log in to your TMDB account.\n\nHere's how it works:",
                  style: TextStyle(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 20),

                _buildStep(1, "Generate a secure login token."),
                _buildStep(2, "You’ll be redirected to TMDB's website."),
                _buildStep(3, "Log in or sign up, then approve access."),
                _buildStep(4, "Return here and confirm login."),

                const SizedBox(height: 40),

                _buildGradientButton(context, auth),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStep(int number, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: Colors.blueAccent,
            child: Text(
              "$number",
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              description,
              style: const TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradientButton(BuildContext context, AuthProvider auth) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4CAF50), Color(0xFF2196F3)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        onPressed: () async {
          await auth.startLoginProcess(context);
          if (auth.requestToken != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LoginApprovalScreen()),
            );
          }
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.login, size: 20, color: Colors.white),
            SizedBox(width: 8),
            AutoSizeText(
              'Start Login Process',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}
