package main

import (
	"fmt"
	//"unsafe"
)

/*
#cgo CFLAGS: -Wpointer-arith -O2 -I/opt/X11/include/ -I./chez_scheme_9.5.1/boot/a6osx -I./chez_scheme_9.5.1/c -I.
#cgo LDFLAGS:  -liconv -lm -lncurses -L/usr/local/lib ./chez_scheme_9.5.1/boot/a6osx/kernel.o
#include "scheme.h"
extern void custom_init(void);
#include "add.h"

// forward declaration of the Go so that C knows about it.
int MyGoTwice(int x);

// the thunk
int MyGoTwiceCgo(int x);

void SetupChez();
*/
import "C"

const Svoid = 0x3E
const Seof_object = 0x36
const Strue = 0xE
const Sfalse = 0x6

//export MyGoTwice
func MyGoTwice(a int32) int32 {
	return a * 2
}

//
// modeled on the simple REPL example provided in
// the examples, transplanted to chez_scheme_9.5.1/c/crepl.c
//
func main() {

	defer func() {
		fmt.Printf("\n defer running, panic? %v\n", recover() != nil)
	}()

	//	C.Sscheme_init(C.AbnormalExit)
	//fmt.Printf("done with Sscheme_init()!\n")

	//C.Sregister_boot_file(C.CString("scheme.boot"))
	//fmt.Printf("done reading scheme.boot!\n")

	//C.Sbuild_heap(nil, nil)
	//fmt.Printf("done building heap.\n")

	// does all of the above.
	C.SetupChez()

	C.Sforeign_symbol(C.CString("jea_add"), C.jea_add)
	C.Sforeign_symbol(C.CString("go_twice"), C.MyGoTwiceCgo)

	for {
		//CALL1("display", Sstring("* "))
		C.Scall1(C.Stop_level_value(C.Sstring_to_symbol(C.CString("display"))), C.Sstring(C.CString("> ")))

		// READ
		p := C.Scall0(C.Stop_level_value(C.Sstring_to_symbol(C.CString("read"))))

		if uintptr(p) == Seof_object {
			fmt.Printf("\n we see EOF\n")
			// EOF
			break
		}
		// EVAL
		fmt.Printf("\n about to eval\n")
		p = C.Scall1(C.Stop_level_value(C.Sstring_to_symbol(C.CString("eval"))), p)
		fmt.Printf("\n done with eval\n")

		// PRINT
		if uintptr(p) != Svoid {
			C.Scall1(C.Stop_level_value(C.Sstring_to_symbol(C.CString("pretty-print"))), p)
		}
		//C.Scall0(C.Stop_level_value(C.Sstring_to_symbol(C.CString("newline"))))
	} // LOOP: end for loop
	fmt.Printf("out of for loop\n")

	/* must call Scheme_deinit after saving the heap and before exiting */
	C.Sscheme_deinit()
	fmt.Printf("deinit done.\n")
}
