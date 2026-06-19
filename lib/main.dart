import 'package:flutter/material.dart';

void main() {
  runApp(const CalorieFlowApp());
}

class CalorieFlowApp extends StatelessWidget {
  const CalorieFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CalorieFlow',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C63FF),
          brightness: Brightness.dark,
        ),
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  String _gender = 'Male';
  String _activityLevel = 'Sedentary';
  String _result = '';

  final Map<String, double> _activityMultipliers = {
    'Sedentary': 1.2,
    'Lightly Active': 1.375,
    'Moderately Active': 1.55,
    'Very Active': 1.725,
  };

  void _calculateCalories() {
    double weight = double.tryParse(_weightController.text) ?? 0;
    double height = double.tryParse(_heightController.text) ?? 0;
    int age = int.tryParse(_ageController.text) ?? 0;

    if (weight > 0 && height > 0 && age > 0) {
      double bmr;
      if (_gender == 'Male') {
        bmr = (10 * weight) + (6.25 * height) - (5 * age) + 5;
      } else {
        bmr = (10 * weight) + (6.25 * height) - (5 * age) - 161;
      }

      double tdee = bmr * (_activityMultipliers[_activityLevel] ?? 1.2);

      setState(() {
        _result = 'Daily goal: ${tdee.toStringAsFixed(0)} kcal';
      });
    } else {
      setState(() {
        _result = 'Please enter valid data';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CalorieFlow', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color(0xFF203A43),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              _inputField(_weightController, 'Weight (kg)', Icons.scale),
              const SizedBox(height: 15),
              _inputField(_heightController, 'Height (cm)', Icons.height),
              const SizedBox(height: 15),
              _inputField(_ageController, 'Age', Icons.cake),
              const SizedBox(height: 15),
              _dropdown('Gender', _gender, ['Male', 'Female'], Icons.people),
              const SizedBox(height: 15),
              _dropdown('Activity Level', _activityLevel, _activityMultipliers.keys.toList(), Icons.fitness_center),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: FilledButton(
                  onPressed: _calculateCalories,
                  child: const Text('CALCULATE', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 30),
              Text(
                _result,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputField(TextEditingController controller, String label, IconData icon) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
      ),
    );
  }

  Widget _dropdown(String label, String value, List<String> items, IconData icon) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items.map((val) => DropdownMenuItem(value: val, child: Text(val))).toList(),
      onChanged: (val) => setState(() {
        if (label == 'Gender') _gender = val!;
        if (label == 'Activity Level') _activityLevel = val!;
      }),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
      ),
    );
  }
}