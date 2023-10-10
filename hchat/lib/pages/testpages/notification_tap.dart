import 'package:flutter/material.dart';
import 'package:hchat/service/auth_service.dart';
import 'package:hchat/widgets/custom_read_notification.dart';
import 'package:flutter/material.dart';

import '../../widgets/custom_read_notification2.dart';

/// A notification page that is displayed when the user taps on the toolbar notification icon.
///
/// This page displays three sections of notifications:
/// - New: a list of new notifications
/// - Today: a list of notifications received today
/// - Oldest: a list of the oldest notifications
class NotificationTap extends StatelessWidget {
  /// Constructor for [NotificationTap]
  NotificationTap({Key? key}) : super(key: key);

  /// List of new notifications
  List newItem = ["read", "y", "read", "y"];

  /// List of notifications received today
  List todayItem = ["read", "read"];

  /// List of the oldest notifications
  List oldesItem = ["y", "y"];

  @override

  /// Builds the widget for the notification page
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "New",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(
                  height: 5,
                ),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: newItem.length,
                  itemBuilder: (context, index) {
                    return newItem[index] == "read"
                        ? CustomFollowNotifcation()
                        : CustomReadNotifcation();
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Today",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: todayItem.length,
                  itemBuilder: (context, index) {
                    return todayItem[index] == "read"
                        ? CustomFollowNotifcation()
                        : CustomReadNotifcation();
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Oldest",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: oldesItem.length,
                  itemBuilder: (context, index) {
                    return oldesItem[index] == "read"
                        ? CustomFollowNotifcation()
                        : CustomReadNotifcation();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
