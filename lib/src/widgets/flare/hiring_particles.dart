import 'dart:math';
import 'dart:ui';

/// Data for each particle in the [HiringParticles] system.
/// [HiringParticles] will create and destroy as many [HiringParticle]
/// instances as it needs to show the effect.
class HiringParticle {
  /// The position of the particle.
  Offset offset;

  /// The brightness of the particle.
  double opacity;

  /// The scale in 0-1 range, gets multiplied by the desired particle display
  /// size by [HiringParticles] at draw time.
  double scale;

  /// The phase the particle is in for its horizontal motion which is driven
  /// by an LFO (simple sin wave).
  double phase;
}

/// This is the class that manages the list of particles that are displayed
/// for the hiring bust. It's reponsible for instancing, destroying, moving, and
/// painting the particles.
class HiringParticles {
  final Color color;
  final List<HiringParticle> _particles = [];
  static const int particleCount = 20;
  double particleSize = 10;
  final Random _random = Random();
  double elapsedSinceEmission = 0;

  HiringParticles({this.color});
  void advance(double elapsedSeconds, Size size) {
    if (_particles.isEmpty) {
      while (_particles.length < particleCount) {
        _particles.add(HiringParticle()
          ..offset = Offset(_random.nextDouble() * size.width,
              _random.nextDouble() * size.height)
          ..opacity = 0
          ..phase = _random.nextDouble()
          ..scale = _random.nextDouble());
      }
    }

    List<HiringParticle> deadParticles = [];
    for (final HiringParticle particle in _particles) {
      particle.phase += elapsedSeconds;
      particle.offset = Offset(particle.offset.dx,
          particle.offset.dy - size.height * elapsedSeconds * 0.5);
      if (particle.offset.dy < size.height / 2) {
        particle.opacity -= elapsedSeconds;
      } else {
        particle.opacity += elapsedSeconds;
      }
      particle.scale -= min(1, elapsedSeconds / 5);
      if (particle.opacity < 0 || particle.scale < 0) {
        deadParticles.add(particle);
      }
    }

    elapsedSinceEmission += elapsedSeconds;
    // no more than two per advance
    if (elapsedSinceEmission > 0.1 && _particles.length < particleCount) {
      elapsedSinceEmission = 0;
      _particles.add(HiringParticle()
        ..offset = Offset(_random.nextDouble() * size.width, size.height)
        ..opacity = 0
        ..phase = _random.nextDouble()
        ..scale = 0.5 + 0.5 * _random.nextDouble());
    }

    deadParticles.forEach(_particles.remove);
  }

  void paint(Canvas canvas, Offset offset) {
    double fullRadius = particleSize / 2;

    for (final HiringParticle particle in _particles) {
      Offset po = offset + particle.offset;
      double radius = fullRadius * particle.scale;
      double size = radius * 2;
      double ox = sin(particle.phase * 2) * particleSize * particle.scale;
      canvas.drawOval(
          Rect.fromLTWH(
              ox + po.dx - radius, po.dy + fullRadius - radius, size, size),
          Paint()
            ..style = PaintingStyle.fill
            ..color =
                color.withOpacity(particle.opacity.clamp(0, 1).toDouble()));
    }
  }
}
