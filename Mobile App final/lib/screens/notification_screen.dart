import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotificationScreen
    extends StatelessWidget {
  const NotificationScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final user =
        FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            'Please login to view bookings',
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
        ),
      ),

      body: StreamBuilder<
          QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collectionGroup('appointments')
            .where(
          'patientId',
          isEqualTo: user.uid,
        )
            .snapshots(),

        builder: (
            context,
            snapshot,
            ) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child:
              CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Unable to load notifications\n'
                    '${snapshot.error}',
                textAlign:
                TextAlign.center,
              ),
            );
          }

          final appointments =
              snapshot.data?.docs.toList() ??
                  [];

          // Newest first.
          appointments.sort(
                (a, b) {
              final aTime =
              a.data()['createdAt']
              as Timestamp?;

              final bTime =
              b.data()['createdAt']
              as Timestamp?;

              if (aTime == null ||
                  bTime == null) {
                return 0;
              }

              return bTime.compareTo(aTime);
            },
          );

          if (appointments.isEmpty) {
            return const _EmptyNotifications();
          }

          return ListView.builder(
            padding:
            const EdgeInsets.all(16),

            itemCount:
            appointments.length,

            itemBuilder: (
                context,
                index,
                ) {
              final data =
              appointments[index]
                  .data();

              return _BookingNotificationCard(
                data: data,
              );
            },
          );
        },
      ),
    );
  }
}

class _BookingNotificationCard
    extends StatelessWidget {
  final Map<String, dynamic> data;

  const _BookingNotificationCard({
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final status =
        data['status']
            ?.toString()
            .toLowerCase() ??
            'pending';

    final requestedTimestamp =
    data['requestedTime']
    as Timestamp?;

    final dateTime =
    requestedTimestamp?.toDate();

    Color statusColor;
    IconData statusIcon;
    String statusText;
    String message;

    switch (status) {
      case 'confirmed':
        statusColor =
            Colors.green;

        statusIcon =
            Icons.check_circle;

        statusText =
        'Confirmed';

        message =
        'Your appointment has been confirmed.';
        break;

      case 'declined':
        statusColor =
            Colors.red;

        statusIcon =
            Icons.cancel;

        statusText =
        'Declined';

        message =
        'Your appointment was declined.';
        break;

      default:
        statusColor =
            Colors.orange;

        statusIcon =
            Icons.schedule;

        statusText =
        'Booked';

        message =
        'Waiting for confirmation from the hospital.';
    }

    return Card(
      margin:
      const EdgeInsets.only(
        bottom: 14,
      ),

      child: Padding(
        padding:
        const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [
            Row(
              children: [
                Icon(
                  statusIcon,
                  color:
                  statusColor,
                ),

                const SizedBox(
                  width: 8,
                ),

                Text(
                  statusText,
                  style:
                  TextStyle(
                    color:
                    statusColor,
                    fontSize: 16,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 8,
            ),

            Text(
              message,
              style:
              const TextStyle(
                color:
                Colors.grey,
              ),
            ),

            const SizedBox(
              height: 16,
            ),

            _DetailRow(
              icon:
              Icons.local_hospital,
              label:
              'Hospital',
              value:
              data['hospitalName']
                  ?.toString() ??
                  '',
            ),

            _DetailRow(
              icon:
              Icons.person_outline,
              label:
              'Doctor',
              value:
              data['doctorName']
                  ?.toString() ??
                  '',
            ),

            _DetailRow(
              icon:
              Icons.medical_services_outlined,
              label:
              'Specialization',
              value:
              data['specialization']
                  ?.toString() ??
                  '',
            ),

            if (dateTime != null) ...[
              _DetailRow(
                icon:
                Icons.calendar_today_outlined,
                label:
                'Date',
                value:
                '${dateTime.day.toString().padLeft(2, '0')}/'
                    '${dateTime.month.toString().padLeft(2, '0')}/'
                    '${dateTime.year}',
              ),

              _DetailRow(
                icon:
                Icons.access_time,
                label:
                'Time',
                value:
                TimeOfDay.fromDateTime(
                  dateTime,
                ).format(context),
              ),
            ],

            if ((data['reason']
                ?.toString() ??
                '')
                .isNotEmpty)
              _DetailRow(
                icon:
                Icons.notes,
                label:
                'Reason',
                value:
                data['reason']
                    .toString(),
              ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow
    extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      const EdgeInsets.only(
        bottom: 10,
      ),

      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [
          Icon(
            icon,
            size: 18,
            color:
            Colors.blue,
          ),

          const SizedBox(
            width: 10,
          ),

          SizedBox(
            width: 105,
            child: Text(
              label,
              style:
              const TextStyle(
                color:
                Colors.grey,
                fontSize: 12,
              ),
            ),
          ),

          Expanded(
            child: Text(
              value,
              style:
              const TextStyle(
                fontWeight:
                FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyNotifications
    extends StatelessWidget {
  const _EmptyNotifications();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize:
        MainAxisSize.min,

        children: [
          Icon(
            Icons.notifications_none,
            size: 55,
            color:
            Colors.grey,
          ),

          SizedBox(
            height: 12,
          ),

          Text(
            'No booking notifications yet',
            style:
            TextStyle(
              fontWeight:
              FontWeight.bold,
            ),
          ),

          SizedBox(
            height: 5,
          ),

          Text(
            'Your appointment updates will appear here.',
            style:
            TextStyle(
              color:
              Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}