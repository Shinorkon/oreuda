import 'package:flutter/material.dart';
import '../constants/colors.dart';

class PactScreen extends StatelessWidget {
  const PactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'THE PACT',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: AppColors.holoCyan,
                  letterSpacing: 6,
                  shadows: [
                    Shadow(
                      color: AppColors.holoCyan.withAlpha(102),
                      blurRadius: 20,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Container(
                width: 60,
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      AppColors.holoCyan,
                      Colors.transparent,
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'By entering this contract, you acknowledge that the System will monitor your progress, assign quests calibrated to your capability, and deliver consequences for failure.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.systemSilver,
                  height: 1.7,
                ),
              ),

              const SizedBox(height: 32),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.slateSurface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _buildLaw('1', 'I will complete my assigned quests to the best of my ability.'),
                    const Divider(color: Colors.white10, height: 24),
                    _buildLaw('2', 'I accept that failure carries consequences, but recovery is always possible.'),
                    const Divider(color: Colors.white10, height: 24),
                    _buildLaw('3', 'I understand that growth requires consistency, not perfection.'),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.holoCyan,
                    foregroundColor: AppColors.black,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                  child: const Text(
                    'SIGN THE PACT',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 3,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'Decline',
                  style: TextStyle(
                    color: AppColors.mutedAsh,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLaw(String number, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          number,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: AppColors.holoCyan,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.systemSilver,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
