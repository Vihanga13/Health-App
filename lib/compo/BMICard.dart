import 'package:flutter/material.dart';

class BMICard extends StatelessWidget {
  final double height; // height in cm
  final double weight; // weight in kg
  final Color primaryColor;
  final bool showDetails;

  const BMICard({
    Key? key,
    required this.height,
    required this.weight,
    this.primaryColor = const Color(0xFF86BF3E),
    this.showDetails = true,
  }) : super(key: key);

  double calculateBMI() {
    return weight / ((height / 100) * (height / 100));
  }

  String getBMIStatus(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Overweight';
    return 'Obese';
  }

  Color getBMIStatusColor(String status) {
    switch (status) {
      case 'Underweight':
        return Colors.orange;
      case 'Normal':
        return Colors.green;
      case 'Overweight':
        return Colors.orange;
      case 'Obese':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  double getBMIProgressValue(double bmi) {
    if (bmi < 18.5) return 0.2;
    if (bmi < 25) return 0.5;
    if (bmi < 30) return 0.75;
    return 1.0;
  }

  String getBMIDescription(String status) {
    switch (status) {
      case 'Underweight':
        return 'You may need to gain some weight. Consult a healthcare provider.';
      case 'Normal':
        return 'You have a healthy weight. Keep maintaining it!';
      case 'Overweight':
        return 'You may need to lose some weight. Consider a healthy diet and exercise.';
      case 'Obese':
        return 'It\'s recommended to consult a healthcare provider for weight management.';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    double bmi = calculateBMI();
    String status = getBMIStatus(bmi);
    Color statusColor = getBMIStatusColor(status);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // Main BMI Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  primaryColor.withOpacity(0.8),
                  primaryColor,
                ],
              ),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Your BMI',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          bmi.toStringAsFixed(1),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        status,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildRangeLabel('Underweight', '< 18.5'),
                        _buildRangeLabel('Normal', '18.5-24.9'),
                        _buildRangeLabel('Overweight', '25-29.9'),
                        _buildRangeLabel('Obese', '≥ 30'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: getBMIProgressValue(bmi),
                      backgroundColor: Colors.white.withOpacity(0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Details Section (Optional)
          if (showDetails) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 15,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildDetailRow('Height', '${height.toStringAsFixed(1)} cm'),
                  const SizedBox(height: 12),
                  _buildDetailRow('Weight', '${weight.toStringAsFixed(1)} kg'),
                  const Divider(height: 24),
                  Text(
                    getBMIDescription(status),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRangeLabel(String label, String range) {
    return Column(
      children: [
        Text(
          range,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
