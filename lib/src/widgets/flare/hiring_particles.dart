import 'dart:math';
import 'dart:ui';

// Data for each particle in the system.
class HiringParticle {
  Offset offset;
  double opacity;
  double scale;
  double phase;
}

// List of particles to draw for the hiring availability state.
class HiringParticles {
  final List<HiringParticle> _particles = [];
  static const int particleCount = 20;
  static const double particleSize = 10.0;
  final Random _random = Random();
  double elapsedSinceEmission = 0.0;

  void advance(double elapsedSeconds, Size size) {
    if (_particles.isEmpty) {
      while (_particles.length < particleCount) {
        _particles.add(HiringParticle()
          ..offset = Offset(_random.nextDouble() * size.width,
              _random.nextDouble() * size.height)
          ..opacity = 0.0
          ..phase = _random.nextDouble()
          ..scale = _random.nextDouble());
      }
    }

    List<HiringParticle> deadParticles = [];
    for (final HiringParticle particle in _particles) {
      particle.phase += elapsedSeconds;
      particle.offset = Offset(particle.offset.dx,
          particle.offset.dy - size.height * elapsedSeconds * 0.5);
      if (particle.offset.dy < size.height / 2.0) {
        particle.opacity -= elapsedSeconds;
      } else {
        particle.opacity += elapsedSeconds;
      }
      particle.scale -= min(1.0, elapsedSeconds / 5.0);
      if (particle.opacity < 0.0 || particle.scale < 0.0) {
        deadParticles.add(particle);
      }
    }

    elapsedSinceEmission += elapsedSeconds;
    // no more than two per advance
    if (elapsedSinceEmission > 0.1 && _particles.length < particleCount) {
      elapsedSinceEmission = 0.0;
      _particles.add(HiringParticle()
        ..offset = Offset(_random.nextDouble() * size.width, size.height)
        ..opacity = 0.0
        ..phase = _random.nextDouble()
        ..scale = 0.5 + 0.5 * _random.nextDouble());
    }

    deadParticles.forEach(_particles.remove);
  }

  void paint(Canvas canvas, Offset offset) {
    double fullRadius = particleSize / 2.0;

    for (final HiringParticle particle in _particles) {
      Offset po = offset + particle.offset;
      double radius = fullRadius * particle.scale;
      double size = radius * 2.0;
      double ox = sin(particle.phase * 2.0) * particleSize * particle.scale;
      canvas.drawOval(
          Rect.fromLTWH(
              ox + po.dx - radius, po.dy + fullRadius - radius, size, size),
          Paint()
            ..style = PaintingStyle.fill
            ..color = Color.fromRGBO(
                0, 152, 255, particle.opacity.clamp(0.0, 1.0).toDouble()));
    }
  }
}
