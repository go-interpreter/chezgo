#ifndef ADD_H
#define ADD_H

int jea_add(int x);

/*
// Can't pass a Go pointer to a C function,
//  so we have to pass a pointer to a C
//  function that thunks into our Go function.
*/
int MyGoTwice(int x);

#endif /*ADD_H*/
