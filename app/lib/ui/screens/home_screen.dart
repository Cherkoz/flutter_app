import 'package:flutter/material.dart';
import 'package:grocery_delivery/ui/theme/brand_colors.dart';
import 'package:grocery_delivery/ui/theme/brand_typography.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Главная',
          style: BrandTypography.h4,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const NextLessonCard(),
                const SizedBox(height: 24),
                // Здесь можно добавить другой контент главной страницы
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NextLessonCard extends StatelessWidget {
  const NextLessonCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Заглушка с данными для демонстрации верстки
    final String lessonTitle = 'Математика';
    final String lessonDate = 'Сегодня';
    final String lessonTime = '14:30';
    final String lessonTeacher = 'Иванова М.П.';
    final String lessonRoom = 'Кабинет 205';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            BrandColors.accent,
            BrandColors.accent
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: BrandColors.accent.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: BrandColors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    lessonDate.toUpperCase(),
                    style: BrandTypography.caption.copyWith(
                      color: BrandColors.white,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: BrandColors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.calendar_today,
                    color: BrandColors.white,
                    size: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Следующий урок',
              style: BrandTypography.caption.copyWith(
                color: BrandColors.white.withOpacity(0.9),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              lessonTitle,
              style: BrandTypography.h2.copyWith(
                color: BrandColors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 1,
              color: BrandColors.white.withOpacity(0.2),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(
                  Icons.access_time,
                  color: BrandColors.white,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  lessonTime,
                  style: BrandTypography.callout.copyWith(
                    color: BrandColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 24),
                const Icon(
                  Icons.room,
                  color: BrandColors.white,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  lessonRoom,
                  style: BrandTypography.callout.copyWith(
                    color: BrandColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.person_outline,
                  color: BrandColors.white,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  lessonTeacher,
                  style: BrandTypography.callout.copyWith(
                    color: BrandColors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
