import 'dart:async';

import 'package:flare_flutter/flare.dart';
import 'package:flutter/services.dart';

typedef void OnFlareLoaded<FlutterActor>(FlutterActor resource);

/// Store a Flare file along with callbacks for clients that 
/// are waiting for the load to complete
class FlareAsset {
  FlutterActor _resource;
  FlutterActor get resource => _resource;
  bool get isAvailable {
    return _resource != null;
  }

  List<Completer<FlutterActor>> _callbacks;
  Future<FlutterActor> onLoaded() async {
    if (_resource != null) {
      return _resource;
    }
    _callbacks ??= [];
    Completer<FlutterActor> completer = Completer<FlutterActor>();
    _callbacks.add(completer);
    return completer.future;
  }

  void completeLoad(FlutterActor res) {
    _resource = res;
    if (_callbacks != null) {
      for (final Completer<FlutterActor> callback in _callbacks) {
        callback.complete(res);
      }
      _callbacks = null;
    }
  }

  void load(AssetBundle bundle, String filename) {
    FlutterActor actor = FlutterActor();
    actor.loadFromBundle(bundle, filename).then((bool success) {
      if (success) {
        // Initialize graphics on base Flare (non-instanced) file.
        // Sets up any shared buffers.
        actor.artboard.initializeGraphics();

        completeLoad(actor);
      } else {
        print("Failed to load flare file from $filename.");
      }
    });
  }
}

/// A mapping of loaded Flare assets.
final Map<AssetBundle, Map<String, FlareAsset>> _cache = {};

/// Get a cached Flare actor, or load it.
Future<FlutterActor> cachedActor(AssetBundle bundle, String filename) async {
  Map<String, FlareAsset> assets = _cache[bundle];
  if (assets == null) {
    _cache[bundle] = assets = <String, FlareAsset>{};
  }
  FlareAsset asset = assets[filename];
  if (asset != null) {
    if (asset.isAvailable) {
      return asset?.resource;
    } else {
      return asset.onLoaded();
    }
  }

  FlareAsset newAsset = FlareAsset();
  assets[filename] = newAsset;
  newAsset.load(bundle, filename);
  if (newAsset.isAvailable) {
    return newAsset?.resource;
  } else {
    return newAsset.onLoaded();
  }
}
