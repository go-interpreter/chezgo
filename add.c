#include "add.h"
#include "scheme.h"

#define CALL0(who) Scall0(Stop_level_value(Sstring_to_symbol(who)))
#define CALL1(who, arg) Scall1(Stop_level_value(Sstring_to_symbol(who)), arg)

int jea_add(int x) { return x+1; }

/*
// Can't pass a Go pointer to a C function,
//  so we have to pass a pointer to a C
//  function that thunks into our Go function.
*/
int MyGoTwiceCgo(int x) {
  return MyGoTwice(x);
}

void AbnormalExit() {}

void SetupChez() {
  Sscheme_init(AbnormalExit);
  Sregister_boot_file("scheme.boot");
  Sbuild_heap(0,0);
  /*CALL1("debug-on-exception", Strue);*/
}

