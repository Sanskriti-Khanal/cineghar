import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cineghar/app/theme/app_colors.dart';
import 'package:cineghar/core/utils/proximity_gesture_detector.dart';
import 'package:cineghar/features/orders/presentation/providers/orders_providers.dart';

class TicketCarouselPage extends ConsumerStatefulWidget {
  const TicketCarouselPage({super.key});

  @override
  ConsumerState<TicketCarouselPage> createState() => _TicketCarouselPageState();
}

class _TicketCarouselPageState extends ConsumerState<TicketCarouselPage> {
  final PageController _pageController = PageController();
  final ScrollController _scrollController = ScrollController();
  late final ProximityGestureDetector _gestureDetector;

  @override
  void initState() {
    super.initState();
    _gestureDetector = ProximityGestureDetector();
    _gestureDetector.gestures.listen(_onGestureDetected);
    _gestureDetector.start();

    // Fetch orders if not already loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(orderHistoryViewModelProvider.notifier).fetchMyOrders();
    });
  }

  @override
  void dispose() {
    _gestureDetector.dispose();
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onGestureDetected(ProximityGesture gesture) {
    if (!mounted) return;

    switch (gesture) {
      case ProximityGesture.swipeNext:
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        _showGestureFeedback("Next Ticket (1 Wave)");
        break;
      case ProximityGesture.swipePrevious:
        _pageController.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        _showGestureFeedback("Previous Ticket (2 Waves)");
        break;
      case ProximityGesture.scrollDown:
        _scrollController.animateTo(
          _scrollController.offset + 100,
          duration: const Duration(milliseconds: 300),
          curve: Curves.linear,
        );
        _showGestureFeedback("Scroll Down (3 Waves)");
        break;
      case ProximityGesture.scrollUp:
        _scrollController.animateTo(
          _scrollController.offset - 100,
          duration: const Duration(milliseconds: 300),
          curve: Curves.linear,
        );
        _showGestureFeedback("Scroll Up (4 Waves)");
        break;
      case ProximityGesture.holdDismiss:
        Navigator.of(context).pop();
        _showGestureFeedback("Dismissing (Hold)");
        break;
      case ProximityGesture.none:
        break;
    }
  }

  void _showGestureFeedback(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(orderHistoryViewModelProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Gesture Ticket Preview"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: orderState.orders.isEmpty
          ? const Center(child: Text("No tickets to display", style: TextStyle(color: Colors.white)))
          : Column(
              children: [
                const SizedBox(height: 10),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: orderState.orders.length,
                    itemBuilder: (context, index) {
                      final order = orderState.orders[index];
                      return Center(
                        child: Container(
                          width: 300,
                          height: 500,
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.3),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              )
                            ],
                          ),
                          child: SingleChildScrollView(
                            controller: index == _pageController.page?.round() ? _scrollController : null,
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              children: [
                                const Icon(Icons.confirmation_number, size: 60, color: AppColors.primary),
                                const SizedBox(height: 20),
                                Text(
                                  order.movieTitle ?? "Unknown",
                                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 10),
                                Text("Amount: NPR ${order.amount}"),
                                const SizedBox(height: 20),
                                const Divider(),
                                const SizedBox(height: 20),
                                const Text(
                                  "Scroll this area using 3 (Down) or 4 (Up) waves. Wave near the top sensor of your phone.",
                                  style: TextStyle(fontSize: 14, color: Colors.grey),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 400), // Adding space to test scrolling
                                const Text("End of Ticket Details"),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
    );
  }
}
