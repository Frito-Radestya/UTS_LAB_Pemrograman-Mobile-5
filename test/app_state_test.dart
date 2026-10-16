import 'dart:convert';

import 'package:bolt_quiz/data/quiz_data.dart';
import 'package:bolt_quiz/models/quiz_models.dart';
import 'package:bolt_quiz/state/app_scope.dart';
import 'package:bolt_quiz/state/app_state.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Future<void> answerAll(AppState state, {int wrong = 0}) async {
    final questions = state.activeCategory!.questions;
    for (var i = 0; i < questions.length; i++) {
      await state.goToQuestion(i);
      await state.selectAnswer(
        i < wrong
            ? (questions[i].correctIndex + 1) % questions[i].options.length
            : questions[i].correctIndex,
      );
    }
  }

  test(
    'catalog has six distinct categories with eight valid questions each',
    () {
      expect(quizCategories.length, 6);
      expect(quizCategories.map((category) => category.id).toSet().length, 6);
      for (final category in quizCategories) {
        expect(category.questions.length, 8);
        expect(['Mudah', 'Sedang', 'Sulit'], contains(category.difficulty));
        expect(category.estimatedMinutes, greaterThan(0));
        for (final question in category.questions) {
          expect(question.prompt, isNotEmpty);
          expect(question.explanation, isNotEmpty);
          expect(question.options.length, greaterThanOrEqualTo(2));
          expect(question.options.toSet().length, question.options.length);
          expect(
            question.correctIndex,
            inInclusiveRange(0, question.options.length - 1),
          );
        }
      }
      expect(
        quizCategories
            .expand((category) => category.questions)
            .any((q) => q.code != null),
        isTrue,
      );
    },
  );

  test(
    'fresh state has safe nullable getters and dark mode by default',
    () async {
      final state = await AppState.load();
      expect(state.isLoggedIn, isFalse);
      expect(state.isDarkMode, isTrue);
      expect(state.currentQuestion, isNull);
      expect(state.currentAnswer, isNull);
      expect(state.activeCategory, isNull);
      expect(state.progress, 0);
      expect(state.totalQuestions, 0);
      expect(state.activeElapsedSeconds, 0);
      expect(state.scoreTotal, 0);
      expect(state.bestScore, 0);
    },
  );

  test(
    'progress, user, settings, navigation and flags survive reload',
    () async {
      final state = await AppState.load();
      await state.signIn('  Rani  ', ' rani@example.com ');
      await state.setDarkMode(false);
      await state.setSoundEnabled(false);
      await state.setRemindersEnabled(false);
      await state.startQuiz(quizCategories.first);
      final save = state.selectAnswer(2);
      expect(
        state.currentAnswer,
        2,
      ); // Mutation happens before persistence awaits.
      expect(state.answeredCount, 1);
      expect(state.progress, 1 / 8);
      await save;
      await state.goToQuestion(3);
      await state.toggleFlag();
      await state.selectAnswer(1);

      final restored = await AppState.load();
      expect(restored.playerName, 'Rani');
      expect(restored.email, 'rani@example.com');
      expect(restored.isLoggedIn, isTrue);
      expect(restored.isDarkMode, isFalse);
      expect(restored.soundEnabled, isFalse);
      expect(restored.remindersEnabled, isFalse);
      expect(restored.activeCategory, same(quizCategories.first));
      expect(restored.questionIndex, 3);
      expect(restored.currentQuestion, same(quizCategories.first.questions[3]));
      expect(restored.currentAnswer, 1);
      expect(restored.answers, {0: 2, 3: 1});
      expect(restored.flagged, {3});
      expect(restored.progress, 2 / 8);
      expect(restored.activeElapsedSeconds, greaterThanOrEqualTo(0));
      expect(() => restored.answers[0] = 0, throwsUnsupportedError);
      expect(() => restored.flagged.add(0), throwsUnsupportedError);
      expect(() => restored.completedResults.clear(), throwsUnsupportedError);
      await restored.toggleFlag();
      expect(restored.flagged, isEmpty);
      await restored.goToQuestion(0);
      expect(restored.currentAnswer, 2);
      expect(() => restored.goToQuestion(-1), throwsRangeError);
      expect(() => restored.goToQuestion(8), throwsRangeError);
      expect(() => restored.selectAnswer(4), throwsRangeError);
    },
  );

  test('finish scores answers, preserves player, and prevents duplicate submissions', () async {
    final state = await AppState.load();
    await state.signIn('Bima', 'bima@example.com');
    await state.startQuiz(quizCategories.first);
    await answerAll(state, wrong: 2);
    // Selecting answers never adds points to the history or reveals a result.
    expect(state.scoreTotal, 0);
    expect(state.completedResults, isEmpty);
    final first = state.finishQuiz();
    final duplicate = state.finishQuiz();
    expect(duplicate, same(first));
    final result = await first;
    expect(result.playerName, 'Bima');
    expect(result.categoryTitle, quizCategories.first.title);
    expect(result.correct, 6);
    expect(result.total, 8);
    expect(result.points, 600);
    expect(result.accuracy, 0.75);
    expect(result.answers.length, 8);
    expect(result.elapsedSeconds, greaterThanOrEqualTo(0));
    expect(state.activeCategory, isNull);
    expect(state.currentQuestion, isNull);
    expect(state.answers, isEmpty);
    expect(state.flagged, isEmpty);
    expect(await state.finishQuiz(), same(result));
    expect(state.completedCount, 1);
    expect(state.scoreTotal, 600);
    expect(state.bestScore, 600);
    expect(() => result.answers[0] = 0, throwsUnsupportedError);

    final restored = await AppState.load();
    expect(restored.activeCategory, isNull);
    expect(restored.completedCount, 1);
    expect(restored.completedResults.single.toJson(), result.toJson());
    expect(QuizResult.fromJson(result.toJson()).toJson(), result.toJson());

    await restored.startQuiz(quizCategories[1]);
    await answerAll(restored);
    final newest = await restored.finishQuiz();
    expect(restored.completedResults.first, same(newest));
    expect(restored.completedCount, 2);
    expect(restored.scoreTotal, 1400);
    expect(restored.bestScore, 800);
    expect(
      (await AppState.load()).completedResults.first.categoryId,
      quizCategories[1].id,
    );
  });

  test('finish refuses unanswered questions without losing progress', () async {
    final state = await AppState.load();
    await expectLater(state.finishQuiz(), throwsStateError);
    await state.startQuiz(quizCategories.first);
    await state.selectAnswer(0);
    await expectLater(state.finishQuiz(), throwsStateError);
    expect(state.answeredCount, 1);
    expect(state.completedCount, 0);
    expect(state.activeCategory, isNotNull);
    await answerAll(state);
    expect((await state.finishQuiz()).points, 800);
  });

  test(
    'same category resumes; restart and reset clear active progress',
    () async {
      final state = await AppState.load();
      await state.startQuiz(quizCategories.first);
      await state.goToQuestion(2);
      await state.selectAnswer(1);
      await state.toggleFlag();
      await state.startQuiz(quizCategories.first);
      expect(state.questionIndex, 2);
      expect(state.answers, {2: 1});
      expect(state.flagged, {2});
      await state.startQuiz(quizCategories.first, restart: true);
      expect(state.questionIndex, 0);
      expect(state.answers, isEmpty);
      expect(state.flagged, isEmpty);
      await state.selectAnswer(0);
      await state.startQuiz(quizCategories[1]);
      expect(state.activeCategory, same(quizCategories[1]));
      expect(state.answers, isEmpty);
      await state.resetQuiz();
      expect(state.currentQuestion, isNull);
      expect((await AppState.load()).activeCategory, isNull);
    },
  );

  test(
    'signOut removes identity, active quiz and history, retaining settings',
    () async {
      final state = await AppState.load();
      await state.signIn('Ayu', 'ayu@example.com');
      await state.setDarkMode(false);
      await state.startQuiz(quizCategories.first);
      await answerAll(state);
      await state.finishQuiz();
      await state.startQuiz(quizCategories[1]);
      await state.selectAnswer(1);
      await state.toggleFlag();
      final save = state.signOut();
      expect(state.isLoggedIn, isFalse);
      expect(state.playerName, isEmpty);
      expect(state.email, isEmpty);
      expect(state.activeCategory, isNull);
      expect(state.completedResults, isEmpty);
      expect(state.answers, isEmpty);
      expect(state.flagged, isEmpty);
      await save;
      final restored = await AppState.load();
      expect(restored.isLoggedIn, isFalse);
      expect(restored.completedResults, isEmpty);
      expect(restored.activeCategory, isNull);
      expect(restored.isDarkMode, isFalse);
      await restored.signIn('Dewi', 'dewi@example.com');
      expect(restored.scoreTotal, 0);
      await expectLater(restored.finishQuiz(), throwsStateError);
    },
  );

  test('changing account without signOut also isolates user data', () async {
    final state = await AppState.load();
    await state.signIn('A', 'a@example.com');
    await state.startQuiz(quizCategories.first);
    await answerAll(state);
    await state.finishQuiz();
    await state.signIn('B', 'b@example.com');
    expect(state.completedResults, isEmpty);
    await expectLater(state.finishQuiz(), throwsStateError);
  });

  test('rapid unawaited writes persist the newest snapshot', () async {
    final state = await AppState.load();
    final writes = [
      state.signIn('Raka', 'raka@example.com'),
      state.startQuiz(quizCategories.first),
      state.selectAnswer(0),
      state.selectAnswer(1),
      state.goToQuestion(2),
      state.toggleFlag(),
      state.setDarkMode(false),
    ];
    await Future.wait(writes);
    final restored = await AppState.load();
    expect(restored.answers, {0: 1});
    expect(restored.questionIndex, 2);
    expect(restored.flagged, {2});
    expect(restored.isDarkMode, isFalse);
  });

  test('malformed snapshots and unknown category ids restore safely', () async {
    final state = await AppState.load();
    await state.startQuiz(quizCategories.first);
    final preferences = await SharedPreferences.getInstance();
    final key = preferences.getKeys().single;
    final original =
        jsonDecode(preferences.getString(key)!) as Map<String, dynamic>;
    for (final broken in ['{broken', '[]', 'null', '42']) {
      await preferences.setString(key, broken);
      final restored = await AppState.load();
      expect(restored.activeCategory, isNull);
      expect(restored.isDarkMode, isTrue);
    }
    await preferences.setInt(key, 12);
    expect((await AppState.load()).activeCategory, isNull);

    await preferences.setString(
      key,
      jsonEncode({
        ...original,
        'isDarkMode': 'false',
        'completedResults': [
          null,
          {},
          {'correct': 'bad'},
        ],
        'activeQuiz': {
          'categoryId': 'removed-category',
          'startedAt': DateTime.now().toIso8601String(),
        },
      }),
    );
    final unknown = await AppState.load();
    expect(unknown.activeCategory, isNull);
    expect(unknown.completedResults, isEmpty);
    expect(unknown.isDarkMode, isTrue);

    await preferences.setString(
      key,
      jsonEncode({
        ...original,
        'activeQuiz': {
          'categoryId': quizCategories.first.id,
          'startedAt': DateTime.now()
              .subtract(const Duration(seconds: 120))
              .toIso8601String(),
          'questionIndex': 999,
          'answers': {'0': 1, '1': -1, '2': 99, '3': '1', '999': 0, 'bad': 0},
          'flags': [0, -1, 999, '1', null],
        },
      }),
    );
    final sanitized = await AppState.load();
    expect(sanitized.questionIndex, 0);
    expect(sanitized.answers, {0: 1});
    expect(sanitized.flagged, {0});
    expect(sanitized.activeElapsedSeconds, greaterThanOrEqualTo(120));

    final invalidTime = Map<String, dynamic>.from(original);
    invalidTime['activeQuiz'] = {
      'categoryId': quizCategories.first.id,
      'startedAt': 'not-a-date',
    };
    await preferences.setString(key, jsonEncode(invalidTime));
    expect((await AppState.load()).activeCategory, isNull);
  });

  testWidgets('AppScope.of listens to notifier changes', (tester) async {
    final state = await AppState.load();
    await tester.pumpWidget(
      AppScope(
        state: state,
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Builder(
            builder: (context) {
              return Text(AppScope.of(context).isDarkMode ? 'dark' : 'light');
            },
          ),
        ),
      ),
    );
    expect(find.text('dark'), findsOneWidget);
    await state.setDarkMode(false);
    await tester.pump();
    expect(find.text('light'), findsOneWidget);
  });
}
