
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../app_colors.dart';
import 'login_screen.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() =>
      _AccountSettingsScreenState();
}

class _AccountSettingsScreenState
    extends State<AccountSettingsScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  bool isLoading = false;

  User? get currentUser => auth.currentUser;

  // POPUP MESSAGE
  void showMessage(
    String title,
    String message, {
    bool success = false,
  }) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: darkGreen,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        icon: Icon(
          success
              ? Icons.check_circle_outline
              : Icons.error_outline,
          color: success ? lightGreen : Colors.redAccent,
          size: 48,
        ),
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryGreen,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // CUSTOM INPUT DECORATION
  InputDecoration customInputDecoration({
    required String label,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: lightGreen),
      prefixIcon: const Icon(
        Icons.lock_outline,
        color: lightGreen,
      ),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: appBarGreen,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: lightGreen.withValues(alpha: 0.25),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: lightGreen,
          width: 1.5,
        ),
      ),
    ).copyWith(
      prefixIcon: Icon(icon, color: lightGreen),
    );
  }

  // EDIT PROFILE
  Future<void> editProfile() async {
    final user = currentUser;
    if (user == null) return;

    final controller = TextEditingController(
      text: user.displayName ?? '',
    );

    final name = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: darkGreen,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: TextField(
          controller: controller,
          textCapitalization: TextCapitalization.words,
          style: const TextStyle(color: Colors.white),
          decoration: customInputDecoration(
            label: 'Full Name',
            icon: Icons.person_outline,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(
                dialogContext,
                controller.text.trim(),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryGreen,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    controller.dispose();

    if (name == null) return;

    if (name.isEmpty) {
      showMessage(
        'Invalid Name',
        'Please enter your full name.',
      );
      return;
    }

    try {
      await user.updateDisplayName(name);
      await user.reload();

      if (!mounted) return;

      setState(() {});

      showMessage(
        'Profile Updated',
        'Your profile name has been updated successfully.',
        success: true,
      );
    } catch (e) {
      if (mounted) {
        showMessage(
          'Update Failed',
          'Unable to update your profile. Please try again.',
        );
      }
    }
  }

  // CHANGE PASSWORD
  Future<void> changePassword() async {
    if (isLoading) return;

    final currentPasswordController =
        TextEditingController();
    final newPasswordController =
        TextEditingController();
    final confirmPasswordController =
        TextEditingController();

    bool showCurrent = false;
    bool showNew = false;
    bool showConfirm = false;

    final passwords = await showDialog<List<String>>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: darkGreen,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text(
              'Change Password',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: currentPasswordController,
                    obscureText: !showCurrent,
                    style: const TextStyle(color: Colors.white),
                    decoration: customInputDecoration(
                      label: 'Current Password',
                      icon: Icons.lock_outline,
                      suffixIcon: IconButton(
                        icon: Icon(
                          showCurrent
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: lightGreen,
                        ),
                        onPressed: () {
                          setDialogState(() {
                            showCurrent = !showCurrent;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    controller: newPasswordController,
                    obscureText: !showNew,
                    style: const TextStyle(color: Colors.white),
                    decoration: customInputDecoration(
                      label: 'New Password',
                      icon: Icons.lock_reset,
                      suffixIcon: IconButton(
                        icon: Icon(
                          showNew
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: lightGreen,
                        ),
                        onPressed: () {
                          setDialogState(() {
                            showNew = !showNew;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    controller: confirmPasswordController,
                    obscureText: !showConfirm,
                    style: const TextStyle(color: Colors.white),
                    decoration: customInputDecoration(
                      label: 'Confirm New Password',
                      icon: Icons.lock_outline,
                      suffixIcon: IconButton(
                        icon: Icon(
                          showConfirm
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: lightGreen,
                        ),
                        onPressed: () {
                          setDialogState(() {
                            showConfirm = !showConfirm;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(dialogContext, [
                    currentPasswordController.text,
                    newPasswordController.text,
                    confirmPasswordController.text,
                  ]);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Update'),
              ),
            ],
          );
        },
      ),
    );

    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();

    if (passwords == null) return;

    final currentPassword = passwords[0];
    final newPassword = passwords[1];
    final confirmPassword = passwords[2];

    if (currentPassword.isEmpty ||
        newPassword.isEmpty ||
        confirmPassword.isEmpty) {
      showMessage(
        'Missing Information',
        'Please complete all password fields.',
      );
      return;
    }

    if (newPassword.length < 6) {
      showMessage(
        'Weak Password',
        'Your new password must contain at least 6 characters.',
      );
      return;
    }

    if (newPassword != confirmPassword) {
      showMessage(
        'Password Mismatch',
        'Your new passwords do not match.',
      );
      return;
    }

    final user = currentUser;
    final email = user?.email;

    if (user == null || email == null) {
      showMessage(
        'Account Error',
        'Unable to identify your account.',
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final credential = EmailAuthProvider.credential(
        email: email,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);

      if (!mounted) return;

      showMessage(
        'Password Updated',
        'Your password has been changed successfully.',
        success: true,
      );
    } on FirebaseAuthException catch (e) {
      String message = 'Unable to update your password.';

      if (e.code == 'wrong-password' ||
          e.code == 'invalid-credential') {
        message = 'Your current password is incorrect.';
      } else if (e.code == 'weak-password') {
        message = 'Please choose a stronger password.';
      } else if (e.code == 'requires-recent-login') {
        message =
            'Please sign in again before changing your password.';
      } else if (e.code == 'network-request-failed') {
        message = 'Please check your internet connection.';
      }

      if (mounted) {
        showMessage('Password Update Failed', message);
      }
    } catch (e) {
      if (mounted) {
        showMessage(
          'Error',
          'Something went wrong. Please try again.',
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  // LOGOUT CONFIRMATION
  Future<void> logout() async {
    if (isLoading) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: darkGreen,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        icon: Container(
          height: 75,
          width: 75,
          decoration: BoxDecoration(
            color: primaryGreen.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.logout_rounded,
            color: lightGreen,
            size: 38,
          ),
        ),
        title: const Text(
          'Logout',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 21,
          ),
        ),
        content: const Text(
          'Are you sure you want to logout from MediStock?',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        actions: [
          OutlinedButton(
            onPressed: () =>
                Navigator.pop(dialogContext, false),
            style: OutlinedButton.styleFrom(
              foregroundColor: lightGreen,
              side: const BorderSide(color: primaryGreen),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 22,
                vertical: 12,
              ),
            ),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            onPressed: () =>
                Navigator.pop(dialogContext, true),
            icon: const Icon(Icons.logout, size: 17),
            label: const Text('Logout'),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryGreen,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 22,
                vertical: 12,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await auth.signOut();

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ),
        (route) => false,
      );
    } catch (e) {
      if (mounted) {
        showMessage(
          'Logout Failed',
          'Unable to logout. Please try again.',
        );
      }
    }
  }

  // SECTION TITLE
  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 12,
        top: 8,
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: darkGreen,
          fontWeight: FontWeight.bold,
          fontSize: 14,
          letterSpacing: 1,
        ),
      ),
    );
  }

  // SETTINGS CARD
  
  // SETTINGS CARD
  Widget settingsCard({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return _HoverSettingsCard(
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: darkGreen,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: primaryGreen.withValues(alpha: 0.4),
          ),
          boxShadow: [
            BoxShadow(
              color: darkGreen.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          clipBehavior: Clip.antiAlias,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 8,
            ),
            leading: Container(
              height: 43,
              width: 43,
              decoration: BoxDecoration(
                color: primaryGreen.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: lightGreen),
            ),
            title: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              subtitle,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
            trailing: trailing ??
                const Icon(
                  Icons.chevron_right,
                  color: lightGreen,
                ),
            onTap: onTap,
          ),
        ),
      ),
    );
  }

  // LOGOUT BUTTON
  Widget logoutButton() {
    return _HoverSettingsCard(
      child: SizedBox(
        width: double.infinity,
        height: 58,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                darkGreen,
                appBarGreen,
                primaryGreen,
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: lightGreen.withValues(alpha: 0.45),
            ),
            boxShadow: [
              BoxShadow(
                color: darkGreen.withValues(alpha: 0.18),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ElevatedButton.icon(
            onPressed: logout,
          
            label: const Text(
              'LOG OUT',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
                letterSpacing: 1.2,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              shadowColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = currentUser;

    final displayName =
        user?.displayName?.isNotEmpty == true
            ? user!.displayName!
            : 'MediStock User';

    final email = user?.email ?? 'No email';

    final initial =
        user?.displayName?.isNotEmpty == true
            ? user!.displayName![0].toUpperCase()
            : (user?.email?.isNotEmpty == true
                ? user!.email![0].toUpperCase()
                : 'M');

    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding =
        screenWidth >= 900 ? 32.0 : 20.0;

    return Scaffold(
      backgroundColor: backgroundGreen,
      appBar: AppBar(
        backgroundColor: appBarGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Account Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: user == null
          ? const Center(
              child: Text(
                'No user is currently logged in.',
                style: TextStyle(color: darkGreen),
              ),
            )
          : Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 850,
                ),
                child: ListView(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: 24,
                  ),
                  children: [
                    // PROFILE CARD
                    Container(
                      padding: EdgeInsets.all(
                        screenWidth >= 600 ? 32 : 24,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            darkGreen,
                            primaryGreen,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: lightGreen.withValues(alpha: 0.25),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: darkGreen.withValues(alpha: 0.18),
                            blurRadius: 15,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: lightGreen,
                                width: 2,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: screenWidth >= 600 ? 48 : 43,
                              backgroundColor: Colors.white,
                              child: Text(
                                initial,
                                style: TextStyle(
                                  fontSize:
                                      screenWidth >= 600 ? 39 : 35,
                                  color: primaryGreen,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            displayName,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize:
                                  screenWidth >= 600 ? 25 : 22,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            email,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: lightGreen.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: lightGreen.withValues(alpha: 0.5),
                              ),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.verified_user,
                                  color: lightGreen,
                                  size: 17,
                                ),
                                SizedBox(width: 7),
                                Text(
                                  'Active Account',
                                  style: TextStyle(
                                    color: lightGreen,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    sectionTitle('PROFILE INFORMATION'),

                    settingsCard(
                      icon: Icons.person_outline,
                      title: 'Edit Profile',
                      subtitle: 'Update your display name',
                      onTap: editProfile,
                    ),

                    settingsCard(
                      icon: Icons.email_outlined,
                      title: 'Email Address',
                      subtitle: email,
                      trailing: Icon(
                        user.emailVerified
                            ? Icons.verified
                            : Icons.info_outline,
                        color: user.emailVerified
                            ? lightGreen
                            : Colors.orangeAccent,
                      ),
                    ),

                    const SizedBox(height: 15),

                    sectionTitle('SECURITY'),

                    settingsCard(
                      icon: Icons.lock_outline,
                      title: 'Change Password',
                      subtitle: 'Update your account password',
                      trailing: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: lightGreen,
                                strokeWidth: 2,
                              ),
                            )
                          : null,
                      onTap: isLoading ? null : changePassword,
                    ),

                    const SizedBox(height: 18),

                    // DARK GREEN LOGOUT BUTTON
                    logoutButton(),

                    const SizedBox(height: 25),

                    const Center(
                      child: Text(
                        'MediStock • Account Management',
                        style: TextStyle(
                          color: darkGreen,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
    );
  }
}

// HOVER EFFECT FOR DESKTOP AND WEB
class _HoverSettingsCard extends StatefulWidget {
  final Widget child;

  const _HoverSettingsCard({
    required this.child,
  });

  @override
  State<_HoverSettingsCard> createState() =>
      _HoverSettingsCardState();
}

class _HoverSettingsCardState
    extends State<_HoverSettingsCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => isHovered = true);
      },
      onExit: (_) {
        setState(() => isHovered = false);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.translationValues(
          0,
          isHovered ? -3 : 0,
          0,
        ),
        child: widget.child,
      ),
    );
  }
}
