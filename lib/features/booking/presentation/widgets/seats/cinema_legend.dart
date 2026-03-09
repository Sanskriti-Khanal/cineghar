import 'package:flutter/material.dart';
import 'package:cineghar/app/theme/app_colors.dart';

class CinemaLegend extends StatelessWidget {
  const CinemaLegend({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isTablet = size.shortestSide > 600;

    return Container(
      padding: EdgeInsets.all(isTablet ? 20 : 16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Seat Types
          Text(
            'SEAT TYPES',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: isTablet ? 14 : 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
            ),
          ),
          SizedBox(height: isTablet ? 16 : 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _LegendItem(
                color: Colors.blue.shade600,
                label: 'Standard',
                price: '\$10',
              ),
              _LegendItem(
                color: Colors.amber.shade600,
                label: 'Premium',
                price: '\$15',
              ),
              _LegendItem(
                color: Colors.purple.shade600,
                label: 'VIP',
                price: '\$25',
              ),
            ],
          ),
          SizedBox(height: isTablet ? 20 : 16),
          
          // Divider
          Container(
            height: 1,
            color: Colors.white.withOpacity(0.2),
          ),
          SizedBox(height: isTablet ? 16 : 12),
          
          // Seat Status
          Text(
            'SEAT STATUS',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: isTablet ? 14 : 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
            ),
          ),
          SizedBox(height: isTablet ? 16 : 12),
          Wrap(
            spacing: isTablet ? 16 : 12,
            runSpacing: isTablet ? 12 : 8,
            alignment: WrapAlignment.center,
            children: [
              _LegendItem(
                color: Colors.green.shade600,
                label: 'Available',
                price: '',
              ),
              _LegendItem(
                color: Colors.orange,
                label: 'Selected',
                price: '',
              ),
              _LegendItem(
                color: Colors.red.shade600,
                label: 'Booked',
                price: '',
              ),
              _LegendItem(
                color: Colors.orange.shade400,
                label: 'On Hold',
                price: '',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final String price;

  const _LegendItem({
    required this.color,
    required this.label,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isTablet = size.shortestSide > 600;

    return Column(
      children: [
        Container(
          width: isTablet ? 32 : 24,
          height: isTablet ? 32 : 24,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.4),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: isTablet ? 12 : 10,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (price.isNotEmpty) ...[
          SizedBox(height: 2),
          Text(
            price,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: isTablet ? 10 : 8,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}
