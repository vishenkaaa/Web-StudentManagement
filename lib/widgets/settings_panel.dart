import 'package:flutter/material.dart';
import '../services/config_service.dart';
import '../styles/colors.dart';
import '../styles/fonts.dart';

class SettingsPanel extends StatefulWidget {
  @override
  _SettingsPanelState createState() => _SettingsPanelState();
}

class _SettingsPanelState extends State<SettingsPanel> {
  bool isEditing = false;
  bool isLoading = true;
  String? error;

  Map<String, String> settings = {
    "Початок уроків о": "08:00",
    "Велика перерва після уроку №": "3",
    "Тривалість великої перерви": "30",
    "Тривалість звичайної перерви": "10",
  };
  Map<String, String> tempSettings = {};

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final response = await ConfigService.getSettings();

      setState(() {
        settings = {
          "Початок уроків о": response['lessonStartTime'] ?? "08:00",
          "Велика перерва після уроку №": response['bigBreakAfter']?.toString() ?? "3",
          "Тривалість великої перерви": response['bigBreakDuration']?.toString() ?? "30",
          "Тривалість звичайної перерви": response['smallBreakDuration']?.toString() ?? "10",
        };
        tempSettings = Map.from(settings);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _saveSettings() async {
    try {
      setState(() {
        error = null;
      });

      await ConfigService.updateSettings({
        'lessonStartTime': tempSettings["Початок уроків о"],
        'bigBreakAfter': int.parse(tempSettings["Велика перерва після уроку №"] ?? "3"),
        'bigBreakDuration': int.parse(tempSettings["Тривалість великої перерви"] ?? "30"),
        'smallBreakDuration': int.parse(tempSettings["Тривалість звичайної перерви"] ?? "10"),
      });

      setState(() {
        settings = Map.from(tempSettings);
        isEditing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Налаштування успішно збережено')),
      );
    } catch (e) {
      setState(() {
        error = e.toString();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Помилка при збереженні налаштувань'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Помилка: $error', style: TextStyle(color: Colors.red)),
            ElevatedButton(
              onPressed: _loadSettings,
              child: Text('Спробувати знову'),
            ),
          ],
        ),
      );
    }

    return Container(
        padding: EdgeInsets.fromLTRB(
            screenWidth * 0.01,
            0,
            screenWidth * 0.01,
            screenWidth * 0.01
        ),
      decoration: BoxDecoration(
        color: AppColors.white2,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [ 
          Stack(
            alignment: Alignment.center,
            children: [
              if(!isEditing)
                IconButton(
                  icon: Icon(size: 18, Icons.edit, color: Colors.grey),
                  onPressed: (){
                    setState(() {
                      isEditing = true;
                      tempSettings = Map.from(settings);
                    });
                  },
                )
              else
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.check, color: Colors.green),
                        onPressed: _saveSettings,
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            isEditing = false;
                          });
                        },
                      ),
                    ],
                  ),
                )
            ],
          ),
          isLandscape
              ? _buildWideLayout(screenWidth)
              : screenWidth > 900
              ? _buildWideLayout(screenWidth)
              : screenWidth > 600
              ? _buildMediumLayout(screenWidth)
              : _buildNarrowLayout(screenWidth),
        ],
      )
    );
  }

  Widget _buildWideLayout(double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildSettingItem(Icons.schedule, "Початок уроків о", "08:00",false,  screenWidth),
        _buildSettingItem(Icons.cast_for_education, "Велика перерва після уроку №", "3",false, screenWidth),
        _buildSettingItem(Icons.emoji_food_beverage, "Тривалість великої перерви", "30",true, screenWidth),
        _buildSettingItem(Icons.smoking_rooms, "Тривалість звичайної перерви", "10", true, screenWidth),
      ],
    );
  }

  Widget _buildMediumLayout(double screenWidth) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildSettingItem(Icons.schedule, "Початок уроків о", "08:00", false, screenWidth),
            _buildSettingItem(Icons.cast_for_education, "Велика перерва після уроку №", "3", false, screenWidth),
          ],
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildSettingItem(Icons.emoji_food_beverage, "Тривалість великої перерви", "30",  true, screenWidth),
            _buildSettingItem(Icons.smoking_rooms, "Тривалість звичайної перерви", "10", true, screenWidth),
          ],
        ),
      ],
    );
  }

  Widget _buildNarrowLayout(double screenWidth) {
    return Column(
      children: [
        _buildSettingItem(Icons.schedule, "Початок уроків о", "08:00", false, screenWidth),
        _buildSettingItem(Icons.cast_for_education, "Велика перерва після уроку №", "3", false, screenWidth),
        _buildSettingItem(Icons.emoji_food_beverage, "Тривалість великої перерви", "30", true, screenWidth),
        _buildSettingItem(Icons.smoking_rooms, "Тривалість звичайної перерви", "10", true, screenWidth),
      ],
    );
  }

  Widget _buildSettingItem(IconData icon, String title, String value, bool isMinutes, double screenWidth) {
    double iconSize = screenWidth * 0.021;
    iconSize = iconSize < 22 ? 22 : iconSize;

    Future<void> _showTimePicker(BuildContext context) async {
      final TimeOfDay initialTime = TimeOfDay(
        hour: int.parse(tempSettings[title]!.split(':')[0]),
        minute: int.parse(tempSettings[title]!.split(':')[1]),
      );

      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: initialTime,
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              timePickerTheme: TimePickerThemeData(
                backgroundColor: AppColors.white,
                hourMinuteTextColor: AppColors.carribbeanCurrent,
                dialHandColor: AppColors.carribbeanCurrent,
                dialBackgroundColor: AppColors.lightBlue,
              ),
            ),
            child: child!,
          );
        },
      );

      if (picked != null) {
        setState(() {
          tempSettings[title] = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
        });
      }
    }

    return Column(
      children: [
        Icon(icon, size: iconSize, color: AppColors.moonstone),
        SizedBox(height: 6),
        Text(title, style: AppTextStyles.h2),
        if (isEditing)
          Container(
            width: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (title == "Початок уроків о")
                  InkWell(
                    onTap: () => _showTimePicker(context),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.carribbeanCurrent),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        tempSettings[title]!,
                        style: AppTextStyles.h2.copyWith(color: Colors.yellow[800]),
                      ),
                    ),
                  )
                else
                  Flexible(
                    child: TextField(
                      textAlign: TextAlign.center,
                      style: AppTextStyles.h2.copyWith(color: Colors.yellow[800]),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      ),
                      controller: TextEditingController(text: tempSettings[title]),
                      onChanged: (value) {
                        tempSettings[title] = value;
                      },
                    ),
                  ),
                if (isMinutes)
                  Text(
                    " хв",
                    style: AppTextStyles.h2.copyWith(color: Colors.yellow[800]),
                  ),
              ],
            ),
          )
        else
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                settings[title]!,
                style: AppTextStyles.h2.copyWith(color: Colors.yellow[800]),
              ),
              if (isMinutes)
                Text(
                  " хв",
                  style: AppTextStyles.h2.copyWith(color: Colors.yellow[800]),
                ),
            ],
          ),
      ],
    );
  }
}
