#"standard.h"

main {
  circle(512)
  rightsector(32,96,96)
  movestep(0,128)
  thing
  innercircles(384,128,32,16,0,128,96)
  movestep(0,64)
  innercircles(64,16,4,-16,-192,320,64)
  
}

circle(r) {
  quad(curve(r,r,10,1))
}

innercircles(r,minr,step,hstep,floor,ceil,ll) {
  eq(r,minr)
    ? 0
    : circle(r)
      innerrightsector(floor,ceil,ll)
      movestep(0,step)
      innercircles(sub(r,step),minr,step,hstep,sub(floor,hstep),add(ceil,hstep),add(ll,16))
}
