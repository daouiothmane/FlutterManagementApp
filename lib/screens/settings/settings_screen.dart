import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/language_provider.dart';
import '../../constants/translations.dart';
import '../../constants/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  String _selectedCurrency = 'USD';

  final Map<String, String> _languages = {
    'en': 'English',
    'es': 'Spanish',
    'fr': 'French',
    'de': 'German',
  };

  final List<String> _currencies = ['USD', 'EUR', 'GBP', 'JPY'];

  String _getTranslatedText(String key) {
    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    return Translations.translate(
        key, languageProvider.currentLocale.languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTranslatedText('settings')),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          // Profile Section
          _buildSection(
            context,
            _getTranslatedText('profile'),
            [
              _buildListTile(
                context,
                icon: Icons.person_outline,
                title: _getTranslatedText('edit_profile'),
                onTap: () {
                  // TODO: Implement edit profile
                },
              ),
              _buildListTile(
                context,
                icon: Icons.lock_outline,
                title: _getTranslatedText('change_password'),
                onTap: () {
                  // TODO: Implement change password
                },
              ),
            ],
          ),
          // Appearance Section
          _buildSection(
            context,
            _getTranslatedText('appearance'),
            [
              Consumer<ThemeProvider>(
                builder: (context, themeProvider, child) {
                  return SwitchListTile(
                    secondary: const Icon(Icons.dark_mode_outlined),
                    title: Text(_getTranslatedText('dark_mode')),
                    value: themeProvider.isDarkMode,
                    onChanged: (bool value) {
                      themeProvider.toggleTheme();
                    },
                  );
                },
              ),
              _buildListTile(
                context,
                icon: Icons.palette_outlined,
                title: _getTranslatedText('theme_color'),
                onTap: () {
                  // TODO: Implement theme color selection
                },
              ),
            ],
          ),
          // Language Section
          _buildSection(
            context,
            _getTranslatedText('language_region'),
            [
              _buildListTile(
                context,
                icon: Icons.language,
                title: _getTranslatedText('language'),
                subtitle: _languages[Provider.of<LanguageProvider>(context)
                    .currentLocale
                    .languageCode],
                onTap: _showLanguageDialog,
              ),
              _buildListTile(
                context,
                icon: Icons.attach_money,
                title: _getTranslatedText('currency'),
                subtitle: _selectedCurrency,
                onTap: _showCurrencyDialog,
              ),
            ],
          ),
          // Notifications Section
          _buildSection(
            context,
            _getTranslatedText('notifications'),
            [
              _buildListTile(
                context,
                icon: Icons.notifications_outlined,
                title: _getTranslatedText('push_notifications'),
                onTap: () {
                  // TODO: Implement push notifications settings
                },
              ),
              _buildListTile(
                context,
                icon: Icons.email_outlined,
                title: _getTranslatedText('email_notifications'),
                onTap: () {
                  // TODO: Implement email notifications settings
                },
              ),
              _buildListTile(
                context,
                icon: Icons.calendar_today_outlined,
                title: _getTranslatedText('reminder_settings'),
                onTap: () {
                  // TODO: Implement reminder settings
                },
              ),
            ],
          ),
          // Privacy Section
          _buildSection(
            context,
            _getTranslatedText('privacy'),
            [
              _buildListTile(
                context,
                icon: Icons.security_outlined,
                title: _getTranslatedText('privacy_settings'),
                onTap: () {
                  // TODO: Implement privacy settings
                },
              ),
              _buildListTile(
                context,
                icon: Icons.data_usage_outlined,
                title: _getTranslatedText('data_usage'),
                onTap: () {
                  // TODO: Implement data usage settings
                },
              ),
            ],
          ),
          // About Section
          _buildSection(
            context,
            _getTranslatedText('about'),
            [
              _buildListTile(
                context,
                icon: Icons.info_outline,
                title: _getTranslatedText('app_version'),
                subtitle: '1.0.0',
                onTap: () {
                  // TODO: Show version details
                },
              ),
              _buildListTile(
                context,
                icon: Icons.description_outlined,
                title: _getTranslatedText('terms_of_service'),
                onTap: () {
                  // TODO: Show terms of service
                },
              ),
              _buildListTile(
                context,
                icon: Icons.privacy_tip_outlined,
                title: _getTranslatedText('privacy_policy'),
                onTap: () {
                  // TODO: Show privacy policy
                },
              ),
            ],
          ),
          // Support Section
          _buildSection(
            context,
            _getTranslatedText('support'),
            [
              _buildListTile(
                context,
                icon: Icons.help_outline,
                title: _getTranslatedText('help_center'),
                onTap: () {
                  // TODO: Show help center
                },
              ),
              _buildListTile(
                context,
                icon: Icons.feedback_outlined,
                title: _getTranslatedText('send_feedback'),
                onTap: () {
                  // TODO: Implement feedback
                },
              ),
              _buildListTile(
                context,
                icon: Icons.bug_report_outlined,
                title: _getTranslatedText('report_bug'),
                onTap: () {
                  // TODO: Implement bug reporting
                },
              ),
            ],
          ),
          // Account Section
          _buildSection(
            context,
            _getTranslatedText('account'),
            [
              _buildListTile(
                context,
                icon: Icons.logout,
                title: _getTranslatedText('sign_out'),
                textColor: Colors.red,
                onTap: () {
                  // TODO: Implement sign out
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
      BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        ...children,
        const Divider(),
      ],
    );
  }

  Widget _buildListTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    Color? textColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? Theme.of(context).textTheme.bodyLarge?.color,
        ),
      ),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_getTranslatedText('select_language')),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _languages.length,
            itemBuilder: (context, index) {
              final languageCode = _languages.keys.elementAt(index);
              final languageName = _languages[languageCode];
              return ListTile(
                title: Text(languageName!),
                trailing: languageCode ==
                        Provider.of<LanguageProvider>(context)
                            .currentLocale
                            .languageCode
                    ? const Icon(Icons.check)
                    : null,
                onTap: () {
                  Provider.of<LanguageProvider>(context, listen: false)
                      .setLanguage(languageCode);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showCurrencyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_getTranslatedText('select_currency')),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _currencies.length,
            itemBuilder: (context, index) {
              final currency = _currencies[index];
              return ListTile(
                title: Text(currency),
                trailing: currency == _selectedCurrency
                    ? const Icon(Icons.check)
                    : null,
                onTap: () {
                  setState(() {
                    _selectedCurrency = currency;
                  });
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
