import 'package:flutter/material.dart';

import 'package:medsyncc/core/theme/app_theme.dart';
import 'package:medsyncc/models/hospital.dart';
import 'package:medsyncc/services/hospital_service.dart';
import 'package:medsyncc/widgets/hospital_card.dart';
import 'package:medsyncc/widgets/search_bar.dart';
import 'package:medsyncc/screens/hospital_details_screen.dart';
import 'package:medsyncc/screens/hospital_list_screen.dart';

import '../widgets/medsync_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HospitalService _hospitalService = HospitalService();

  List<Hospital> _hospitals = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _activeSearchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadHospitals();
  }

  Future<void> _loadHospitals() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final hospitals = await _hospitalService.getHospitals();

      if (!mounted) return;

      setState(() {
        _hospitals = hospitals;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _searchHospital(String query) async {
    final search = query.trim();

    if (search.isEmpty) {
      setState(() => _activeSearchQuery = '');
      await _loadHospitals();
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _activeSearchQuery = search;
    });

    try {
      final hospitals = await _hospitalService.searchHospitals(search);

      if (!mounted) return;

      setState(() {
        _hospitals = hospitals;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  int _matchingAvailableDoctorCount(
    Hospital hospital,
    String query,
  ) {
    final search = query.trim().toLowerCase();

    if (search.isEmpty) return 0;

    return hospital.availableDoctors.where((doctor) {
      final specialization = doctor.specialization.toLowerCase();
      return specialization.contains(search);
    }).length;
  }

  String? _getDoctorAvailabilityLabel(Hospital hospital) {
    if (_activeSearchQuery.isEmpty) return null;

    final count = _matchingAvailableDoctorCount(
      hospital,
      _activeSearchQuery,
    );

    if (count == 0) return null;

    final formattedQuery =
        _activeSearchQuery[0].toUpperCase() + _activeSearchQuery.substring(1);

    return count == 1
        ? '1 $formattedQuery doctor available'
        : '$count $formattedQuery doctors available';
  }

  void _openHospital(Hospital hospital) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => HospitalDetailsScreen(hospital: hospital),
      ),
    );
  }

  void _openHospitalList() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => HospitalListScreen(
          hospitals: _hospitals,
          searchQuery: _activeSearchQuery,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MedSyncDrawer(),
      appBar: AppBar(
        toolbarHeight: 72,
        titleSpacing: 0,
        title: const Row(
          children: [
            _BrandMark(),
            SizedBox(width: 11),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'MedSync',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  'Patient care network',
                  style: TextStyle(
                    color: AppColors.muted,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 14),
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.successSoft,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: AppColors.success.withValues(alpha: 0.25),
              ),
            ),
            child: const Row(
              children: [
                CircleAvatar(
                  radius: 3,
                  backgroundColor: AppColors.success,
                ),
                SizedBox(width: 6),
                Text(
                  'Live',
                  style: TextStyle(
                    color: AppColors.success,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadHospitals,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Find the right care',
                style: TextStyle(
                  color: AppColors.text,
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.6,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Search hospitals and doctors with live availability.',
                style: TextStyle(
                  color: AppColors.muted,
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 18),
              CustomSearchBar(
                hint: 'Search disease, doctor, or hospital',
                onSubmitted: _searchHospital,
              ),
              const SizedBox(height: 24),
              SectionTitle(
                title: _activeSearchQuery.isEmpty
                    ? 'Hospitals'
                    : 'Results for “$_activeSearchQuery”',
                subtitle: _activeSearchQuery.isEmpty
                    ? 'Live capacity from connected hospitals'
                    : '${_hospitals.length} matching hospital${_hospitals.length == 1 ? '' : 's'}',
                trailing: TextButton(
                  onPressed: _hospitals.isEmpty ? null : _openHospitalList,
                  child: const Text('See all'),
                ),
              ),
              const SizedBox(height: 14),
              if (_isLoading)
                const _LoadingPanel()
              else if (_errorMessage != null)
                _ErrorPanel(
                  message: _errorMessage!,
                  onRetry: _loadHospitals,
                )
              else if (_hospitals.isEmpty)
                _EmptyPanel(query: _activeSearchQuery)
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _hospitals.length > 3 ? 3 : _hospitals.length,
                  itemBuilder: (context, index) {
                    final hospital = _hospitals[index];
                    return HospitalCard(
                      hospital: hospital,
                      searchMatchLabel: _getDoctorAvailabilityLabel(hospital),
                      onTap: () => _openHospital(hospital),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.monitor_heart_outlined,
        color: Colors.white,
        size: 22,
      ),
    );
  }
}

class _LoadingPanel extends StatelessWidget {
  const _LoadingPanel();

  @override
  Widget build(BuildContext context) {
    return const PortalPanel(
      child: SizedBox(
        height: 130,
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _ErrorPanel extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorPanel({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return PortalPanel(
      child: Column(
        children: [
          const Icon(
            Icons.cloud_off_outlined,
            color: AppColors.danger,
            size: 34,
          ),
          const SizedBox(height: 10),
          const Text(
            'Could not load hospitals',
            style: TextStyle(
              color: AppColors.text,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class _EmptyPanel extends StatelessWidget {
  final String query;

  const _EmptyPanel({required this.query});

  @override
  Widget build(BuildContext context) {
    return PortalPanel(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 26),
        child: Column(
          children: [
            const Icon(
              Icons.search_off_rounded,
              color: AppColors.muted,
              size: 38,
            ),
            const SizedBox(height: 10),
            Text(
              query.isEmpty
                  ? 'No hospitals available'
                  : 'No hospitals found for “$query”',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
