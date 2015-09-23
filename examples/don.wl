#"standard.h"
#"quaketextures.h"

main {
  thing
  pair
  move(64)
  pair
  move(64)
  pair
  move(64)
  pair
  up step(-224, add(512, 96)) down
  pair
  move(-512)
  pair
  move(-512)
  pair
  move(-512)
  pair
}

pair {
  omega_shadow(64, 32, 8, 256, 0)
  move(224)
  turnaround
  omega_shadow(64, 32, 8, 256, 0)
  turnaround
}

omega_shadow(jut, width, times, light, floorlev) {
  bot("QMET01")
  !poo
  move(16)
  straight(add(32, width))
  ^poo
  omegashadowaux(jut, width, times, light, floorlev)
}

omegashadowaux(jut, width, times, light, floorlev) {
  eq(times, 0)?0:
  omega(jut, width, light, floorlev)
  omegashadowaux(add(32, jut), add(32, width),
                 sub(times, 1), sub(light, 16), sub(floorlev, 8))
}

omega(jut, width, light, floorlev) {
  straight(16)
  left(jut)
  eright(16)
  straight(width)
  eright(16)
  straight(jut)
  rightsector(floorlev, 128, light)
  left(16)
  move(sub(0, add(80, width)))
}
  
