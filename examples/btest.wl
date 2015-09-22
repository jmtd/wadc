#"basic.h"
#"monsters.h"

main {
  undefx
  sectordefaults(0, 128, 192, 192)
  playerstartskeyedexit
  segplain(64)
  setnoisesector
  segmonstertele($tele1, $dest1, 32, 64, 512, 640, 7, demon, imp, lostsoul)
  place(64, -96, teleportlanding thing)
  typesector(0, $dest1, segplain(256))
  setbord(32, 160, 48)
  ceil("F_SKY1")
  ceilup(512)
  segbord(erightdent(32,64))
  segbordplain(512)
  curvebendbord(128,1)
  curvebendbord(128,-1)
  seg2(pushpop(rotright stairs(8, "FLAT5_1", 1) floorup(-128)) straight(getwidth),
       straight(getwidth))
  curvebendbord(128,-1)
  segbordplain(256)
  curvebendbord(256,-1)
  segbordplain(512)
  curvebendbord(160,-1)
  right(160)
  rightsector(128, getceilheight, 255)
  movestep(-512,0)
  step(-48,208)
  step(32,112)
  step(176,128)
  step(288,128)
  straight(528)
  step(576,-48)
  step(96,-256)
  step(336,-464)
  step(48,-304)
  step(-304,-736)
  step(-816,-512)
  step(-496,112)
  step(-704,496)
  step(-128,480)
  step(128,192)
  step(256,112)
  step(32,96)
  floor("LAVA1")
  leftsector(-16, getceilheight, 160)
}
