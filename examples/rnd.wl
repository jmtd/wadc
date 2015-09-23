#"standard.h"

main {
  line(1024,1024)
}

line(x,y) {
  line2(x,y,{ 2 | 3 | 4 },{ 2 | 3 | 4 })
}

line2(x,y,xsub,ysub) {
  line3(div(mul(div(x,8),sub(8,xsub)),2),mul(div(x,8),xsub),
        div(mul(div(y,8),sub(8,ysub)),2),mul(div(y,8),ysub))  
}

line3(xrest,xmid,yrest,ysub) {
  1
}

solid(x,y) { 0 }

empty(x,y) {
  box(x,y)
}

