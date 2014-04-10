 

class TSlot extends Part
  constructor:(options)->
    @defaults = {
      width: 20,
      depth: 20
      height:30
      centerHole:false
      hsToShow:[true,true,true,true]
    }
    options = @injectOptions(@defaults,options)
    super options
    @generate()
    
  generate:->
    #hs : hammershape
    centerDia = 4.2
    
    hsBaseW = 12
    hsBaseH = 1
    hsHeight = 4
    
    hsFootW = 6
    hsFootH = 2
    hsShapeLength = (hsHeight + hsFootW)
    
    hsFootPos = hsFootH/2
    hsBasePos = hsFootH + hsBaseH/2
    hsTipPos = hsFootH + hsHeight/2
    
    
    hsFoot = new Rectangle({size:[hsFootW,hsFootH],center:[0,hsFootPos]})
    hsBase = new Rectangle({size:[hsBaseW,hsBaseH],center:[0,hsBasePos]})
    hsTip = new Rectangle({size:[hsFootW,hsHeight],center:[0,hsTipPos]})
    
    hs = hull( [hsBase,hsTip] )
    hs = hs.union [hsFoot]
    @hsBaseW = hsBaseW
    
    
    baseShape = new Rectangle({size:[@width,@depth],center:true})
    
    if @hsToShow[0]
      notch = hs.clone()
      notch.translate( [0,-hsShapeLength] )
      baseShape.subtract( notch )
    
    if @hsToShow[1]
      notch = hs.clone()
      notch.rotateZ(180).translate( [0,hsShapeLength] )
      baseShape.subtract( notch )
    
    if @hsToShow[2]
      notch = hs.clone()
      notch.rotateZ( 90 ).translate( [hsShapeLength,0] )
      baseShape.subtract( notch )
    
    
    if @hsToShow[3]
      notch = hs.clone()
      notch.rotateZ( -90 ).translate( [-hsShapeLength,0] )
      baseShape.subtract( notch )
      
    baseShape = baseShape.extrude({offset:[0,0,@height]})
    @union baseShape
    
    if @centerHole
      @subtract new Cylinder({d:centerDia,h:@height})

