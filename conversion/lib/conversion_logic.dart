final Map<String, List<String>> measures = {
  'All': [
    'Kilometers',
    'Miles',
    'Meters',
    'Yards',
    'Feet',
    'Kilograms',
    'Pounds',
    'Grams',
    'Ounces',
    'Celsius',
    'Fahrenheit',
    'Kelvin',
  ],
  'Length': ['Kilometers', 'Miles', 'Meters', 'Yards', 'Feet'], // Added Feet
  'Weight': ['Kilograms', 'Pounds', 'Grams', 'Ounces'],
  'Temperature': ['Celsius', 'Fahrenheit', 'Kelvin'],
};

// Helper function to get available "to" units
List<String> getToUnits(String measure, String fromUnit) {
  final availableUnits = measures[measure] ?? [];
  return availableUnits.where((unit) => unit != fromUnit).toList();
}

double convert(String measure, String from, String to, double value) {
  // Determine the measure type based on the units
  String measureType = '';
  measures.forEach((key, units) {
    if (units.contains(from) && units.contains(to)) {
      measureType = key;
    }
  });

  switch (measureType) {
    case 'Length':
      return convertLength(from, to, value);
    case 'Weight':
      return convertWeight(from, to, value);
    case 'Temperature':
      return convertTemperature(from, to, value);
    default:
      return value;
  }
}

// Update the convertLength function to handle Feet
double convertLength(String from, String to, double value) {
  // Convert to meters first (base unit)
  double inMeters;
  switch (from) {
    case 'Kilometers':
      inMeters = value * 1000;
      break;
    case 'Miles':
      inMeters = value * 1609.34;
      break;
    case 'Yards':
      inMeters = value * 0.9144;
      break;
    case 'Feet':
      inMeters = value * 0.3048; // Added Feet conversion
      break;
    case 'Meters':
      inMeters = value;
      break;
    default:
      return value;
  }

  // Convert from meters to target unit
  switch (to) {
    case 'Kilometers':
      return inMeters / 1000;
    case 'Miles':
      return inMeters / 1609.34;
    case 'Yards':
      return inMeters / 0.9144;
    case 'Feet':
      return inMeters / 0.3048; // Added Feet conversion
    case 'Meters':
      return inMeters;
    default:
      return value;
  }
}

double convertWeight(String from, String to, double value) {
  // Convert to grams first
  double inGrams;
  switch (from) {
    case 'Kilograms':
      inGrams = value * 1000;
    case 'Pounds':
      inGrams = value * 453.592;
    case 'Ounces':
      inGrams = value * 28.3495;
    case 'Grams':
      inGrams = value;
    default:
      return value;
  }

  // Convert from grams to target unit
  switch (to) {
    case 'Kilograms':
      return inGrams / 1000;
    case 'Pounds':
      return inGrams / 453.592;
    case 'Ounces':
      return inGrams / 28.3495;
    case 'Grams':
      return inGrams;
    default:
      return value;
  }
}

double convertTemperature(String from, String to, double value) {
  // Convert to Celsius first (base unit)
  double inCelsius;
  switch (from) {
    case 'Fahrenheit':
      inCelsius = (value - 32) * 5 / 9;
      break;
    case 'Kelvin':
      inCelsius = value - 273.15;
      break;
    case 'Celsius':
      inCelsius = value;
      break;
    default:
      return value;
  }

  // Convert from Celsius to target unit
  switch (to) {
    case 'Fahrenheit':
      return (inCelsius * 9 / 5) + 32;
    case 'Kelvin':
      return inCelsius + 273.15;
    case 'Celsius':
      return inCelsius;
    default:
      return value;
  }
}

// Format the result to a reasonable number of decimal places
String formatResult(double value) {
  if (value.abs() < 0.000001) {
    return '0';
  }
  return value
      .toStringAsFixed(6)
      .replaceAll(RegExp(r'0*$'), '')
      .replaceAll(RegExp(r'\.$'), '');
}
