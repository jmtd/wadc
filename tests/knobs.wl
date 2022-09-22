#"standard.h"

main
{
  -- the first time a knob is evaluated, the value should
  -- match what is provided
  assert(eq(10, knob("foo", 0, 10, 10)))

  -- the second time it's evaluated, the value should be
  -- ignored and the previous value picked
  assert(eq(10, knob("foo", 0, 8, 10)))

  -- however, the value should be clamped at max...
  assert(eq(5, knob("foo", 0, 8, 5)))

  -- check clamping at the min
  assert(eq(2, knob("bar", 0, 2, 10)))
  assert(eq(5, knob("bar", 5, 2, 10)))
}
