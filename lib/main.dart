import 'package:flutter/material.dart';

void main() {
  runApp(const CalorieCalculatorApp());
}

class CalorieCalculatorApp extends StatelessWidget {
  const CalorieCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CalorieFlow',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF2C5364),
        scaffoldBackgroundColor: const Color(0xFF0F2027),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF6C63FF),
          secondary: Color(0xFF2C5364),
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
        _result = 'Daily calories to maintain: ${tdee.toStringAsFixed(0)}';
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
        title: const Text('CalorieFlow'),
        backgroundColor: const Color(0xFF203A43),
        elevation: 0,
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
              TextField(
                controller: _weightController, 
                decoration: const InputDecoration(labelText: 'Weight (kg)', border: OutlineInputBorder()), 
                keyboardType: TextInputType.number
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _heightController, 
                decoration: const InputDecoration(labelText: 'Height (cm)', border: OutlineInputBorder()), 
                keyboardType: TextInputType.number
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _ageController, 
                decoration: const InputDecoration(labelText: 'Age', border: OutlineInputBorder()), 
                keyboardType: TextInputType.number
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                value: _gender,
                items: ['Male', 'Female'].map((String val) => DropdownMenuItem(value: val, child: Text(val))).toList(),
                onChanged: (val) => setState(() => _gender = val!),
                decoration: const InputDecoration(labelText: 'Gender', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                value: _activityLevel,
                items: _activityMultipliers.keys.map((String val) => DropdownMenuItem(value: val, child: Text(val))).toList(),
                onChanged: (val) => setState(() => _activityLevel = val!),
                decoration: const InputDecoration(labelText: 'Activity Level', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _calculateCalories, 
                  child: const Text('CALCULATE', style: TextStyle(fontSize: 16))
                ),
              ),
              const SizedBox(height: 30),
              Text(
                _result, 
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)
              ),
            ],
          ),
        ),
      ),
    );
  }
}