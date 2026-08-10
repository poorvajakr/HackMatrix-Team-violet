enum BookingStatus {
  pending,
  confirmed,
  cancelled,
  completed,
}

class Booking {
  final String bookingId;
  final String hospitalId;
  final String hospitalName;
  final String doctorId;
  final String doctorName;
  final DateTime appointmentTime;
  final String reason;
  final BookingStatus status;

  Booking({
    required this.bookingId,
    required this.hospitalId,
    required this.hospitalName,
    required this.doctorId,
    required this.doctorName,
    required this.appointmentTime,
    required this.reason,
    required this.status,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      bookingId: json['bookingId'],
      hospitalId: json['hospitalId'],
      hospitalName: json['hospitalName'],
      doctorId: json['doctorId'],
      doctorName: json['doctorName'],
      appointmentTime: DateTime.parse(json['appointmentTime']),
      reason: json['reason'],
      status: BookingStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => BookingStatus.pending,
      ),
    );
  }
}
