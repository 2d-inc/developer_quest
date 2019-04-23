import 'package:dev_rpg/src/shared_state/game/world.dart';
import 'package:test/test.dart';

void main() {
  test('cannot hire without money', () {
    var world = World()..company.coin.number = 0;
    var newHire = world.characterPool.children.firstWhere((ch) => !ch.isHired);
    expect(newHire.hire(), false);
    expect(newHire.isHired, false);
  });

  test('can hire', () {
    var world = World()..company.coin.number = 1000;
    var newHire = world.characterPool.children.firstWhere((ch) => !ch.isHired);
    expect(newHire.hire(), true);
    expect(newHire.isHired, true);
  });

  test('cannot be upgraded when not hired', () {
    var world = World();
    var unhired = world.characterPool.children.firstWhere((ch) => !ch.isHired);
    var previous = unhired.level;
    expect(unhired.upgrade(), false);
    expect(unhired.level, previous);
  });

  test('level goes up when upgraded', () {
    var world = World()..company.coin.number = 1000;
    var hired = world.characterPool.children.firstWhere((ch) => ch.isHired);
    var previous = hired.level;
    expect(hired.upgrade(), true);
    expect(hired.level, greaterThan(previous));
  });

  test('skill goes up when upgraded', () {
    var world = World()..company.coin.number = 1000;
    var hired = world.characterPool.children.firstWhere((ch) => ch.isHired);
    var previous = hired.prowess.values.fold<int>(0, (a, b) => a + b);
    expect(hired.upgrade(), true);
    expect(hired.prowess.values.fold<int>(0, (a, b) => a + b),
        greaterThan(previous));
  });
}
