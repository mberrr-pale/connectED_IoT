import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../features/home/presentation/home_page.dart';
import '../features/materials/presentation/materials_page.dart';
import '../features/profile/presentation/profile_page.dart';
import '../features/results/presentation/results_page.dart';
import '../features/simulation/presentation/simulation_page.dart';
import '../models/learning_progress.dart';
import '../features/home/presentation/meeting_detail_page.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final LearningProgress _progress = LearningProgress.initial();

  bool get _isSimulationUnlocked {
    final meeting = _progress.meetings[1]!;

    return meeting.passedPostTest &&
        LearningStage.values.every(
          (stage) => meeting.isStageCompleted(stage),
        );
  }

  void _openSimulation() {
    if (!_isSimulationUnlocked) return;

    setState(() {
      _selectedIndex = 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      HomePage(
        progress: _progress,
        onProgressChanged: () => setState(() {}),
        onOpenSimulation: _openSimulation,
      ),
      MaterialsPage(
        progress: _progress,
        onOpenMeeting: (meetingNumber) {
          final meeting = _progress.meetings[meetingNumber]!;

          final meetingTitles = <int, String>{
            1: 'Pertemuan 1 - Konsep IoT & Mikrokontroler',
            2: 'Pertemuan 2 - Sensor & IoT Protocol',
            3: 'Pertemuan 3 - Cloud IoT Integration',
            4: 'Pertemuan 4 - Dashboard Monitoring'
          };
        
        if (!_progress.isMeetingUnlocked(meetingNumber)){
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Lulus post-test pertemuan sebelumnya '
                'untuk membuka pertemuan ini.',
              ),
            ),
          );
          return;
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MeetingDetailPage(
              meetingNumber: meetingNumber, 
              meetingTitle: meetingTitles[meetingNumber]!,
              progress: meeting, 
              isUnlocked: true,
              onProgressChanged: () => setState(() {}),
              onOpenSimulation: _openSimulation,
            ),
          ),
        ).then((_) {
          if (mounted) setState(() {});
        });
        },
      ),
      _isSimulationUnlocked
          ? const SimulationPage(meetingNumber: 1)
          : const _LockedSimulationPage(),
      const ResultsPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: pages,
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          if (index == 2 && !_isSimulationUnlocked) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Selesaikan Pertemuan 1 untuk membuka Simulasi.',
                ),
              ),
            );
            return;
          }

          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book_rounded),
            label: 'Materi',
          ),
          NavigationDestination(
            icon: Icon(Icons.memory_outlined),
            selectedIcon: Icon(Icons.memory_rounded),
            label: 'Simulasi',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart_rounded),
            label: 'Hasil',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

class _LockedSimulationPage extends StatelessWidget {
  const _LockedSimulationPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simulasi'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.lock_outline_rounded,
                size: 56,
                color: AppColors.textSecondary,
              ),
              const SizedBox(height: 16),
              Text(
                'Simulasi Belum Terbuka',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Selesaikan keenam tahap Pertemuan 1, '
                'termasuk Post-test, Refleksi, dan Preview, '
                'untuk membuka Simulasi.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
