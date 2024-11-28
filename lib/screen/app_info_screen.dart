import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

class AppInfoScreen extends StatelessWidget {
  const AppInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2196F3), Color(0xFF64B5F6)],
        ),
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "앱 정보",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListView(
                      children: [
                        _buildInfoItem(
                          icon: UniconsLine.info_circle,
                          title: "버전",
                          subtitle: "2.0.2",
                        ),
                        _buildInfoItem(
                          icon: Icons.person_outline,
                          title: "개발자",
                          subtitle: "Rhee Seung-gi",
                        ),
                        _buildInfoItem(
                          icon: UniconsLine.github,
                          title: "Github ID",
                          subtitle: "roypower6",
                        ),
                        _buildInfoItem(
                          icon: Icons.email_outlined,
                          title: "문의하기",
                          subtitle: "roy040707@gmail.com",
                        ),
                        _buildInfoItem(
                          icon: Icons.api_rounded,
                          title: "Powered by",
                          subtitle: "OpenWeatherMap API",
                          showDivider: false,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required String subtitle,
    bool showDivider = true,
    VoidCallback? onTap,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(
            icon,
            color: Colors.white,
            size: 30,
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              fontSize: 15,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          onTap: onTap,
        ),
        if (showDivider)
          Divider(
            height: 5,
            thickness: 1,
            color: Colors.white.withOpacity(0.3),
          ),
      ],
    );
  }
}
