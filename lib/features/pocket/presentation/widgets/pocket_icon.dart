import 'package:dompet/core/constants/pocket_color.dart';
import 'package:dompet/core/enum/category.dart';
import 'package:dompet/features/pocket/domain/forms/pocket_create_form.dart';
import 'package:flutter/material.dart';

class PocketIcon extends StatelessWidget {
  final PocketCreateForm form;
  final bool hideEditIcon;
  const PocketIcon({super.key, required this.form, this.hideEditIcon = false});

  PocketColor? get color => form.colorValue;
  Category? get icon => form.iconValue;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 96,
          width: 96,
          decoration: BoxDecoration(
            color: color?.withValues(alpha: 0.25),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              icon?.icon ?? Icons.question_mark,
              color: color,
              size: 48,
            ),
          ),
        ),
        // if (!hideEditIcon)
        //   Positioned(
        //     bottom: 0,
        //     right: 0,
        //     child: Container(
        //       height: 32,
        //       width: 32,
        //       decoration: BoxDecoration(
        //         color: Colors.black,
        //         shape: BoxShape.circle,
        //       ),
        //       child: Center(
        //         child: Icon(
        //           Icons.edit_rounded,
        //           color: Colors.amber,
        //           size: 20,
        //         ),
        //       ),
        //     ),
        //   )
      ],
    );
  }
}
