#"list.wl"

-- tuples.

tuple_eq(ta, tb) {
  eq( hd(ta), hd(tb) )
      ? eq( tl(ta), tl(tb) )
      : 0
}
