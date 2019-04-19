import 'package:dev_rpg/src/shared_state/game/skill.dart';
import 'package:flutter/material.dart';

const Color contentColor = Color.fromRGBO(38, 38, 47, 1.0);
const Color modalBackgroundColor = Color.fromRGBO(241, 241, 241, 1.0);
const Color secondaryContentColor = Color.fromRGBO(111, 111, 118, 1.0);
const Color skillTextColor = Color.fromRGBO(5, 59, 73, 1.0);
const Color attentionColor = Color.fromRGBO(0, 152, 255, 1.0);
const Color disabledColor = Color.fromRGBO(116, 116, 126, 1.0);
const Color disabledTaskColor = Color.fromRGBO(38, 38, 47, 0.25);
const Color treeLineColor = Color.fromRGBO(201, 201, 201, 1.0);

const TextStyle contentSmallStyle = TextStyle(
  fontFamily: "MontserratRegular",
  fontSize: 14,
  color: secondaryContentColor,
);

const TextStyle contentStyle = TextStyle(
  fontFamily: "MontserratRegular",
  fontSize: 16,
  color: contentColor,
);

const TextStyle contentLargeStyle = TextStyle(
  fontFamily: "MontserratRegular",
  fontSize: 24,
  color: contentColor,
);

const TextStyle buttonTextStyle = TextStyle(
  fontFamily: "MontserratMedium",
  fontSize: 16,
  color: contentColor,
);

Map<Skill, Color> skillColor = {
  Skill.coding: const Color.fromRGBO(0, 179, 184, 1.0),
  Skill.engineering: const Color.fromRGBO(84, 114, 239, 1.0),
  Skill.ux: const Color.fromRGBO(184, 56, 72, 1.0),
  Skill.coordination: Colors.lightGreen
};
