#"list.wl"



blockmap_init {
    set("blockmap", nil)
}

tuple_eq(ta, tb) {
  eq( hd(ta), hd(tb) )
      ? eq( tl(ta), tl(tb) )
      : 0
}

-- is elem in the supplied list?
tuple_in_list(elem, list) {
   eq(nil, list
       ? 0
       : tuple_eq(elem, hd(list))
         ? 1
         : in_list(elem, tl(list))
         )
     )
}

blockmap_mark(x,y) {
  if(in_list(
}

room(x,y) {

   eq(nil, get("blockmap"))
       ? y
       : cons(hd(x), append(tl(x), y))

    box(0,128,128, 128, 128)
}

main {

  blockmap_init

  -- first room: should work
  room(0,0)

  -- second room, same coords: should fail
  room(0,0)

}
