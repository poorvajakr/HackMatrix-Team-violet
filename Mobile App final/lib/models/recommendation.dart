import 'hospital.dart';

class Recommendation {
  final Hospital hospital;
  final double score;
  final List<String> reasons;

  Recommendation({
    required this.hospital,
    required this.score,
    required this.reasons,
  });
}
