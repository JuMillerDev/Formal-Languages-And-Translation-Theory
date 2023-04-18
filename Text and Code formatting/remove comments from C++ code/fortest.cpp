#include <stdio.h>

/** \brief Java style Doc String - Foo function */
int foo() { printf("foo"); return 0;   };

int bar() { printf("bar"); return 0;   }; /**< Bar function */

/// .NET Style Doc String
int g_global_var = 1;

/* Hello
/* World
// */
int baz() { printf("baz"); return 0;   };
// */

/*! Global variable
 *  ... */
volatile int g_global;

//! Main
int main(int argc, const char* argv)
{
    printf("/* foo bar");
    //*/ bar();

    // \
    /*
    baz();
    /*/
    foo();
    //*/

/\
/*
    baz();
/*/
    foo();
//*/

    return 1;
}