import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Widget getBackButton(BuildContext context, Function() onPressed) {
  return SizedBox(
    height: 50,
    width: 50,
    child: IconButton(
      onPressed: onPressed,
      icon: SvgPicture.string(
        '''<svg width="40" height="40" viewBox="0 0 40 40" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <rect x="0.5" y="0.5" width="39" height="39" rx="19.5" stroke="#F3F3F3"/>
                    <path d="M18 16L14 20M14 20L18 24M14 20L26 20" stroke="#047CEC" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                    </svg>
                    ''',
      ),
    ),
  );
}
