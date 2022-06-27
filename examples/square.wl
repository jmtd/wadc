#"standard.h"

main {
  seed(rand(0,1337))
  thing
  movestep(-192,-192)
  rectop(1024)
}

rectop(n) {
  quad(rec(div(n,2)) rotleft)
}

square(n) {
  { final(mul(n,2)) | rec(n) | rec(n) }
}

rec(n) {
  eq(n,64)
    ? final(mul(n,2))
    : movestep(n,n)
      quad(square(div(n,2)) rotleft)
      movestep(sub(0,n),sub(0,n))
}

final(n) {
  { solids(n) | spaces(n) | spaces(n) }
}





-- SPACES --

spaces(n) {
  { base(n) | base(n) | trim(n) }
}

base(n) {
  wall("BRICK7")
  sqr(n)
  floor("DEM1_6")
  rightsector(0,128,128)
}

trim(n) {
  wall("MODWALL1")
  sqr(n)
  floor("FLAT4")
  rightsector(0,128,128)
  movestep(16,16)
  sqr(sub(n,32))
  floor("FLAT8")
  innerrightsector(0,128,128)
  movestep(-16,-16)
}




-- SOLIDS --

solids(n) {
  { octasolid(n,div(n,4)) | plat(n) | 0 }
}

plat(n) {
  sqr(n)
  rightsector(0,64,128)
}

octasolid(n,s) {
  wall("MARBLE3")
  quad(
    straight(s)
    rotright
    eright(s)
    right(s)
    rightsector(0,128,128)
    rotright
    movestep(n,0)
    rotright
  )
}




-- TOOLS --

sqr(n) { quad(step(n,0) rotright) }
