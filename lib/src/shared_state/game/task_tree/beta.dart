part of task_tree;

const _beta = TaskBlueprint(
  "Beta",
  {Skill.coordination: 100},
  requirements: AllOf([
    _alpha,
    // Mascot & icon.
    AnyOf([_dinosaurMascot, _birdMascot, _catMascot]),
    // Design philosophy.
    AnyOf([_retroDesign, _scifiDesign, _mainstreamDesign]),
    // Color theme.
    AnyOf([_redTheme, _greenTheme, _blueTheme]),
    // An important feature.
    AnyOf([
      _advancedMotionDesign,
      _accessibility,
      _internationalization,
      _animatedGifSupport,
      _imageFilters,
      _memeGenerator,
      _arMessages
    ]),
  ]),
);
