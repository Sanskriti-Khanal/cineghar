import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final size = MediaQuery.of(context).size;
    final bool isTablet = size.width > 600;

    return Stack(
      children: [
        // Top background (red / cinema feel)
        Container(
          height: size.height * 0.28,
          decoration: const BoxDecoration(
            color: Color(0xFF4A0000),
            image: DecorationImage(
              image: AssetImage('assets/images/background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            color: Colors.black.withOpacity(0.4),
          ),
        ),

        // Main white card content
        SafeArea(
          child: Column(
            children: [
              // CineGhar heading at the top, using your app logo
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      width: 40,
                      height: 40,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'CineGhar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // White rounded container
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: isTablet ? 32 : 24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Profile avatar with edit button
                        SizedBox(
                          height: 120,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              const CircleAvatar(
                                radius: 48,
                                backgroundImage: NetworkImage(
                                  'https://images.pexels.com/photos/614810/pexels-photo-614810.jpeg',
                                ),
                              ),
                              Positioned(
                                bottom: 18,
                                right: size.width * 0.32,
                                child: Container(
                                  width: 26,
                                  height: 26,
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.edit,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Hari Shrestha',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'hari@gmail.com',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),

                        const SizedBox(height: 24),
                        const Divider(height: 1),
                        const SizedBox(height: 8),

                        // Menu items
                        const _ProfileMenuItem(
                          icon: Icons.confirmation_number_outlined,
                          label: 'My Tickets',
                        ),
                        const _ProfileMenuItem(
                          icon: Icons.settings_outlined,
                          label: 'Settings',
                        ),
                        const _ProfileMenuItem(
                          icon: Icons.lock_outline,
                          label: 'Privacy & security',
                        ),
                        const _ProfileMenuItem(
                          icon: Icons.account_balance_wallet_outlined,
                          label: 'Loyalty Points',
                        ),

                        const SizedBox(height: 24),

                        // Logout
                        Align(
                          alignment: Alignment.centerLeft,
                          child: InkWell(
                            onTap: () {
                              // TODO: Implement logout navigation
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(
                                  Icons.logout,
                                  color: Colors.red,
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Logout',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ProfileMenuItem({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: Icon(
        icon,
        color: Colors.black87,
      ),
      title: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: Colors.black38,
      ),
      onTap: () {
        // TODO: hook up navigation for each item
      },
    );
  }
}
