import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // (未使用のimportは削除しても良い)
import 'dart:convert'; // (未使用のimportは削除しても良い)

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // ここを MyHomePage から isLeapYear に戻していることを確認
      home: const isLeapYear(),
    );
  }
}

// ... (MyHomePage および _MyHomePageState クラスはそのまま) ...
// ... (loadWeather 関数もそのまま) ...

class isLeapYear extends StatefulWidget {
  const isLeapYear({super.key});

  @override
  State<isLeapYear> createState() => _isLeapYearState();
}

class _isLeapYearState extends State<isLeapYear> {
  int year = 0; // この変数は現在未使用なので削除しても良い
  TextEditingController textEditingController = TextEditingController();
  String LeapYear = "";

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  Future<void> isLeapYearResult(String value) async { // valueをString型に変更
    int? year = int.tryParse(value);
    if (year == null) {
      setState(() {
        LeapYear = "入力が正しくありません";
      });
    } else if ((year % 400 == 0) || (year % 4 == 0 && year % 100 != 0)) {
      setState(() {
        LeapYear = "$year は閏年です"; // 出力をより分かりやすくする
      });
    } else {
      setState(() {
        LeapYear = "$year は閏年ではありません"; // 出力をより分かりやすくする
      });
    }
  }

  // --- 課題29用のテストドライバの追加 ---
  void _runLeapYearTests() {
    // 明示的なテストケースをここで実行
    print("--- 閏年判定テスト開始 ---");

    // テストケース1: 400で割り切れる年 (閏年)
    isLeapYearResult("2000"); // 期待値: 閏年
    print("Test 2000: $LeapYear"); // setStateが非同期なので、これは直前のLeapYearを参照する可能性あり

    // テストケース2: 4で割り切れるが100で割り切れない年 (閏年)
    isLeapYearResult("2024"); // 期待値: 閏年
    print("Test 2024: $LeapYear");

    // テストケース3: 100で割り切れるが400で割り切れない年 (閏年ではない)
    isLeapYearResult("1900"); // 期待値: 閏年ではない
    print("Test 1900: $LeapYear");

    // テストケース4: 4で割り切れない年 (閏年ではない)
    isLeapYearResult("2023"); // 期待値: 閏年ではない
    print("Test 2023: $LeapYear");

    // テストケース5: 無効な入力
    isLeapYearResult("abc"); // 期待値: 入力が正しくありません
    print("Test abc: $LeapYear");

    print("--- 閏年判定テスト終了 ---");
    // テスト結果をUIに反映するため、最後にsetStateを呼び出す
    // （printの直後にLeapYearを読んでもsetStateがまだ終わってない可能性があるため）
    setState(() {
      LeapYear = "テスト結果はコンソールを確認してください。"; // UI表示はテスト結果まとめにする
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("閏年判定アプリ")), // AppBarのタイトルを修正
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: textEditingController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "年を入力してください"), // ラベルを追加
              onChanged: (value) {
                if (value.isNotEmpty) {
                  isLeapYearResult(value);
                } else { // 入力が空になったら表示をリセット
                  setState(() {
                    LeapYear = "";
                  });
                }
              },
            ),
            const SizedBox(height: 20), // スペースを追加
            Text(
              LeapYear,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40), // ボタンとのスペース
            // --- テストドライバの実行ボタン ---
            ElevatedButton(
              onPressed: _runLeapYearTests,
              child: const Text("定義済みテストを実行"),
            ),
          ],
        ),
      ),
    );
  }
}