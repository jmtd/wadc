/*
 * This is an unfinished attempt to recreate pipes/usepipes from
 * memory, started at some point after 2006 but never finished.
 *
 * The routines are a lot simpler and cleaner. I didn't do the
 * deep water stuff (but that's since been reworked into water.h)
 *                                                 -- jmtd
 */

#"standard.h"
#"monsters.h"

monsters(num) {
  pushpop(
    movestep(64,64)
    for(1,num,
      movestep(0,72) thing
    )
  )
}

sewerinit {
  set("sewerwidth", 192)
  set("sewerfloor", 0)
  set("sewerceil", 160)
  set("sewerbar_spacing", div(sub(get("sewerwidth"), mul(3,24)),4))
}

sewerpipe(length) {
  box(get("sewerfloor"),get("sewerceil"),160,
      length, get("sewerwidth"))
  move(length)
}

sewertrigger(length,type,tag) {
  !sewertrigger
  sewerpipe(length)
  ^sewertrigger
  movestep(8,8)
  linetype(type,tag)
  ibox(get("sewerfloor"),get("sewerceil"),160, 64,
       sub(get("sewerwidth"),16))
  linetype(0,0)
  popsector

  ^sewertrigger
  move(length)
}

sewerbars() {
  sewerpipe(64)
  !sewerbars

  move(-64)
  top("SUPPORT3")
  movestep(20,0)
  for(1,3,
    movestep(0,get("sewerbar_spacing"))
    xoff(0)
    ibox( get("sewerfloor"), get("sewerfloor"), 160,24,24)
    popsector
    movestep(0,24)
  )
  ^sewerbars
}

sewerleft {
  curve(128,-128, 16, 1)
  !sewerleft
  right(get("sewerwidth"))
  rotright
  curve(
    add(128,get("sewerwidth")),
    add(128,get("sewerwidth")),
    16, 1)
  rightsector(get("sewerfloor"),get("sewerceil"),160)
  ^sewerleft
}

sewerright {
  curve(
    add(128,get("sewerwidth")),
    add(128,get("sewerwidth")),
    16, 1)
  !sewerright
  right(get("sewerwidth"))
  rotright
  curve(128,-128, 16, 1)
  rightsector(get("sewerfloor"),get("sewerceil"),160)
  ^sewerright
}

sewertee(l,r) {
  curve(128,-128, 16, 1)
  l
  rotright
  straight(get("sewerwidth"))
  rotright
  straight(add(mul(2,128), get("sewerwidth")))
  r
  right(get("sewerwidth"))
  rotright
  curve(128,-128, 16, 1)
  rightsector(get("sewerfloor"),get("sewerceil"),160)
}

sewermain {

  sewerinit

  thing movestep(-64,-64)
  box(0,192,160, 128, 256)
  movestep(add(get("sewerwidth"),128), -256)
  rotright

  !start
  turnaround
  movestep(0,mul(-1, get("sewerwidth")))
  sewerpipe(192)
  sewertee(!left, !right)
  ^left sewerbars sewerleft sewerpipe(512)
  ^right sewerbars sewerright twice( sewerleft )

  ^start
  sewerpipe(mul(3,256))
  sewerbars
  sewerpipe(256)
  sewerleft
  sewerpipe(512)
  sewertee(!left, !right)

  ^right
  sewerbars
  twice( sewerleft )

  ^left
  sewerpipe(128)
  -- change floor height
  set("sewerfloor", -512)
  sewerpipe(get("sewerwidth"))
  !floor3
  set("sewerfloor", 0)
  sewerbars
  sewerleft sewerpipe(256)

  ^floor3
  set("sewerfloor", -512)
  set("sewerceil", add(192,-512))
  movestep(mul(-1,get("sewerwidth")),0) rotleft
  sewerbars
  sewerpipe(256)
  sewerright
  sewerpipe(256)

  ^floor3
  rotright movestep(get("sewerwidth"),0)
  sewerpipe(256)
  sewerleft
  sewerpipe(256) -- eventually rocket secret
  sewerpipe(128)

  !floor3trap
  sewertrigger(768, 109, $traptag)
  sewerbars
  sewerright sewerbars sewerright
  ^floor3trap
  movestep(add(512,128),add(-256,-8)) rotright
  traproom
  ^floor3trap
  movestep(128,add(get("sewerwidth"), add(8, 256))) rotleft
  traproom
}

traproom {
  box(get("sewerfloor"),add(128,get("sewerfloor")),160, 256,512)
  formersergeant
  monsters(4)
  move(256)
  sectortype(0,$traptag) mid("doortrak")
  box(get("sewerfloor"),get("sewerfloor"),160, 8, 512)
  sectortype(0,0)
}
