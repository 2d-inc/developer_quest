# Developer Quest

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
  boxplots of the latest runs. This will show up as `test_driver/*.pdf` files.
* Peruse the raw data file (used by R to generate the boxplots) by opening the
  `durations.tsv` file. These files contain build and rasterization times for each frame
  for every run.

If you want to get several runs at once, you can use something like the following command:

```sh
DESC="my change" bash -c 'for i in {1..5}; do flutter drive --target=test_driver/performance.dart --profile; sleep 1; done'
```

Why run several times when we get so many data points on each walkthrough? With several identical
walkthroughs it's possible to visually check variance between runs. Even with box plots,
these nuances get lost in the summary stats, so it's hard to see whether a change actually
brought any performance improvement or not. Running several times also eliminates
the effect of extremely bad luck, like for example when Android decides to update some app while
test is running.

### Lock CPU and GPU speed for your performance test device

Run the following command when your performance test device is attached via USB.

```bash
./tool/lock_android_scaling.sh
```

WARNING:

* This only works for rooted devices.
* This only works for Nexus 5. The specifics of scaling lock are different from device to device.
  You can modify the script to your needs, following
  [this template](https://github.com/google/skia/blob/master/infra/bots/recipe_modules/flavor/android.py)
  and
  [/sys/devices/system/cpu documentation](https://www.kernel.org/doc/Documentation/ABI/testing/sysfs-devices-system-cpu).

### Where to store the profiling data

You probably don't want to check the `*.tsv` output files into the repo. For that,
run `git update-index --assume-unchanged test_driver/*.tsv` in the root dir. This is a one time
command per machine.
