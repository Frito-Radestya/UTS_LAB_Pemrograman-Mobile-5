import 'package:flutter_test/flutter_test.dart';
import 'package:kage/state/app_state.dart';
import 'package:kage/state/progress.dart';

void main() {
  group('K-08 level dan XP', () {
    test('batas setiap level mengikuti kurva kumulatif', () {
      expect(levelFromXp(-10), 1);
      expect(levelFromXp(0), 1);
      expect(levelFromXp(99), 1);

      expect(levelFromXp(100), 2);
      expect(levelFromXp(249), 2);

      expect(levelFromXp(250), 3);
      expect(levelFromXp(449), 3);

      expect(levelFromXp(450), 4);
      expect(levelFromXp(699), 4);

      expect(levelFromXp(700), 5);
      expect(levelFromXp(999), 5);

      expect(levelFromXp(1000), 6);
      expect(levelFromXp(1350), 7);
    });

    test('level tidak dibatasi dan tetap naik dari XP besar', () {
      expect(levelFromXp(1000000), greaterThan(10));
    });

    test('xpToNextLevel menghitung sisa XP yang benar', () {
      expect(xpToNextLevel(0), 100);
      expect(xpToNextLevel(99), 1);
      expect(xpToNextLevel(100), 150);
      expect(xpToNextLevel(249), 1);
      expect(xpToNextLevel(250), 200);
    });

    test('awal level dipakai untuk progres bar', () {
      expect(xpAtLevelStart(0), 0);
      expect(xpAtLevelStart(300), 250);
      expect(xpAtLevelStart(450), 450);
    });

    test('AppState menghitung level dari XP yang tersimpan', () {
      final app = AppState();
      addTearDown(app.dispose);

      expect(app.level, 1);
      app.xp = 250;
      expect(app.level, 3);
      app.xp = 700;
      expect(app.level, 5);
    });
  });
}
