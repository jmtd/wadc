#"standard.h"

north { 0 }
east  { 1 }
south { 2 }
west  { 3 }

main
{
    assert(eq(north,getorient))
    rotright
    assert(eq(east,getorient))
    rotright
    assert(eq(south,getorient))
    rotright
    assert(eq(west,getorient))
}
