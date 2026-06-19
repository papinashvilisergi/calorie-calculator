import 'package:flutter/material.dart';

void main() {
  runApp(const CalorieCalculatorApp());
}

class CalorieCalculatorApp extends StatelessWidget {
  const CalorieCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calorie Calculator',
      theme: ThemeData(primarySwatch: Colors.blue),
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

  // Activity multipliers
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
        _result = 'Daily calories to maintain weight: ${tdee.toStringAsFixed(0)}';
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
      appBar: AppBar(title: const Text('Calorie Calculator')),
      body: SingleChildScrollView( // Added scroll for smaller screens
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _weightController, decoration: const InputDecoration(labelText: 'Weight (kg)'), keyboardType: TextInputType.number),
            TextField(controller: _heightController, decoration: const InputDecoration(labelText: 'Height (cm)'), keyboardType: TextInputType.number),
            TextField(controller: _ageController, decoration: const InputDecoration(labelText: 'Age'), keyboardType: TextInputType.number),
            DropdownButtonFormField<String>(
              value: _gender,
              items: ['Male', 'Female'].map((String value) => DropdownMenuItem(value: value, child: Text(value))).toList(),
              onChanged: (val) => setState(() => _gender = val!),
              decoration: const InputDecoration(labelText: 'Gender'),
            ),
            DropdownButtonFormField<String>(
              value: _activityLevel,
              items: _activityMultipliers.keys.map((String value) => DropdownMenuItem(value: value, child: Text(value))).toList(),
              onChanged: (val) => setState(() => _activityLevel = val!),
              decoration: const InputDecoration(labelText: 'Activity Level'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _calculateCalories, child: const Text('Calculate')),
            const SizedBox(height: 20),
            Text(_result, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}