import 'package:flutter/material.dart';

import '../style.dart';
import 'buttons/wide_button.dart';

class GameOver extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Material(
          child: Container(
            constraints: const BoxConstraints(minWidth: double.infinity),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    offset: const Offset(0.0, 100.0),
                    blurRadius: 100.0),
              ],
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("\"Spectacular!!!\"", style: contentLargeStyle),
                const SizedBox(height: 20.0),
                SizedBox(
                  height: 50,
                  child: Row(
                    children: [
                      Expanded(
                        child: WideButton(
                          onPressed: () => null,
                          paddingTweak: const EdgeInsets.only(right: -7.0),
                          background: const Color.fromRGBO(84, 114, 239, 1.0),
                          child: Text(
                            "MAIN MENU",
                            style: buttonTextStyle.apply(color: Colors.white),
                          ),
                        ),
                      ),
					  const SizedBox(width:10),
                      Expanded(
                        child: WideButton(
                          onPressed: () => null,
                          paddingTweak: const EdgeInsets.only(right: -7.0),
                          background: const Color.fromRGBO(236, 41, 117, 1.0),
                          child: Text(
                            "MAIN MENU",
                            style: buttonTextStyle.apply(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
