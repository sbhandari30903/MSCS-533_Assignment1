import 'package:flutter/material.dart';
import 'conversion_logic.dart';

// Main entry point of the application
void main() {
  runApp(const MyApp());
}

// Root widget of the application
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unit Converter',
      // Configure the app theme with a blue color scheme
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 10, 130, 228),
        ),
        useMaterial3: true,
      ),
      home: const ConversionPage(),
    );
  }
}

// Main conversion page widget that maintains state
class ConversionPage extends StatefulWidget {
  const ConversionPage({super.key});

  @override
  State<ConversionPage> createState() => _ConversionPageState();
}

// State class for the conversion page
class _ConversionPageState extends State<ConversionPage> {
  // Initial values for conversion units and result
  String selectedMeasure = 'Length';
  String fromUnit = 'Kilometers';
  String toUnit = 'Miles';
  String result = '';
  // Controller for the input text field
  final TextEditingController _inputController = TextEditingController();

  // Helper function to get all available units across all measurement types
  List<String> getAllUnits() {
    List<String> allUnits = [];
    measures.forEach((key, value) {
      if (key != 'All') {
        allUnits.addAll(value);
      }
    });
    return allUnits;
  }

  // Helper function to determine the measurement type for a given unit
  String getMeasureType(String unit) {
    String type = '';
    measures.forEach((key, value) {
      if (key != 'All' && value.contains(unit)) {
        type = key;
      }
    });
    return type;
  }

  // Handler for when the 'From' unit changes
  void onFromUnitChanged(String? newValue) {
    if (newValue == null) return;
    setState(() {
      String newMeasureType = getMeasureType(newValue);
      fromUnit = newValue;

      // Update 'To' unit if it's not compatible with the new 'From' unit
      if (getMeasureType(toUnit) != newMeasureType) {
        toUnit = measures[newMeasureType]!.firstWhere(
          (unit) => unit != newValue,
        );
      }
      selectedMeasure = newMeasureType;
      result = '';
    });
  }

  // Handler for when the 'To' unit changes
  void onToUnitChanged(String? newValue) {
    if (newValue == null) return;
    // Ensure 'To' unit is compatible with 'From' unit
    if (getMeasureType(newValue) != getMeasureType(fromUnit)) return;
    setState(() {
      toUnit = newValue;
      result = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar with centered title and blue background
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Measures Converter',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 8, 133, 236),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Input value card
            Text(
              'Value',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.grey, // Changed text color to grey
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _inputController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.left, // Changed from center to left
              style: const TextStyle(
                fontSize: 24,
                color: Color.fromARGB(
                  255,
                  8,
                  133,
                  236,
                ), // Added blue color for input text
              ),
              decoration: InputDecoration(
                border: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: const Color.fromARGB(255, 8, 133, 236),
                  ),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: const Color.fromARGB(255, 8, 133, 236),
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: const Color.fromARGB(255, 8, 133, 236),
                    width: 2,
                  ),
                ),
                hintText: 'Enter value to convert',
                hintStyle: TextStyle(
                  color: Colors.grey,
                ), // Optional: style for hint text
              ),
            ),
            const SizedBox(height: 20),
            // Unit selection card
            Text(
              'From',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.grey, // Changed text color to grey
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: fromUnit,
              isExpanded: true,
              alignment: Alignment.centerLeft, // Change to left alignment
              style: const TextStyle(
                fontSize: 18,
                color: Color.fromARGB(255, 8, 133, 236), // Add blue color
              ),
              items:
                  getAllUnits().map((String unit) {
                    return DropdownMenuItem<String>(
                      value: unit,
                      alignment:
                          Alignment.centerLeft, // Change to left alignment
                      child: Text(unit),
                    );
                  }).toList(),
              onChanged: onFromUnitChanged,
            ),
            const SizedBox(height: 20),
            Text(
              'To',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.grey, // Changed text color to grey
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: toUnit,
              isExpanded: true,
              alignment: Alignment.centerLeft, // Change to left alignment
              style: const TextStyle(
                fontSize: 18,
                color: Color.fromARGB(255, 8, 133, 236), // Add blue color
              ),
              items:
                  measures[getMeasureType(fromUnit)]?.map((String unit) {
                    return DropdownMenuItem<String>(
                      value: unit,
                      alignment:
                          Alignment.centerLeft, // Change to left alignment
                      child: Text(unit),
                    );
                  }).toList(),
              onChanged: onToUnitChanged,
            ),
            const SizedBox(height: 20),
            // Convert button
            Center(
              child: SizedBox(
                width: 80, // Reduced width to fit text only
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  onPressed: () {
                    double? input = double.tryParse(_inputController.text);
                    if (input != null) {
                      setState(() {
                        double convertedValue = convert(
                          getMeasureType(fromUnit),
                          fromUnit,
                          toUnit,
                          input,
                        );
                        result = formatResult(convertedValue);
                      });
                    }
                  },
                  child: const Text('Convert', style: TextStyle(fontSize: 18)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Result display card
            if (result.isNotEmpty)
              Text(
                '${double.parse(_inputController.text)} $fromUnit are $result $toUnit',
                style: Theme.of(
                  context,
                ).textTheme.headlineSmall?.copyWith(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}
