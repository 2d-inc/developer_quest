import 'package:flutter/widgets.dart';

class SphinxImage extends StatelessWidget {
  const SphinxImage();

  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/style_sphinx/sphinx.png');
  }
}

class SphinxWithoutGlassesImage extends StatelessWidget {
  const SphinxWithoutGlassesImage();

  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/style_sphinx/Sphinx_no_glasses@3x.png');
  }
}

class SphinxGlassesImage extends StatelessWidget {
  const SphinxGlassesImage();

  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/style_sphinx/normalized/sunglasses.png');
  }
}
