#include <cassert>

class string {
public:
  int _size;
  char* str;

  string() {
    _size = 2;
  }

  char* do_something() {
    assert(_size == 2);
    this->str = new char[this->_size + 1];
    return this->str;
  }
};

int main()
{
  assert(1);
  string myStr;
  char* p;
  p = myStr.do_something();
  p[0] = 'h';
  p[1] = 'i';
  p[2] = '\0';
  assert(p[1] == 'i');
  //assert(p[1] != 'i'); // shoudl be 'i'
  delete p;
  return 0;
}
