import 'package:flutter/material.dart';
import 'package:mobile_guitar_project/styles/colors.dart';
import 'package:mobile_guitar_project/styles/constants.dart';

@immutable
class FormHeader extends StatelessWidget {
  const FormHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      decoration:  BoxDecoration(
        color: Theme.of(context).unselectedWidgetColor,
        image: DecorationImage(
          fit: BoxFit.fitWidth,
          image: AssetImage('assets/img/icone.png'),
        )
      ),
      child:Row(
        children: [
          Text(
            'GuitarWatch',
            style: kLargeTitleStyle.copyWith(color: kDarkTextColor),

          ),
          Spacer(),
        ],
      ),
    );

  }
}
