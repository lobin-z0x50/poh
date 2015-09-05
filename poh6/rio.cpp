// rio.cpp
// https://paiza.jp/poh/joshibato/rio

#include <iostream>

using namespace std;

class Cup {
	double water; // お湯の質量
	double cafee; // コーヒー粉末の質量

	public:
	// コンストラクタ
	Cup(double w=0.0, double c=0.0) { water=w; cafee=c; }
	// 合計質量
	double sum() { return water+cafee; }
	// 濃度
	double concentration() { return cafee/sum(); }
	// 操作1 お湯を入れる
	void addWater(double g) { water += g; }
	// 操作2 コーヒー粉末を入れる
	void addCafee(double g) { cafee += g; }
	// 操作3 味見する
	void tasting(double g) { s = sum(); water -= g*water/s; cafee -= g*cafee/s; }
};

int main(void) {
	int N; cin >> N;

	Cup cup;

	for (int i=0; i<N; i++) {
		int operation; cin >> operation;
		int gram; cin >> gram;

		gram*=10000000;  // 無理数に対する暫定措置
		switch(operation) {
		case 1: cup.addWater(gram); break;
		case 2: cup.addCafee(gram); break;
		default: cup.tasting(gram); break;
		}
	}

	cout << (int)(100*cup.concentration()) << endl;

	return 0;
}

