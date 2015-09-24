#"standard.h"

main {
  thing
  W
  movestep(0,512)
  A
  movestep(0,320)
  D
  movestep(0,320)
  C

}
W {
  step(-144,-48)  
  step(0,-128)
  step(512,-160)
  step(0,128)
  step(-272, add(16 ,112))
  step(144, add(16,64))
-- mirror of above. can we functionize that?
  step(-144, add(16,64))
  step(272, add(16,112))
  step(0,128)
  step(-512,-160)
  step(0,-128)
  step(144,-48)
  rightsector(0, 128, 128)
}


A {
  thing
  
  -- A
  step(0,-48)
  step(-144,-48)
  step(0,-128)
  step(512,160)
  step(0,128)
  step(-512,160)
  step(0,-128)
  step(144,-48)
  step(0,-48)
  rightsector(0, 128, 128)

}

D {
  thing
  movestep(-128,0) thing
  
  straight(mul(8,64))
  step(0,128)
  step(mul(-3,64),144)
  straight(-128)
  step(mul(-3,64),-144)
  step(0,-128)
  rightsector(0, 128, 128)
}

C {
  thing
  movestep(256, 0) -- middle line
  curve(-256,256,8,0)
  straight(128)
  left(128)
  left(128)

  twice(  curve(192,192,8,0) )
  straight(128)
  left(128)
   left(128)
  
  curve(256,-256,8,0)
  step(64,16)
  step(64,-16)
  rightsector(0, 128, 128)
}
