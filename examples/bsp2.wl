#"standard.h"
/* binary space partitioning experiment! */

minhoz  { 256 }

main
{
  bsp(2048, 2048, 0)
  pushpop( movestep(32,32) thing)
}

-- always split vertically (rotate in recursion)
bsp(x, y, depth)
{
  bsp_(x, y, depth, rand(minhoz,sub(y,minhoz)))
}
bsp_(x, y, depth, _split)
{
    print(cat(depth,cat(",",cat(y,cat(",",_split)))))

    movestep(0,_split)
    rotleft

    ifelse(lessthaneq(_split, minhoz),
       box(sub(0, mul(depth,8)), 128, 160, _split, x),  
       bsp(_split, x, add(depth,1))
    )

    rotright
    movestep(x,0) 
    rotright

    ifelse(lessthaneq(_split, minhoz),
      box(sub(0, mul(depth,8)), 128, 160, sub(y,_split), x),
      bsp(sub(y,_split), x, add(depth,1))
    )

    rotright
    movestep(x,_split)
    turnaround
}
