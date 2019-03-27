// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter_web_ui/ui.dart' as ui;
import 'package:dev_rpg/main.dart' as app;

Future<void> main() async {
  await ui.webOnlyInitializePlatform();
  app.main();
}
