import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WhiteGreenBMIPage extends StatefulWidget {
  const WhiteGreenBMIPage({Key? key}) : super(key: key);

  @override
  _WhiteGreenBMIPageState createState() => _WhiteGreenBMIPageState();
}

class _WhiteGreenBMIPageState extends State<WhiteGreenBMIPage> 
    with SingleTickerProviderStateMixin {
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  double? _bmi;
  String _bmiCategory = '';
  bool _isLoading = false;

  // Color Scheme with White Background
  static const Color primaryGreen = Color(0xFF86BF3E);
  static const Color lightGreen = Color(0xFFF7FAF2);
  static const Color textGreen = Color(0xFF2C3E1B);
  static const Color backgroundColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _calculateBMI() {
    if (_heightController.text.isNotEmpty && _weightController.text.isNotEmpty) {
      double height = double.parse(_heightController.text) / 100;
      double weight = double.parse(_weightController.text);
      
      setState(() {
        _bmi = weight / (height * height);
        _updateBMICategory();
      });
    }
  }

  void _updateBMICategory() {
    if (_bmi == null) return;

    setState(() {
      if (_bmi! < 18.5) {
        _bmiCategory = 'Underweight';
      } else if (_bmi! < 24.9) {
        _bmiCategory = 'Normal Weight';
      } else if (_bmi! < 29.9) {
        _bmiCategory = 'Overweight';
      } else {
        _bmiCategory = 'Obese';
      }
    });
  }

  Future<void> _handleDonePress() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate some processing
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });

    // Navigate back or to next screen
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: const Text(
          'BMI Calculator',
          style: TextStyle(
            color: textGreen,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: 100,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Input Section
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: primaryGreen.withOpacity(0.2),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: primaryGreen.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInputField(
                          controller: _heightController,
                          label: 'Height',
                          hint: 'Enter your height',
                          suffix: 'cm',
                          icon: Icons.height_rounded,
                        ),
                        const SizedBox(height: 20),
                        _buildInputField(
                          controller: _weightController,
                          label: 'Weight',
                          hint: 'Enter your weight',
                          suffix: 'kg',
                          icon: Icons.monitor_weight_rounded,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Result Section
                  if (_bmi != null) ...[
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: primaryGreen,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Your BMI',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Text(
                                  _bmiCategory,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            _bmi!.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 48,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],

                  // BMI Scale
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: primaryGreen.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'BMI Categories',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textGreen,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildBMIScaleItem('Underweight', '< 18.5'),
                        _buildBMIScaleItem('Normal', '18.5 - 24.9'),
                        _buildBMIScaleItem('Overweight', '25.0 - 29.9'),
                        _buildBMIScaleItem('Obese', '≥ 30.0', isLast: true),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Done Button
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleDonePress,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Done',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required String suffix,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: textGreen,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: lightGreen,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (value) => _calculateBMI(),
            style: TextStyle(
              color: textGreen,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: textGreen.withOpacity(0.5),
              ),
              suffixText: suffix,
              suffixStyle: TextStyle(
                color: primaryGreen,
                fontWeight: FontWeight.w600,
              ),
              prefixIcon: Icon(
                icon,
                color: primaryGreen,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBMIScaleItem(String category, String range, {bool isLast = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: !isLast
            ? Border(
                bottom: BorderSide(
                  color: primaryGreen.withOpacity(0.1),
                ),
              )
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            category,
            style: TextStyle(
              fontSize: 16,
              color: textGreen,
              fontWeight: FontWeight.w500,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: lightGreen,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              range,
              style: TextStyle(
                color: primaryGreen,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}