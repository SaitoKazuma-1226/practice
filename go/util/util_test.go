// go/util/util_test.go
package util

import "testing" // テスト機能を使うために必要

func TestIsLeapYear(t *testing.T) {
	// テストテーブルの定義
	// 各要素は、テストケースの名前、入力年、期待する結果を持つ
	tests := []struct {
		name string // テストケースの名前 (ログに出力される)
		year int    // IsLeapYear関数への入力
		want bool   // IsLeapYear関数が返すことを期待する結果
	}{
		// 閏年になるケース
		{name: "Year 2000 (divisible by 400)", year: 2000, want: true},
		{name: "Year 2024 (divisible by 4 but not 100)", year: 2024, want: true},
		{name: "Year 1600 (divisible by 400)", year: 1600, want: true},
		{name: "Year 4 (basic leap year)", year: 4, want: true},

		// 閏年ではないケース
		{name: "Year 1900 (divisible by 100 but not 400)", year: 1900, want: false},
		{name: "Year 2023 (not divisible by 4)", year: 2023, want: false},
		{name: "Year 2100 (divisible by 100 but not 400)", year: 2100, want: false},
		{name: "Year 1 (not divisible by 4)", year: 1, want: false},

		// 境界値や特殊なケース (IsLeapYearの実装による)
		{name: "Year 0 (invalid, return false)", year: 0, want: false}, // IsLeapYear関数で <=0 の場合falseと仮定
		{name: "Negative year (invalid, return false)", year: -100, want: false},
	}

	// 定義した各テストケースをループで実行
	for _, tt := range tests {
		// t.Run はテストケースごとにサブテストを実行し、テスト結果を個別に表示する
		// これにより、どのテストケースが失敗したか分かりやすくなる
		t.Run(tt.name, func(t *testing.T) {
			got := IsLeapYear(tt.year) // 実際に IsLeapYear 関数を呼び出して結果を得る
			if got != tt.want {        // 期待する結果 (tt.want) と実際の結果 (got) を比較
				// もし結果が期待通りでなければエラーを報告
				t.Errorf("IsLeapYear(%d) = %v; want %v", tt.year, got, tt.want)
			}
		})
	}
}
