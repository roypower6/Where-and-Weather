import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

class AppInfoScreen extends StatelessWidget {
  const AppInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "App Information",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff62BFAD),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Expanded(
                child: ListView(
                  children: [
                    _buildInfoItem(
                      icon: UniconsLine.info_circle,
                      title: "버전",
                      subtitle: "1.0.0",
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
                  ],
                ),
              ),
            ],
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
            color: const Color(0xff2155CD),
            size: 30,
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.grey,
            ),
          ),
          onTap: onTap,
        ),
        if (showDivider)
          const Divider(
            height: 5,
            thickness: 1,
            color: Colors.grey,
          ),
      ],
    );
  }
}
