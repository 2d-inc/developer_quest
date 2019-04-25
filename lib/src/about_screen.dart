import 'package:dev_rpg/src/style.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  static const double _horizontalPadding = 33.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: contentColor,
        child: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top,
            bottom: MediaQuery.of(context).padding.bottom + 33,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: ButtonTheme(
                  minWidth: 0.0,
                  child: FlatButton(
                    padding: const EdgeInsets.all(0.0),
                    shape: null,
                    onPressed: () => Navigator.pop(context, null),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: _horizontalPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 41.0),
                      const Text(
                        "FLUTTER\nDEVELOPER QUEST",
                        style: TextStyle(
                            fontFamily: "RobotoCondensedBold",
                            fontSize: 30.0,
                            letterSpacing: 5),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        height: 2,
                        color: Colors.white.withOpacity(0.19),
                      ),
                      const SizedBox(height: 27),
                      Text(
                        "V 1.0",
                        style: buttonTextStyle.apply(
                            fontSizeDelta: -4,
                            color: Colors.white.withOpacity(0.5)),
                      ),
                      const SizedBox(height: 23),
                      const Text(
                        "Flutter Developer Quest is built with Flutter by 2Dimensions.",
                        style: TextStyle(
                            fontFamily: "RobotoRegular", fontSize: 20.0),
                      ),
                      const SizedBox(height: 23),
                      const Text(
                        "The graphics and animations were created using Flare.",
                        style: TextStyle(
                            fontFamily: "RobotoRegular", fontSize: 20.0),
                      ),
                      Expanded(child: Container()),
                      const Text(
                        "DESIGNED BY",
                        style: TextStyle(
                            fontFamily: "MontserratMedium", fontSize: 12.0),
                      ),
                      const SizedBox(height: 11),
                      Image.asset('assets/images/2dimensions.png'),
                      const SizedBox(height: 32),
                      const Text(
                        "BUILT WITH",
                        style: TextStyle(
                            fontFamily: "MontserratMedium", fontSize: 12.0),
                      ),
                      const SizedBox(height: 11),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset("assets/images/flutter_logo.png",
                              height: 45.0, width: 37.0),
                          Container(
                            margin: const EdgeInsets.only(left: 5.0),
                            child: Text(
                              "Flutter",
                              style: TextStyle(
                                  fontSize: 26.0,
                                  color: Colors.white.withOpacity(0.85)),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
