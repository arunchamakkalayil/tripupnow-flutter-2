import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/main/home'),
        ),
        title: const Text('Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final user = authProvider.user;
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Profile Info Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        const CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(
                            'https://cdn.jsdelivr.net/gh/arunchamakkalayil/places/avatar.png',
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          user?.name ?? 'User Name',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          user?.email ?? 'user@example.com',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildActionButton(
                              icon: Icons.bookmark_outline,
                              label: 'Saved',
                              color: Colors.pink,
                              onTap: () {
                                // TODO: Navigate to saved places
                              },
                            ),
                            _buildActionButton(
                              icon: Icons.share_outlined,
                              label: 'Share',
                              color: Colors.blue,
                              onTap: () {
                                // TODO: Share profile
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Settings Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Settings',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildSettingsItem(
                          icon: Icons.person_outline,
                          title: 'Account details',
                          onTap: () {
                            // TODO: Navigate to account details
                          },
                        ),
                        _buildSettingsItem(
                          icon: Icons.lock_outline,
                          title: 'Password and security',
                          onTap: () {
                            // TODO: Navigate to security settings
                          },
                        ),
                        Consumer<ThemeProvider>(
                          builder: (context, themeProvider, child) {
                            return _buildSettingsItem(
                              icon: themeProvider.isDarkMode 
                                  ? Icons.light_mode_outlined 
                                  : Icons.dark_mode_outlined,
                              title: 'Theme',
                              trailing: Switch(
                                value: themeProvider.isDarkMode,
                                onChanged: (_) => themeProvider.toggleTheme(),
                              ),
                              onTap: () => themeProvider.toggleTheme(),
                            );
                          },
                        ),
                        _buildSettingsItem(
                          icon: Icons.report_outlined,
                          title: 'Report a problem',
                          onTap: () {
                            // TODO: Navigate to report problem
                          },
                        ),
                        _buildSettingsItem(
                          icon: Icons.person_add_outlined,
                          title: 'Invite a friend',
                          onTap: () {
                            // TODO: Share app invitation
                          },
                        ),
                        _buildSettingsItem(
                          icon: Icons.system_update_outlined,
                          title: 'App updates',
                          onTap: () {
                            // TODO: Check for updates
                          },
                        ),
                        _buildSettingsItem(
                          icon: Icons.help_outline,
                          title: 'Help',
                          onTap: () {
                            // TODO: Navigate to help
                          },
                        ),
                        _buildSettingsItem(
                          icon: Icons.info_outline,
                          title: 'About',
                          onTap: () {
                            // TODO: Show about dialog
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Logout Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final shouldLogout = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Logout'),
                          content: const Text('Are you sure you want to logout?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text('Logout'),
                            ),
                          ],
                        ),
                      );
                      
                      if (shouldLogout == true && context.mounted) {
                        await authProvider.logout();
                        context.go('/login');
                      }
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('Logout'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }
}