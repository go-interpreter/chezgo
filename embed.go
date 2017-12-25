package main

import (
	"fmt"
)

/*
#cgo CFLAGS: -Wpointer-arith -O2 -I/opt/X11/include/ -I./chez_scheme_9.5.1/boot/a6osx -I./chez_scheme_9.5.1/c
#cgo LDFLAGS:  -liconv -lm -lncurses -L/usr/local/lib ./chez_scheme_9.5.1/boot/a6osx/kernel.o
#include "scheme.h"
extern void custom_init(void);
*/
import "C"

const Svoid = 0x3E
const Seof_object = 0x36

//
// modeled on the simple REPL example provided in
// the examples, transplanted to chez_scheme_9.5.1/c/crepl.c
//
func main() {

	C.Sscheme_init(nil)
	//fmt.Printf("done with Sscheme_init()!\n")

	C.Sregister_boot_file(C.CString("scheme.boot"))
	//fmt.Printf("done reading scheme.boot!\n")

	C.Sbuild_heap(nil, nil)
	//fmt.Printf("done building heap.\n")

	for {
		//CALL1("display", Sstring("* "))
		C.Scall1(C.Stop_level_value(C.Sstring_to_symbol(C.CString("display"))), C.Sstring(C.CString("> ")))

		// READ
		p := C.Scall0(C.Stop_level_value(C.Sstring_to_symbol(C.CString("read"))))

		if uintptr(p) == Seof_object {
			// EOF
			break
		}
		// EVAL
		p = C.Scall1(C.Stop_level_value(C.Sstring_to_symbol(C.CString("eval"))), p)
		// PRINT
		if uintptr(p) != Svoid {
			C.Scall1(C.Stop_level_value(C.Sstring_to_symbol(C.CString("pretty-print"))), p)
		}
		//C.Scall0(C.Stop_level_value(C.Sstring_to_symbol(C.CString("newline"))))
	} // LOOP: end for loop

	/* must call Scheme_deinit after saving the heap and before exiting */
	C.Sscheme_deinit()
	fmt.Printf("\n")
}
