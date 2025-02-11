import 'package:flutter/material.dart';
import '../styles/colors.dart';
import '../styles/fonts.dart';

class SettingsPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Container(
      padding: EdgeInsets.all(screenWidth * 0.01),
      decoration: BoxDecoration(
        color: AppColors.white2,
        borderRadius: BorderRadius.circular(15),
      ),
      child: isLandscape
          ? _buildWideLayout(screenWidth)
          : screenWidth > 900
          ? _buildWideLayout(screenWidth)
          : screenWidth > 600
          ? _buildMediumLayout(screenWidth)
          : _buildNarrowLayout(screenWidth),
    );
  }

  Widget _buildWideLayout(double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildSettingItem(Icons.schedule, "Початок уроків о", "08:00", screenWidth),
        _buildSettingItem(Icons.cast_for_education, "Велика перерва після уроку №", "3", screenWidth),
        _buildSettingItem(Icons.emoji_food_beverage, "Тривалість великої перерви", "30 хв", screenWidth),
        _buildSettingItem(Icons.smoking_rooms, "Тривалість звичайної перерви", "10 хв", screenWidth),
      ],
    );
  }

  Widget _buildMediumLayout(double screenWidth) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildSettingItem(Icons.schedule, "Початок уроків о", "08:00", screenWidth),
            _buildSettingItem(Icons.cast_for_education, "Велика перерва після уроку №", "3", screenWidth),
          ],
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildSettingItem(Icons.emoji_food_beverage, "Тривалість великої перерви", "30 хв", screenWidth),
            _buildSettingItem(Icons.smoking_rooms, "Тривалість звичайної перерви", "10 хв", screenWidth),
          ],
        ),
      ],
    );
  }

  Widget _buildNarrowLayout(double screenWidth) {
    return Column(
      children: [
        _buildSettingItem(Icons.schedule, "Початок уроків о", "08:00", screenWidth),
        _buildSettingItem(Icons.cast_for_education, "Велика перерва після уроку №", "3", screenWidth),
        _buildSettingItem(Icons.emoji_food_beverage, "Тривалість великої перерви", "30 хв", screenWidth),
        _buildSettingItem(Icons.smoking_rooms, "Тривалість звичайної перерви", "10 хв", screenWidth),
      ],
    );
  }

  Widget _buildSettingItem(IconData icon, String title, String value, double screenWidth) {
    // Встановлення мінімальних розмірів для шрифтів та іконок
    double iconSize = screenWidth * 0.021;
    iconSize = iconSize < 22 ? 22 : iconSize; // Мінімальний розмір іконки — 24

    return Column(
      children: [
        Icon(icon, size: iconSize, color: AppColors.moonstone),
        SizedBox(height: 6),
        Text(title, style: AppTextStyles.h2),
        Text(
          value,
          style: AppTextStyles.h2.copyWith(color: Colors.yellow[800]),
        ),
      ],
    );
  }
}
