import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safeloan/app/services/notification_service.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationManager {
  final NotificationService notificationService = NotificationService();
  final Map<String, List<int>> scheduledNotifications = {};

  Future<void> scheduleNotifications(String userId) async {
    await notificationService.initNotification();
    tz.initializeTimeZones();
    final localTimezone = tz.getLocation('Asia/Jakarta');

    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('loans')
        .snapshots()
        .listen((snapshot) async {
      final now = tz.TZDateTime.now(localTimezone);

      for (var change in snapshot.docChanges) {
        final docId = change.doc.id;
        final data = change.doc.data();

        if (change.type == DocumentChangeType.added || change.type == DocumentChangeType.modified) {
          final tanggalPinjaman = (data!['tanggalPinjaman'] as Timestamp).toDate();
          final angsuran = data['angsuran'] as int;
          final jumlahPinjaman = data['jumlahPinjaman'] as double;
          final namaPinjaman = data['namaPinjaman'] as String;

          final tzTanggalPinjaman = tz.TZDateTime.from(tanggalPinjaman, localTimezone);

          // Check existing notifications for this loan
          final existingNotificationsSnapshot = await FirebaseFirestore.instance
              .collection('notifications')
              .where('userId', isEqualTo: userId)
              .where('loanId', isEqualTo: docId)
              .get();

          final existingNotifications = existingNotificationsSnapshot.docs
              .map((doc) => (doc['scheduledTime'] as Timestamp).toDate())
              .map((dateTime) => tz.TZDateTime.from(dateTime, localTimezone))
              .toSet();

          final newNotifications = <Map<String, dynamic>>[];
          final batch = FirebaseFirestore.instance.batch();

          for (int i = 0; i < angsuran; i++) {
            final notificationDate = tz.TZDateTime(
              localTimezone,
              tzTanggalPinjaman.year,
              tzTanggalPinjaman.month + i,
              tzTanggalPinjaman.day,
              now.hour,
              now.minute,
              now.second,
            );

            if (notificationDate.isAfter(now) && !existingNotifications.contains(notificationDate)) {
              final notificationId = '${docId}_${notificationDate.toIso8601String()}';
              final notificationData = {
                'createdAt': Timestamp.fromDate(now),
                'description': 'Bayar Angsuran Sebesar Rp. ${jumlahPinjaman / angsuran}',
                'jumlahPinjaman': jumlahPinjaman,
                'tanggalPinjaman': Timestamp.fromDate(tanggalPinjaman),
                'title': 'Tagihan Pinjaman: $namaPinjaman',
                'read': false,
                'userId': userId,
                'loanId': docId,
                'scheduledTime': Timestamp.fromDate(notificationDate),
              };

              final notificationRef = FirebaseFirestore.instance.collection('notifications').doc(notificationId);
              batch.set(notificationRef, notificationData);
              newNotifications.add(notificationData);
            }
          }

          await batch.commit();

          // Schedule notifications after batch commit
          for (final notificationData in newNotifications) {
            final notificationDate = (notificationData['scheduledTime'] as Timestamp).toDate();
            final notificationTzDate = tz.TZDateTime.from(notificationDate, localTimezone);
            final notificationId = (docId.hashCode ^ notificationTzDate.millisecondsSinceEpoch) % (1 << 31);

            await notificationService.showNotification(
              id: notificationId,
              title: notificationData['title'],
              body: notificationData['description'],
              sound: 'notif',
              channelId: 'channel_id_00',
              scheduledTime: notificationTzDate,
            );

            // Save notification ID for future removal
            scheduledNotifications.putIfAbsent(docId, () => []).add(notificationId);
          }
        } else if (change.type == DocumentChangeType.removed) {
          await cancelScheduledNotifications(docId);
        }
      }
    });
  }

  Future<void> cancelScheduledNotifications(String docId) async {
    final ids = scheduledNotifications[docId] ?? [];
    for (int id in ids) {
      await notificationService.cancelNotification(id);
    }
    scheduledNotifications.remove(docId);

    // Remove related notifications from Firestore
    final notificationsSnapshot = await FirebaseFirestore.instance
        .collection('notifications')
        .where('loanId', isEqualTo: docId)
        .get();

    final batch = FirebaseFirestore.instance.batch();
    for (var doc in notificationsSnapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  Future<void> deleteLoanNotifications(String loanId) async {
    await cancelScheduledNotifications(loanId);
  }
}
