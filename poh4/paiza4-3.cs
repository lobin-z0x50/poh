#include <iostream>

using namespace std;

int main(void) {
  int T; cin >> T;
  int N; cin >> N;

  int max = -1;
  int sum = 0;
  int* buff = new int[T];

  for (int i=0; i<N; ) {
    int val; cin >> val;

    buff[i%T] = val;
    sum += val;

    i++;
    //cout << "i=" << i << " val=" << val << " sum=" << sum << " buff[i+1]=" << buff[(i+1)%T] << endl;
    if(i < T) continue;
    
    if(sum > max) max = sum;
    sum -= buff[i%T];
  }

  cout << max << endl;

  delete[] buff;
  return 0;
}

