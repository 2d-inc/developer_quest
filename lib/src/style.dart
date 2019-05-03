import 'package:dev_rpg/src/shared_state/game/skill.dart';
import 'package:flutter/material.dart';

const Color contentColor = Color.fromRGBO(38, 38, 47, 1);
const Color modalBackgroundColor = Color.fromRGBO(241, 241, 241, 1);
const Color secondaryContentColor = Color.fromRGBO(111, 111, 118, 1);
const Color skillTextColor = Color.fromRGBO(5, 59, 73, 1);
const Color attentionColor = Color.fromRGBO(0, 152, 255, 1);
const Color disabledColor = Color.fromRGBO(116, 116, 126, 1);
const Color disabledTaskColor = Color.fromRGBO(38, 38, 47, 0.25);
const Color treeLineColor = Color.fromRGBO(215, 215, 215, 1);
const Color bugColor = Color.fromRGBO(236, 41, 117, 1);
const Color statsSeparatorColor = Color.fromRGBO(57, 57, 71, 1);
const double modalMaxWidth = 400;
const double wideLayoutThreshold = 500;
const double idealCharacterWidth = 165;
const double idealParticleSize = 10;

const TextStyle contentSmallStyle = TextStyle(
  fontFamily: 'MontserratRegular',
  fontSize: 14,
  color: secondaryContentColor,
);

final List<BoxShadow> themeTaskShadow = [
  BoxShadow(
    color: Colors.black.withOpacity(0.03),
    offset: const Offset(0, 10),
    blurRadius: 10,
    spreadRadius: 0,
  ),
];

const TextStyle contentStyle = TextStyle(
  fontFamily: 'MontserratRegular',
  fontSize: 16,
  color: Color.fromRGBO(38, 38, 47, 1),
);

const TextStyle contentLargeStyle = TextStyle(
  fontFamily: 'MontserratRegular',
  fontSize: 24,
  color: contentColor,
);

const TextStyle buttonTextStyle = TextStyle(
  fontFamily: 'MontserratMedium',
  fontSize: 16,
  color: contentColor,
);

Map<Skill, Color> skillColor = {
  Skill.coding: const Color.fromRGBO(0, 179, 184, 1),
  Skill.engineering: const Color.fromRGBO(84, 114, 239, 1),
  Skill.ux: const Color.fromRGBO(184, 56, 72, 1),
  Skill.coordination: Colors.lightGreen
};

Map<Skill, String> skillFlareIcon = {
  Skill.coding: 'assets/flare/CodeIcon.flr',
  Skill.engineering: 'assets/flare/EngineeringIcon.flr',
  Skill.ux: 'assets/flare/UxIcon.flr',
  Skill.coordination: 'assets/flare/CoordinationIcon.flr'
};

class MaterialContainer extends StatelessWidget {
  const MaterialContainer({this.child, this.color = Colors.black});
  final Widget child;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
    child: Container(
    decoration: BoxDecoration(
      boxShadow: themeTaskShadow,
      borderRadius: const BorderRadius.all(Radius.circular(9)),
      color: color,
    ),
    child: Material(
        type: MaterialType.transparency,
        borderRadius: const BorderRadius.all(Radius.circular(9)),
        clipBehavior: Clip.antiAlias,
        child: child),
    ),
    );
  }
}
