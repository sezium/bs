import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hoverables/hoverables.dart';
import 'package:bs/core/widgets/colors.dart';

class TrainingCard extends StatelessWidget {
  const TrainingCard({
    super.key,
    required this.title,
    required this.label,
    this.color,
    this.assetsPath,
    required this.route,
  });

  final String title;
  final String label;
  final Color? color;
  final String? assetsPath;
  final String route;

  @override
  Widget build(BuildContext context) {
    return HoverBuilder(
      builder: (context, hovering, child) {
        return AnimatedSlide(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          offset: hovering ? const Offset(0, -0.03) : Offset.zero,
          child: child,
        );
      },
      child: GestureDetector(
        onTap: () => context.push(route),
        child: Container(
          height: 200,
          width: 300,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: color?.withAlpha(63),
            border: Border.all(
              color: BsColors.grey,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    flex: 5,
                    child: assetsPath != null
                        ? Center(
                            child: Image.asset(
                              assetsPath!,
                              fit: BoxFit.contain,
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      width: double.infinity,
                      color: BsColors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 20,
                              color: color,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            label,
                            style: TextStyle(
                              fontSize: 12,
                              color: BsColors.black,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: 2,
                  color: color ?? BsColors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}