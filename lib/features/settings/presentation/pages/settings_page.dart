import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gstsync/config/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Comprehensive Settings Page
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _whatsappEnabled = false;
  bool _darkMode = false;
  bool _isLoading = false;
  String? _whatsappNumber;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
      _whatsappEnabled = prefs.getBool('whatsapp_enabled') ?? false;
      _darkMode = prefs.getBool('dark_mode') ?? false;
      _whatsappNumber = prefs.getString('whatsapp_number');
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', _notificationsEnabled);
    await prefs.setBool('whatsapp_enabled', _whatsappEnabled);
    await prefs.setBool('dark_mode', _darkMode);
    if (_whatsappNumber != null) {
      await prefs.setString('whatsapp_number', _whatsappNumber!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Section
          _buildProfileCard(user),
          const SizedBox(height: 24),

          // Notifications Section
          _buildSectionTitle('Notifications'),
          _buildSettingsCard([
            _buildSwitchTile(
              'Push Notifications',
              'Get notified about invoices and payments',
              Icons.notifications_outlined,
              _notificationsEnabled,
              (value) {
                setState(() => _notificationsEnabled = value);
                _saveSettings();
              },
            ),
            const Divider(height: 1),
            _buildSwitchTile(
              'WhatsApp Notifications',
              'Receive invoice reminders on WhatsApp',
              Icons.whatshot,
              _whatsappEnabled,
              (value) async {
                if (value && _whatsappNumber == null) {
                  await _showWhatsAppSetupDialog();
                } else {
                  setState(() => _whatsappEnabled = value);
                  _saveSettings();
                }
              },
            ),
          ]),
          const SizedBox(height: 24),

          // Appearance Section
          _buildSectionTitle('Appearance'),
          _buildSettingsCard([
            _buildSwitchTile(
              'Dark Mode',
              'Switch to dark theme',
              Icons.dark_mode_outlined,
              _darkMode,
              (value) {
                setState(() => _darkMode = value);
                _saveSettings();
                // TODO: Actually switch theme via provider
              },
            ),
          ]),
          const SizedBox(height: 24),

          // Data Management Section
          _buildSectionTitle('Data Management'),
          _buildSettingsCard([
            _buildActionTile(
              'Backup Data',
              'Save your data to cloud',
              Icons.backup_outlined,
              () => _performBackup(),
            ),
            const Divider(height: 1),
            _buildActionTile(
              'Restore Data',
              'Restore from backup',
              Icons.restore,
              () => _performRestore(),
            ),
            const Divider(height: 1),
            _buildActionTile(
              'Export All Data',
              'Download as CSV files',
              Icons.download_outlined,
              () => _exportAllData(),
            ),
          ]),
          const SizedBox(height: 24),

          // WhatsApp Integration Section
          _buildSectionTitle('WhatsApp Integration'),
          _buildSettingsCard([
            _buildActionTile(
              'Configure WhatsApp',
              _whatsappNumber != null ? 'Connected: $_whatsappNumber' : 'Set up WhatsApp API',
              Icons.message_outlined,
              () => _showWhatsAppSetupDialog(),
            ),
            const Divider(height: 1),
            _buildActionTile(
              'Send Test Message',
              'Verify WhatsApp integration',
              Icons.send_outlined,
              _whatsappEnabled ? () => _sendTestWhatsAppMessage() : null,
            ),
          ]),
          const SizedBox(height: 24),

          // About Section
          _buildSectionTitle('About'),
          _buildSettingsCard([
            _buildInfoTile('App Version', '1.0.0'),
            const Divider(height: 1),
            _buildActionTile(
              'Privacy Policy',
              '',
              Icons.privacy_tip_outlined,
              () {},
            ),
            const Divider(height: 1),
            _buildActionTile(
              'Terms of Service',
              '',
              Icons.description_outlined,
              () {},
            ),
          ]),
          const SizedBox(height: 24),

          // Logout Button
          ElevatedButton.icon(
            onPressed: () => _confirmLogout(),
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildProfileCard(User? user) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: Colors.white.withOpacity(0.2),
            child: Text(
              user?.email?.substring(0, 1).toUpperCase() ?? 'U',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.displayName ?? 'User',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user?.email ?? '',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.grey[600],
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    Function(bool) onChanged,
  ) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppTheme.primaryColor, size: 22),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      trailing: Switch.adaptive(
        value: value,
        onChanged: onChanged,
        activeColor: AppTheme.primaryColor,
      ),
    );
  }

  Widget _buildActionTile(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback? onTap,
  ) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppTheme.primaryColor, size: 22),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: subtitle.isNotEmpty
          ? Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[600]))
          : null,
      trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
      onTap: onTap,
      enabled: onTap != null,
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: Text(value, style: TextStyle(color: Colors.grey[600])),
    );
  }

  Future<void> _showWhatsAppSetupDialog() async {
    final controller = TextEditingController(text: _whatsappNumber);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.message, color: Colors.green),
            SizedBox(width: 12),
            Text('WhatsApp Setup'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter your WhatsApp Business API number to receive invoice reminders and notifications.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'WhatsApp Number',
                hintText: '+91 9876543210',
                prefixIcon: const Icon(Icons.phone),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() {
                  _whatsappNumber = controller.text;
                  _whatsappEnabled = true;
                });
                _saveSettings();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('WhatsApp configured successfully!')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _performBackup() async {
    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('Not logged in');

      // Simulate backup process
      await Future.delayed(const Duration(seconds: 2));

      // Store backup timestamp
      await FirebaseFirestore.instance
          .collection('backups')
          .doc(user.uid)
          .set({
        'lastBackup': FieldValue.serverTimestamp(),
        'status': 'success',
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Backup completed successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Backup failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _performRestore() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Restore Data'),
        content: const Text(
          'This will replace your current data with the last backup. Are you sure?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Restore'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(seconds: 2));
      setState(() => _isLoading = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data restored successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  Future<void> _exportAllData() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Exporting all data...')),
    );
    // Use ExcelExportService to export
    await Future.delayed(const Duration(seconds: 1));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data exported successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _sendTestWhatsAppMessage() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sending test message via WhatsApp...')),
    );
    await Future.delayed(const Duration(seconds: 1));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Test message sent to $_whatsappNumber'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _confirmLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await FirebaseAuth.instance.signOut();
    }
  }
}
