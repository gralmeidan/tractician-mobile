import 'package:flutter/material.dart';

import '../../../styles/styles.dart';

class ButtonCheckbox<T> extends StatelessWidget {
  final T value;
  final T? selected;
  final ValueChanged<T?> onChanged;
  final String label;
  final IconData icon;

  const ButtonCheckbox({
    required this.value,
    required this.selected,
    required this.onChanged,
    required this.label,
    required this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == selected;

    return TextButton(
      onPressed: () {
        onChanged(value == selected ? null : value);
      },
      style: TextButton.styleFrom(
        backgroundColor: isSelected ? AppColors.primary : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: BorderSide(
            color: isSelected ? AppColors.primary : AppColors.gray200,
          ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.white : AppColors.gray500,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: AppTextStyles.buttonSmall.copyWith(
              color: isSelected ? Colors.white : AppColors.gray500,
            ),
          ),
        ],
      ),
    );
  }
}
