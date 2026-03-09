import 'package:flutter/material.dart';
import 'package:cineghar/app/theme/app_colors.dart';
import '../../domain/entities/order_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderSuccessPage extends ConsumerWidget {
  final OrderEntity order;

  const OrderSuccessPage({super.key, required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.shortestSide > 600;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.4),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildTopBar(context, isTablet),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 40 : 20,
                        vertical: 20,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            color: AppColors.success,
                            size: isTablet ? 80 : 64,
                          ),
                          SizedBox(height: isTablet ? 24 : 16),
                          Text(
                            "Booking Confirmed!",
                            style: TextStyle(
                              fontSize: isTablet ? 32 : 26,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 1,
                            ),
                          ),
                          SizedBox(height: isTablet ? 12 : 8),
                          Text(
                            "Your ticket has been booked successfully",
                            style: TextStyle(
                              fontSize: isTablet ? 18 : 16,
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: isTablet ? 40 : 32),

                          /// THE TICKET
                          TicketWidget(
                            width:
                                isTablet ? 500 : MediaQuery.of(context).size.width * 0.9,
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Text(
                                      order.movieTitle ?? 'Unknown Movie',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: isTablet ? 24 : 20,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: _TicketData(
                                          title: 'Booking ID',
                                          data: order.purchaseOrderId,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Flexible(
                                        child: _TicketData(
                                          title: 'Seats',
                                          data: order.seats.join(', '),
                                          alignment: CrossAxisAlignment.end,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: _TicketData(
                                          title: 'Amount Paid',
                                          data: 'NPR ${order.amount}',
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Flexible(
                                        child: _TicketData(
                                          title: 'Date',
                                          data: _formatDate(order.createdAt),
                                          alignment: CrossAxisAlignment.end,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 32),
                                  const _DashSeparator(color: Colors.grey),
                                  const SizedBox(height: 32),
                                  Center(
                                    child: Column(
                                      children: [
                                        // Barcode visualization (drawn with Flutter primitives)
                                        _BarcodeWidget(data: order.id),
                                        const SizedBox(height: 8),
                                        Text(
                                          order.id.length > 20
                                              ? '${order.id.substring(0, 20)}...'
                                              : order.id,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey,
                                            letterSpacing: 1.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: isTablet ? 40 : 30),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.popUntil(context, (route) => route.isFirst);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: EdgeInsets.symmetric(
                                horizontal: isTablet ? 40 : 32,
                                vertical: isTablet ? 16 : 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              "Back to Home",
                              style: TextStyle(
                                fontSize: isTablet ? 18 : 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, bool isTablet) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 40 : 16,
        vertical: isTablet ? 16 : 12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
            icon: Icon(
              Icons.close,
              color: Colors.white,
              size: isTablet ? 32 : 28,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return "${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}";
  }
}

class _TicketData extends StatelessWidget {
  final String title;
  final String data;
  final CrossAxisAlignment alignment;

  const _TicketData({
    required this.title,
    required this.data,
    this.alignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          data,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        )
      ],
    );
  }
}

class _BarcodeWidget extends StatelessWidget {
  final String data;

  const _BarcodeWidget({required this.data});

  @override
  Widget build(BuildContext context) {
    // Deterministic stripe pattern from data, using flex to fill available width
    final barCount = 60;
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: List.generate(barCount, (i) {
          final charCode = data.isEmpty ? 65 : data.codeUnitAt(i % data.length);
          final isBlack = i % 2 == 0;
          final flex = (charCode + i) % 3 == 0 ? 2 : 1;
          return Expanded(
            flex: flex,
            child: Container(
              color: isBlack ? Colors.black87 : Colors.white,
            ),
          );
        }),
      ),
    );
  }
}

class _DashSeparator extends StatelessWidget {
  final double height;
  final Color color;

  const _DashSeparator({this.height = 1, this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 8.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
        );
      },
    );
  }
}

class TicketWidget extends StatelessWidget {
  final Widget child;
  final double width;

  const TicketWidget({super.key, required this.child, required this.width});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _TicketClipper(),
      child: Container(
        width: width,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: child,
      ),
    );
  }
}

class _TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    const radius = 16.0;
    const cutoutY = 0.65;

    path.lineTo(0.0, size.height * cutoutY - radius);
    path.arcToPoint(
      Offset(0.0, size.height * cutoutY + radius),
      radius: const Radius.circular(radius),
      clockwise: true,
    );
    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, size.height * cutoutY + radius);
    path.arcToPoint(
      Offset(size.width, size.height * cutoutY - radius),
      radius: const Radius.circular(radius),
      clockwise: true,
    );
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
