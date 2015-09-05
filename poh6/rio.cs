// rio.cs
// https://paiza.jp/poh/joshibato/rio


namespace Rio {

	class Cup {
		decimal water; // お湯の質量
		decimal cafee; // コーヒー粉末の質量

		// コンストラクタ
		public Cup(decimal w=0, decimal c=0) { water=w; cafee=c; }
		// 合計質量
		public decimal sum() { return water+cafee; }
		// 濃度
		public decimal concentration() { return cafee/sum(); }
		// 操作1 お湯を入れる
		public void addWater(decimal g) { water += g; }
		// 操作2 コーヒー粉末を入れる
		public void addCafee(decimal g) { cafee += g; }
		// 操作3 味見する
		void tasting(decimal g) { var s=sum(); water -= g*water/s; cafee -= g*cafee/s; }

		public static void Main() {
			int N = int.Parse(System.Console.ReadLine());

			var cup = new Cup();

			for (int i=0; i<N; i++) {
				var line = System.Console.ReadLine().Split(' ');
				int operation = int.Parse(line[0]);
				int gram = int.Parse(line[1]);

				switch(operation) {
				case 1: cup.addWater(gram); break;
				case 2: cup.addCafee(gram); break;
				default: cup.tasting(gram); break;
				}
			}

			System.Console.WriteLine((int)(100*cup.concentration()));
		}
	}
}

Rio.Cup.Main();
