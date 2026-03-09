import 'package:flutter/material.dart';
import 'package:cineghar/features/booking/domain/entities/snack_entity.dart';
import 'package:cineghar/app/theme/app_colors.dart';

class SnackCard extends StatelessWidget {
  final dynamic snack; // Can be SnackItemEntity or SnackComboEntity
  final int quantity;
  final Function(int) onQuantityChanged;
  final bool isTablet;
  final bool isCombo;

  const SnackCard({
    super.key,
    required this.snack,
    required this.quantity,
    required this.onQuantityChanged,
    required this.isTablet,
    this.isCombo = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isCombo) {
      return _buildComboCard(snack as SnackComboEntity);
    } else {
      return _buildSnackItemCard(snack as SnackItemEntity);
    }
  }

  Widget _buildSnackItemCard(SnackItemEntity snack) {
    return Container(
      margin: EdgeInsets.all(isTablet ? 8 : 6),
      height: isTablet ? 280 : 240, // Fixed height to prevent layout issues
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Snack Image/Icon Section
          Container(
            height: isTablet ? 120 : 100, // Fixed height
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.warning.withOpacity(0.1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(isTablet ? 20 : 16),
                topRight: Radius.circular(isTablet ? 20 : 16),
              ),
            ),
            child: Center(
              child: Icon(
                Icons.fastfood,
                size: isTablet ? 36 : 32,
                color: AppColors.warning,
              ),
            ),
          ),
          
          // Snack Info Section
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(isTablet ? 12 : 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    snack.name,
                    style: TextStyle(
                      fontSize: isTablet ? 14 : 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  if (snack.description != null) ...[
                    SizedBox(height: isTablet ? 4 : 2),
                    Text(
                      snack.description!,
                      style: TextStyle(
                        fontSize: isTablet ? 10 : 8,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  
                  const Spacer(),
                  
                  // Price
                  Text(
                    'NPR ${snack.price}',
                    style: TextStyle(
                      fontSize: isTablet ? 14 : 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  
                  SizedBox(height: isTablet ? 8 : 4),
                  
                  // Quantity Selector
                  _buildCompactQuantitySelector(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComboCard(SnackComboEntity combo) {
    return Container(
      margin: EdgeInsets.all(isTablet ? 8 : 6),
      height: isTablet ? 280 : 240, // Fixed height to prevent layout issues
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.success.withOpacity(0.02),
            AppColors.success.withOpacity(0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
        border: Border.all(color: AppColors.success.withOpacity(0.2)),
        boxShadow: AppColors.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Combo Image/Icon Section with Discount Badge
          Container(
            height: isTablet ? 120 : 100, // Fixed height
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(isTablet ? 20 : 16),
                topRight: Radius.circular(isTablet ? 20 : 16),
              ),
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(
                    Icons.local_offer,
                    size: isTablet ? 36 : 32,
                    color: AppColors.success,
                  ),
                ),
                
                // Discount Badge
                if (combo.discountLabel != null)
                  Positioned(
                    top: isTablet ? 6 : 4,
                    right: isTablet ? 6 : 4,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 6 : 4,
                        vertical: isTablet ? 3 : 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        borderRadius: BorderRadius.circular(isTablet ? 10 : 8),
                      ),
                      child: Text(
                        combo.discountLabel!,
                        style: TextStyle(
                          fontSize: isTablet ? 8 : 6,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          // Combo Info Section
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(isTablet ? 12 : 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    combo.name,
                    style: TextStyle(
                      fontSize: isTablet ? 14 : 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  SizedBox(height: isTablet ? 4 : 2),
                  
                  Text(
                    combo.itemsPreview,
                    style: TextStyle(
                      fontSize: isTablet ? 10 : 8,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const Spacer(),
                  
                  // Price Section
                  Row(
                    children: [
                      Text(
                        'NPR ${combo.price}',
                        style: TextStyle(
                          fontSize: isTablet ? 14 : 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.success,
                        ),
                      ),
                      if (combo.originalPrice != null) ...[
                        SizedBox(width: isTablet ? 4 : 2),
                        Text(
                          'NPR ${combo.originalPrice}',
                          style: TextStyle(
                            fontSize: isTablet ? 10 : 8,
                            decoration: TextDecoration.lineThrough,
                            color: AppColors.textTertiary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                  
                  SizedBox(height: isTablet ? 8 : 4),
                  
                  // Quantity Selector
                  _buildCompactQuantitySelector(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactQuantitySelector() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Decrease button
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: quantity > 0 ? () => onQuantityChanged(quantity - 1) : null,
            borderRadius: BorderRadius.circular(isTablet ? 12 : 10),
            child: Container(
              width: isTablet ? 28 : 24,
              height: isTablet ? 28 : 24,
              decoration: BoxDecoration(
                color: quantity > 0 ? AppColors.error : AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(isTablet ? 12 : 10),
                border: Border.all(
                  color: quantity > 0 ? AppColors.error : AppColors.border,
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.remove,
                size: isTablet ? 14 : 12,
                color: quantity > 0 ? Colors.white : AppColors.textTertiary,
              ),
            ),
          ),
        ),
        
        SizedBox(width: isTablet ? 8 : 6),
        
        // Quantity
        Container(
          width: isTablet ? 32 : 28,
          height: isTablet ? 28 : 24,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(isTablet ? 8 : 6),
            border: Border.all(color: AppColors.border),
          ),
          child: Text(
            quantity.toString(),
            style: TextStyle(
              fontSize: isTablet ? 14 : 12,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        
        SizedBox(width: isTablet ? 8 : 6),
        
        // Increase button
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => onQuantityChanged(quantity + 1),
            borderRadius: BorderRadius.circular(isTablet ? 12 : 10),
            child: Container(
              width: isTablet ? 28 : 24,
              height: isTablet ? 28 : 24,
              decoration: BoxDecoration(
                color: AppColors.success,
                borderRadius: BorderRadius.circular(isTablet ? 12 : 10),
                boxShadow: AppColors.buttonShadow,
              ),
              child: Icon(
                Icons.add,
                size: isTablet ? 14 : 12,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
