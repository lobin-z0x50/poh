// poh6+
#include <iostream>
#include <algorithm>
#include <map>
#include <algorythm>

using namespace std;

class WordDB
  map<string, int> words;     // 単発単語 {word=>個数}
  map<string, int> kai_words; // 単体で回文になっている単語(adjustメソッドで作成) {word=>個数}
  map<string, int> pairs;     // 逆よみで同じスペルのもの {word=>個数}

  void reverse(string str) {
    string ret;
    for (auto p = str.rbegin(); p != str.rend(); p++) {
      ret += *p;
    }
    return ret;
  }

public:

  /**
   * 単語をDBに登録
   */
  void add(string str) {
    auto r_str = this->reverse(str);
    if (words.count(r_str) && words[r_str] > 0) {
      // 逆綴りの語が単発単語にすでに存在する場合
      words[r_str] -= 1;    // 単発単語から消す
      auto m = min(r_str, str);  // 逆綴りのものと辞書順で早い方を取得
      // ペア単語として追加
      if (pairs.count(m)) {
        pairs[m] += 1;
      } else {
        pairs[m] = 1;
      }
    } else {
      // 逆綴りの語が単発単語に存在しなければ、単発単語として登録する
      if (words.count(str))) {
        words[str] += 1;
      } else {
        words[str] = 1;
      }
    }
  }

  // 単語DBを整理
  void adjust() {
    for (auto x = words.begin(); x!=words.end(); x++) {
      if (x.reverse() == x) {
        // 単体での回文
        kai_words[x] = words[x];
      }
    }
  }

  // 答え
  void answer() {
    string str1 = "";
    string w = "";

    // ペアのものを辞書順に結合していく
    for (auto p=pairs.keys.begin(); p!=pairs.end(); p++) {
      for (auto i = 0; i < pairs[w]; i++) { str1 << w; }
    }

    // 単体で回文になっているものは辞書順で早いものを一つだけ採用
    if (!kai_words.empty()){
      w = sort(kai_words.begin(), kai_words.end())
    }

    // 答え
    return str1 + w + this->reverse(str1)
  }

  def to_s()
    "words = #{@words}\n kai_words = #{@kai_words}\n  pairs = #{@pairs}"
  end
end


/// --- main --- ///

WordDB db;

int N; N << cin;
while (N--) {
  string str; str << cin;
  db.add str
end

db.adjust()
count << db.answer()

