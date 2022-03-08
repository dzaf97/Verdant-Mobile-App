import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:verdant_solar/controller/customer-view/notification.dart';
import 'package:verdant_solar/utils/constants.dart';
import 'package:verdant_solar/model/customer-view/notification.dart';

class NotificationPage extends StatelessWidget {
  final controller = Get.put(NotificationController());
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "NOTIFICATION",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontFamily: "BebasNeue",
            letterSpacing: 4,
          ),
        ),
        backgroundColor: Color(kPrimaryColor),
      ),
      body: Obx(
        () {
          List<Widget> notificationList = [];
          int notiCount = int.parse(Get.parameters['notiCount']!);

          for (var i = 0; i < controller.notifications.length; i++) {
            Message item = controller.notifications[i];

            if (notiCount <= 0) {
              notificationList.add(
                NotificationTile(
                  isNew: false,
                  title: item.alertName,
                  subtitle: item.alertReportedAt,
                ),
              );
            } else {
              notificationList.add(
                NotificationTile(
                  isNew: true,
                  title: item.alertName,
                  subtitle: item.alertReportedAt,
                ),
              );
            }
            notiCount--;
          }

          return ListView(
            children: notificationList,
          );
        },
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  const NotificationTile({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.isNew,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final bool isNew;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade300))),
      child: ListTile(
        tileColor:
            (isNew) ? Color(kPrimaryColor).withOpacity(0.2) : Colors.white,
        leading: Icon((isNew) ? Icons.mark_email_unread : Icons.mark_email_read),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Color(kPrimaryColor)),
        ),
      ),
    );
  }
}
