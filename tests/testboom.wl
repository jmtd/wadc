#"standard.h"
#"boom.h"
#"sectors.h"

-- zdoom (and UDMF) shift the generalised sector bits up 3 places.
-- test that we handle this.

main
{
  assert(eq(257, gen_sector(light_random_off, 0, 0, 1, 0)))
  hexenformat
  assert(eq(2049, gen_sector(light_random_off, 0, 0, 1, 0)))
}
