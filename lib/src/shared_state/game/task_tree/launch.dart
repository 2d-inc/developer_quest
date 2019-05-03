part of task_tree;

const _launch = TaskBlueprint('1.0', {Skill.coordination: 100},
    requirements: AllOf([
      _beta,
      // At least one post-beta polish feature.
      AnyOf([
        _backendPerformanceOptimization,
        _backendScalabilityOptimization,
        _prelaunchMarketing,
        _backendHardening,
        _uiPerformanceOptimization,
        _uiPolish,
      ]),
    ]),
    priority: 100,
    coinReward: 5000,
    miniGame: MiniGame.sphinx);
