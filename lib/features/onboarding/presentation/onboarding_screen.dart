
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import 'role_selection_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() =>
      _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  int _currentPage = 0;

  final List<_OnboardingItem> _items = const [
    _OnboardingItem(
      icon: Icons.lightbulb_outline_rounded,
      title: 'Kenali Dunia IoT',
      description:
          'Pelajari bagaimana perangkat dapat saling terhubung '
          'dan bertukar informasi.',
      color: AppColors.primary,
      backgroundColor: AppColors.primaryLight,
    ),
    _OnboardingItem(
      icon: Icons.sensors_rounded,
      title: 'Belajar Sambil Mencoba',
      description:
          'Pahami sensor, komponen, dan cara kerja IoT melalui '
          'materi serta simulasi interaktif.',
      color: AppColors.cyan,
      backgroundColor: AppColors.cyanLight,
    ),
    _OnboardingItem(
      icon: Icons.route_rounded,
      title: 'Ikuti Perjalanan Belajarmu',
      description:
          'Pantau progres setiap pertemuan dan lanjutkan '
          'belajar sesuai tahapan yang tersedia.',
      color: AppColors.violet,
      backgroundColor: AppColors.violetLight,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToRoleSelection() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const RoleSelectionScreen(),
      ),
    );
  }

  void _nextPage() {
    if (_currentPage == _items.length - 1) {
      _goToRoleSelection();
      return;
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final item = _items[_currentPage];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _goToRoleSelection,
                  child: const Text('Lewati'),
                ),
              ),

              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _items.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final slide = _items[index];

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            color: slide.backgroundColor,
                            borderRadius:
                                BorderRadius.circular(44),
                          ),
                          child: Icon(
                            slide.icon,
                            size: 88,
                            color: slide.color,
                          ),
                        ),

                        const SizedBox(height: 40),

                        Text(
                          slide.title,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                        ),

                        const SizedBox(height: 16),

                        Text(
                          slide.description,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 16,
                            height: 1.6,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _items.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 4,
                    ),
                    width: index == _currentPage ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: index == _currentPage
                          ? item.color
                          : AppColors.border,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _nextPage,
                  child: Text(
                    _currentPage == _items.length - 1
                        ? 'Mulai'
                        : 'Lanjutkan',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingItem {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final Color backgroundColor;

  const _OnboardingItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.backgroundColor,
  });
}
