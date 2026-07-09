///|
fn moontown_map_page_methods_js() -> String {
  "  onLoad(){\n" +
  "    this.__mc(this.data.mapViewport.x,this.data.mapViewport.y,this.data.mapViewport.scale)\n" +
  "  },\n" +
  "  onMoontownMapTouchStart(e){\n" +
  "    const t=e.touches||[]\n" +
  "    if(!t.length)return\n" +
  "    const v=this.data.mapViewport\n" +
  "    if(t.length>1){\n" +
  "      const c=this.__tc(t)\n" +
  "      const k=this.__mk(v.scale)\n" +
  "      this.__mt={n:2,d:this.__td(t),s:v.scale,ax:(c.x-v.x)/k,ay:(c.y-v.y)/k}\n" +
  "    }else{\n" +
  "      this.__mt={n:1,x:t[0].clientX,y:t[0].clientY,vx:v.x,vy:v.y,s:v.scale}\n" +
  "    }\n" +
  "  },\n" +
  "  onMoontownMapTouchMove(e){\n" +
  "    const t=e.touches||[]\n" +
  "    const m=this.__mt\n" +
  "    if(!m||!t.length)return\n" +
  "    if(t.length>1&&m.n===2){\n" +
  "      const c=this.__tc(t)\n" +
  "      const s=this.__cl(m.s*this.__td(t)/(m.d||1),2.6,3.4)\n" +
  "      const k=this.__mk(s)\n" +
  "      this.__mc(c.x-m.ax*k,c.y-m.ay*k,s)\n" +
  "    }else{\n" +
  "      this.__mc(m.vx+t[0].clientX-m.x,m.vy+t[0].clientY-m.y,m.s)\n" +
  "    }\n" +
  "  },\n" +
  "  onMoontownMapTouchEnd(){\n" +
  "    this.__mt=null\n" +
  "  },\n" +
  "  __mc(x,y,scale){\n" +
  "    const s=this.__cl(scale,2.6,3.4)\n" +
  "    const fit=(rawX,rawY)=>{\n" +
  "      const win=this.__wi()\n" +
  "      const k=this.__mk(s)\n" +
  "      const vw=win.windowWidth/k\n" +
  "      const vh=win.windowHeight/k\n" +
  "      const sx=this.__cl(-Number(rawX||0)/k,0,Math.max(0,1400-vw))\n" +
  "      const sy=this.__cl(-Number(rawY||0)/k,0,Math.max(0,880-vh))\n" +
  "      return {x:-sx*k,y:-sy*k}\n" +
  "    }\n" +
  "    const next=fit(x,y)\n" +
  "    this.setData({'mapViewport.x':next.x,'mapViewport.y':next.y,'mapViewport.scale':s,'mapViewport.style':'transform:translate('+next.x+'px,'+next.y+'px) scale('+s+')'})\n" +
  "  },\n" +
  "  __wi(){\n" +
  "    return this.__mw||(this.__mw=(wx.getWindowInfo?wx.getWindowInfo():wx.getSystemInfoSync()))\n" +
  "  },\n" +
  "  __mk(scale){\n" +
  "    return 2*scale*this.__wi().windowWidth/750\n" +
  "  },\n" +
  "  __tc(t){\n" +
  "    return {x:(t[0].clientX+t[1].clientX)/2,y:(t[0].clientY+t[1].clientY)/2}\n" +
  "  },\n" +
  "  __td(t){\n" +
  "    const dx=t[0].clientX-t[1].clientX\n" +
  "    const dy=t[0].clientY-t[1].clientY\n" +
  "    return Math.sqrt(dx*dx+dy*dy)\n" +
  "  },\n" +
  "  __cl(value,min,max){\n" +
  "    return Math.max(min,Math.min(max,Number(value||0)))\n" +
  "  },\n"
}
