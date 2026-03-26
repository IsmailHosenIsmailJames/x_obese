import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:x_obese/src/data/user_db.dart";
import "package:x_obese/src/theme/colors.dart";

Future<void> showSignupPopup(BuildContext context) async {
  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          insetPadding: const EdgeInsets.all(10),
          title: Row(
            children: [
              Icon(Icons.info_outline, color: MyAppColors.third, size: 28),
              const SizedBox(width: 8),
              const Text(
                "Sign Up Required",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "To access this feature, please create an account or log in with your existing credentials.",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 12),
              Text(
                "Signing up lets you save progress and sync your data securely.",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
          actions: [
            TextButton.icon(
              style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
              onPressed: () => context.pop(),
              icon: const Icon(Icons.close_rounded),
              label: const Text("Cancel"),
            ),
            TextButton.icon(
              style: TextButton.styleFrom(foregroundColor: Colors.green),
              onPressed: () async {
                await UserDB.deleteUserData();
                if (context.mounted) {
                  context.go("/login");
                }
              },
              iconAlignment: IconAlignment.end,
              icon: const Icon(Icons.arrow_forward_rounded),
              label: const Text("Sign Up"),
            ),
          ],
        ),
  );
}
