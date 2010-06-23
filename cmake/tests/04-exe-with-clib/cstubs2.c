#include <stdio.h>

#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/alloc.h>
#include <caml/custom.h>

value
cstubs2_bar( value unit )
{
    CAMLparam1( unit );
    printf( "%s : %s\n", __FILE__, __FUNCTION__ );
    CAMLreturn( Val_unit );
}
