import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return SettingsList(
      sections: [
        SettingsSection(
          title: Text('Common'),
          tiles: [
            SettingsTile(
              leading: Icon(Icons.language),
              title: Text('Language'),
              value: Text('English'),
            ),
            SettingsTile(
              leading: Icon(Icons.cloud_queue),
              title: Text('Environment'),
              value: Text('Production'),
            ),
          ],
        ),
        SettingsSection(
          title: Text('Account'),
          tiles: [
            SettingsTile(
              leading: Icon(Icons.phone),
              title: Text('Phone number'),
              onPressed: (context) {
                // Handle phone number click
              },
            ),
            SettingsTile(
              leading: Icon(Icons.email),
              title: Text('Email'),
              onPressed: (context) {
                // Handle email click
              },
            ),
            SettingsTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Sign out'),
              onPressed: (context) {
                // Handle sign out
              },
            ),
          ],
        ),
        SettingsSection(
          title: Text('Security'),
          tiles: [
            SettingsTile.switchTile(
              leading: Icon(Icons.phonelink_lock),
              title: Text('Lock app in background'),
              onToggle: (bool value) {},
              initialValue: true,
            ),
            SettingsTile.switchTile(
              leading: Icon(Icons.fingerprint),
              title: Text('Use fingerprint'),
              onToggle: (bool value) {},
              initialValue: false,
            ),
            SettingsTile(
              leading: Icon(Icons.lock),
              title: Text('Change password'),
              onPressed: (context) {
                // Handle change password click
              },
            ),
          ],
        ),
        SettingsSection(
          title: Text('Misc'),
          tiles: [
            SettingsTile(
              leading: Icon(Icons.description),
              title: Text('Terms of Service'),
              onPressed: (context) {
                // Handle terms of service click
              },
            ),
            SettingsTile(
              leading: Icon(Icons.collections_bookmark),
              title: Text('Open source licenses'),
              onPressed: (context) {
                // Handle open source licenses click
              },
            ),
          ],
        ),
        SettingsSection(
          title: Text('Footer'),
          tiles: [
            SettingsTile(
              title: Text('19:56', style: TextStyle(color: Colors.grey)),
            ),
          ],
        ),
      ],
    );
  }
}
