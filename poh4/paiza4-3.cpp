// paiza4-3.cpp
// https://paiza.jp/poh/enkoi-ending/21edc1f4

#include <iostream>

using namespace std;

int main(void) {
  int T; cin >> T;
  int N; cin >> N;

  int max = -1;
  int sum = 0;
  int* buff = new int[T];

  for (int i=0; i<N; i++) {
    int val; cin >> val;

    buff[i%T] = val;
    sum += val;

    //cout << "i=" << i << " val=" << val << " sum=" << sum << " buff[i+1]=" << buff[(i+1)%T] << endl;
    if(i+1 < T) continue;

    if(sum > max) max = sum;
    sum -= buff[(i+1)%T];
  }

  cout << max << endl;

  delete[] buff;
  return 0;
}

