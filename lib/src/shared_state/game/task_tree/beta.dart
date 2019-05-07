part of task_tree;

const _beta = TaskBlueprint('Beta', {Skill.coordination: 100},
    requirements: AllOf([
      _alpha,
      // Mascot & icon.
      AnyOf([_dinosaurMascot, _birdMascot, _catMascot]),
      // Design philosophy.
      AnyOf([_retroDesign, _scifiDesign, _mainstreamDesign]),
      // Color theme.
      AnyOf([_redTheme, _greenTheme, _blueTheme]),
    ]),
    priority: 100,
    coinReward: 800,
    miniGame: MiniGame.chomp);
