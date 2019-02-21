#"standard.h"


randprint {  print(1|2|3|4|5|6|7|8|9|0) }
main {
  randprint    -- this should be different on re-runs

  print(rand(0,2))  -- this should print one of {0,1,2}
  print(rand(-2,2)) -- this should print one of {-2,-1,0,1,2}

  seed (1337)
  randprint    -- this should always be the same
  seed (5)
  randprint    -- this should always be the same
}
