import 'package:flutter_test/flutter_test.dart';
import 'package:kage/app.dart';
import 'package:kage/app_services.dart';

void main() {
  testWidgets('Splash menampilkan wordmark KAGE', (tester) async {
    await tester.pumpWidget(KageApp(services: AppServices()));

    expect(find.text('KAGE'), findsWidgets);
    expect(find.text('THE QUIZ SANCTUARY'), findsOneWidget);
  });
}
