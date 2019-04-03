# dev_rpg

Become a tech lead, slay bugs, and don't get fired.

All in Flutter.

## Research tree

The game progression is based on a "research tree" of tasks. The tree is defined in code
in `lib/src/shared_state/task_tree` but for clarity it is also kept as a diagram
in `assets/docs`. Here's the PNG.

![The task "research tree"](https://github.com/2d-inc/dev_rpg/blob/master/assets/docs/research-tree.png)

## Performance testing

Attach a real device and run the following command from the root of the repo:

```sh
flutter drive --target=test_driver/performance.dart --profile
```

This will do an automated run-through of the app, and will save the output to files.

* Look into to `build/walkthrough-*.json` files for detailed summaries of each run.
* Look at `test_driver/perf_stats.tsv` to compare latest runs with historical data.
* Run `Rscript test_driver/generate-graphs.R` (assuming you have R installed) to generate
  boxplots of the latest runs.

If you want to get several runs at once, you can use something like the following command:

```sh
DESC="my change" bash -c 'for i in {1..5}; do flutter drive --target=test_driver/performance.dart --profile; sleep 1; done'
```
