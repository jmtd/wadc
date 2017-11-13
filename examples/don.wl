/*
 * don.wl: Gothic-style pyramid structures by Aardappel
 * part of WadC
 *
 * Copyright © 2000 Wouter van Oortmerssen
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 * 
 * requires Q1TEX.WAD to play
 */

#"standard.h"

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

secch1 { floor("CFLOOR1") ceil("CITYF17") }
secch2 { floor("WOODF4") ceil("CITYF17") }
secmet8 { floor("METALF07") ceil("METALF07") }
secmet16 { floor("METALF18") ceil("METALF18") }
sechall { floor("METALF11") ceil("WOODF8") }

water { floor("QWATER1") }
sky { ceil("F_SKY1") }
green { floor("QGRASS") wall("QROCK4") }
stonefl { floor("WALLF1") }
metfl { floor("METALF18") }

brick { wall("QCITY01") }
brick2 { wall("QBRICK5") }
column { wall("QCOLUMN") }
met8w { wall("QMET01") }
chouter { wall("QMET13") }
chouter2 { wall("QMET16") }
chwindow { mid("QWINDOW4") }
smalllite { mid("LITE5") }


