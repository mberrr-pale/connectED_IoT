import 'package:flutter/material.dart';

import '../features/teacher/teacher_home_page.dart';
import '../features/teacher/presentation/teacher_materials_page.dart';
import '../features/teacher/teacher_recap_page.dart';
import '../features/profile/presentation/teacher_profile_page.dart';
import '../features/teacher/presentation/meeting_detail_page.dart';

class TeacherNavigation extends StatefulWidget {
  const TeacherNavigation({super.key});

  @override
  State<TeacherNavigation> createState() => _TeacherNavigationState();
}

class _TeacherNavigationState extends State<TeacherNavigation> {
  int _selectedIndex = 0;
  int? _selectedMeetingNumber;

  void _openMaterials() {
    setState(() {
      _selectedIndex = 1;
      _selectedMeetingNumber = null;
    });
  }

  void _openMeeting(int meetingNumber) {
    setState(() {
      _selectedIndex = 1;
      _selectedMeetingNumber = meetingNumber;
    });
  }

  void _backToMaterials() {
    setState(() {
      _selectedMeetingNumber = null;
    });
  }

  void _openResults() {
    setState(() {
      _selectedIndex = 2;
      _selectedMeetingNumber = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      TeacherHomePage(
        onOpenMaterials: _openMaterials,
        onOpenResults: _openResults,
      ),

      _selectedMeetingNumber == null
          ? TeacherMaterialsPage(onOpenMeeting: _openMeeting)
          : MeetingDetailPage(
              key: ValueKey(_selectedMeetingNumber),
              meetingNumber: _selectedMeetingNumber!,
              meetingTitle: _meetingTitle(_selectedMeetingNumber!),
              onBack: _backToMaterials,
              onOpenSimulation: () {
                // Aksi simulasi bisa dihubungkan ke tab simulasi.
                debugPrint('Membuka simulasi');
              },
            ),

      const TeacherRecapPage(),
      const ProfileTeacherPage(),
    ];

    return PopScope(
      canPop: _selectedIndex == 0 && _selectedMeetingNumber == null,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        if (_selectedIndex == 1 && _selectedMeetingNumber != null) {
          _backToMaterials();
        } else if (_selectedIndex != 0) {
          setState(() {
            _selectedIndex = 0;
            _selectedMeetingNumber = null;
          });
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: IndexedStack(index: _selectedIndex, children: pages),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) {
            setState(() {
              _selectedIndex = index;
              _selectedMeetingNumber = null;
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.menu_book_outlined),
              selectedIcon: Icon(Icons.menu_book_rounded),
              label: 'Materi',
            ),
            NavigationDestination(
              icon: Icon(Icons.assessment_outlined),
              selectedIcon: Icon(Icons.assessment_rounded),
              label: 'Rekap',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline_rounded),
              selectedIcon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  String _meetingTitle(int meetingNumber) {
    switch (meetingNumber) {
      case 1:
        return 'Mengenal Internet of Things';
      case 2:
        return 'Mikrokontroler & Sensor';
      case 3:
        return 'Protokol & Cloud IoT';
      case 4:
        return 'Integrasi dan Proyek IoT';
      default:
        return 'Pertemuan $meetingNumber';
    }
  }
}
