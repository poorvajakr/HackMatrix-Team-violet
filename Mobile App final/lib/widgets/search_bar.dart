import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class CustomSearchBar extends StatefulWidget {
  final String hint;
  final Function(String) onSubmitted;
  final Function(String)? onChanged;

  const CustomSearchBar({
    super.key,
    required this.hint,
    required this.onSubmitted,
    this.onChanged,
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final TextEditingController _controller = TextEditingController();
  bool _focused = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (value) => setState(() => _focused = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: AppColors.surfaceAlt,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: _focused ? AppColors.primary : AppColors.border,
            width: _focused ? 1.3 : 1,
          ),
          boxShadow: _focused
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    blurRadius: 18,
                    spreadRadius: 1,
                  ),
                ]
              : const [],
        ),
        child: TextField(
          controller: _controller,
          textInputAction: TextInputAction.search,
          style: const TextStyle(color: AppColors.text, fontSize: 14),
          decoration: InputDecoration(
            filled: false,
            hintText: widget.hint,
            hintStyle: const TextStyle(color: AppColors.muted),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            prefixIcon: const Icon(Icons.search_rounded, color: AppColors.muted),
            suffixIcon: _controller.text.isEmpty
                ? null
                : IconButton(
                    tooltip: 'Clear',
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () {
                      _controller.clear();
                      setState(() {});
                      widget.onChanged?.call('');
                      widget.onSubmitted('');
                    },
                  ),
          ),
          onSubmitted: widget.onSubmitted,
          onChanged: (value) {
            setState(() {});
            widget.onChanged?.call(value);
          },
        ),
      ),
    );
  }
}
