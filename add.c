#include "add.h"

int jea_add(int x) { return x+1; }

/*
// Can't pass a Go pointer to a C function,
//  so we have to pass a pointer to a C
//  function that thunks into our Go function.
*/
int MyGoTwiceCgo(int x) {
  return MyGoTwice(x);
}
