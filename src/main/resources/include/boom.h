/*
 * boom.h - part of WadC
 * Copyright © 2016 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 *
 * Boom-specific stuff, such as generalised linedef calculators
 *
 * Flag values (some at least):
        Trigger Type: 0=W1, 1=WR, 2=S1, 3=SR, 4=G1, 5=GR, 6=D1, 7=DR
        monster activation Y = 1 N = 0
        Speed: 0=Slow, 1=Normal, 2=Fast, 3=Turbo

        Direction up=1 down=2
        Floor/Ceiling changes:
        0=none, 1=zero type 2=texture only 3=texture & type

        Floor Target: 0:HnF 1:LnF, 2:NnF, 3:LnC, 4:C 5:sT 6:24 7:32
        Ceiling Target: 0:HnC 1:LnC, 2:NnC, 3:HnF, 4:F 5:sT 6:24 7:32
        Lift Target: 0:LnF 1:NnF, 2:LnC, 3:Perpetual

        Lift Delay: 0=1 sec, 1=3 sec, 2=5 sec, 3=10 sec
        Door Delay: 0=1 sec, 1=4 sec, 2=9 sec, 3=30 sec
*/

#"math.h"

GenFloorBase    { 0x6000 }
GenCeilingBase  { 0x4000 }
GenDoorBase     { 0x3c00 }
GenLockedBase   { 0x3800 }
GenLiftBase     { 0x3400 }
GenStairsBase   { 0x3000 }
GenCrusherBase  { 0x2F80 }

LiftTargetShift     {   8 }
LiftDelayShift      {   6 }
LiftMonsterShift    {   5 }
LiftSpeedShift      {   3 }

genlift(trigger, target, delay, monster, speed) {
    add(GenLiftBase,
    add(trigger,
    add(lshift(target, LiftTargetShift),
    add(lshift(delay, LiftDelayShift),
    add(lshift(monster, LiftMonsterShift),
        lshift(speed, LiftSpeedShift)
    )))))
}

FloorSpeedShift { 3 }
FloorModelShift { 5 }
FloorDirectShift{ 6 }
FloorTargetShift{ 7 }
FloorChangeShift{ 10 }
FloorCrushShift { 12 }

genfloor(trigger, speed, model, direct, target, change, crush) {
    add(GenFloorBase,
    add(trigger,
    add(lshift(speed, FloorSpeedShift),
    add(lshift(model, FloorModelShift),
    add(lshift(direct, FloorDirectShift),
    add(lshift(target, FloorTargetShift),
    add(lshift(change, FloorChangeShift),
        lshift(crush,  FloorCrushShift)
    )))))))
}

-- XXX same as floors
CeilingSpeedShift { 3 }
CeilingModelShift { 5 }
CeilingDirectShift{ 6 }
CeilingTargetShift{ 7 }
CeilingChangeShift{ 10 }
CeilingCrushShift { 12 }

genceiling(trigger, speed, model, direct, target, change, crush) {
    add(GenCeilingBase,
    add(trigger,
    add(lshift(speed, CeilingSpeedShift),
    add(lshift(model, CeilingModelShift),
    add(lshift(direct, CeilingDirectShift),
    add(lshift(target, CeilingTargetShift),
    add(lshift(change, CeilingChangeShift),
        lshift(crush,  CeilingCrushShift)
    )))))))
}

DoorSpeedShift   { 3 }
DoorKindShift    { 5 }
DoorMonsterShift { 7 }
DoorDelayShift   { 8 }

gendoor(trigger, speed, kind, monster, delay) {
    add(GenDoorBase,
    add(trigger,
    add(lshift(speed, DoorSpeedShift),
    add(lshift(kind, DoorKindShift),
    add(lshift(monster, DoorMonsterShift),
        lshift(delay, DoorDelayShift)
    )))))
}

LockedSpeedShift { 3 }
LockedKindShift  { 5 }
LockedLockShift  { 6 }
LockedSkCkShift  { 9 } -- distinguish keycard/skullcard

gen_locked_door(trigger, speed, kind, lock, skck) {
    add(GenLockedBase,
    add(trigger,
    add(lshift(speed, LockedSpeedShift),
    add(lshift(kind,  LockedKindShift),
    add(lshift(lock,  LockedLockShift),
        lshift(skck, LockedSkCkShift)
    )))))
}

StairsSpeedShift { 3 }
StairsMonsterShift { 5 }
StairsStepShift { 6 }
StairsDirShift { 8 }
StairsIgnTxt { 9 } -- ignore texture

gen_stairs(trigger, speed, monster, step, direction, igntxt) {
    add(GenStairsBase,
    add(trigger,
    add(lshift(speed, StairsSpeedShift),
    add(lshift(monster, StairsMonsterShift),
    add(lshift(step, StairsStepShift),
    add(lshift(direction, StairsDirShift),
        lshift(igntxt, StairsIgnTxt)
    ))))))
}

CrushSpeedShift   { 3 }
CrushMonsterShift { 5 }
CrushSilentShift  { 6 }

gen_crusher(trigger, speed, monster, silent) {
    add(GenCrusherBase,
    add(trigger,
    add(lshift(speed, CrushSpeedShift),
    add(lshift(monster, CrushMonsterShift),
        lshift(silent, CrushSilentShift)
    ))))
}
