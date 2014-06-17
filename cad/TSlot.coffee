 

class TSlot extends Part
  constructor:(options)->
    @defaults = {
      width: 20,
      depth: 20
      height:30
      centerHole:false
      hsToShow:[true,true,true,true]
      hsHeights:[null,null,null,null]#hack
      hsFootOnly:[false,false,false,false]#only draw rectangle "foot"
      
      fudge:true#if too tight when printing (a negative), turn this on
      generateAtConstruct:true
    }
    options = @injectOptions(@defaults,options)
    super options
    
    realHsHeights=[]
    for height in @hsHeights
      if height == null
        realHsHeights.push(@height)
      else
        realHsHeights.push(height)
    @hsHeights = realHsHeights
    console.log(@hsHeights)
    
    #hardcoded values for the shape of the "hammerhead"
    @hsBaseW = 12
    @hsBaseH = 1
    @hsHeight = 4
    @hsFootW = 6
    @hsFootH = 2
    
    if @generateAtConstruct
      @generate()
    
  generate:->
    #hs : hammershape
    width = @width
    depth = @depth
    centerDia = 4.2
    
    hsBaseW = @hsBaseW
    hsBaseH = @hsBaseH
    hsHeight = @hsHeight
    
    hsFootW = @hsFootW
    hsFootH = @hsFootH
    hsShapeLength = (hsHeight + hsFootW)
    
    offset = 0.0
    if @fudge
      offset = 0.2
      hsBaseW = hsBaseW-offset
      hsHeight = hsHeight-offset-0.3
      hsFootW = hsFootW - offset
      hsBaseH = hsBaseH-0.6
      
      width += offset/1.5
      depth += offset/1.5
    
    hsFootPos = hsFootH/2
    hsBasePos = hsFootH + hsBaseH/2
    hsTipPos = hsFootH + hsHeight/2
    
    
    hsFoot = new Rectangle({size:[hsFootW,hsFootH+offset*2],center:[0,hsFootPos]})
    hsBase = new Rectangle({size:[hsBaseW,hsBaseH],center:[0,hsBasePos+offset]})
    hsTip = new Rectangle({size:[hsFootW,hsHeight],center:[0,hsTipPos+offset]})
    
    hs = hull( [hsBase,hsTip] )
    hShape = hs.union [hsFoot]
    
    #simple hammershape : ie just a rectangle
    hsSimple = new Rectangle({size:[hsFootW,hsFootH+hsHeight],center:[0,hsFootPos]})
    
    baseShape = new Rectangle({size:[width,depth],center:true})
    baseShape = baseShape.extrude({offset:[0,0,@height]})
    @union baseShape
    
    if @hsToShow[0]
      hs = hShape
      if @hsFootOnly[0]
        hs = hsSimple
      notch = hs.clone()
      notch.translate( [0,-hsShapeLength] )
      notch = notch.extrude({offset:[0,0,@hsHeights[0]]})
      @subtract( notch )
    
    if @hsToShow[1]
      hs = hShape
      if @hsFootOnly[1]
        hs = hsSimple
      notch = hs.clone()
      notch.rotateZ(180).translate( [0,hsShapeLength] )
      notch = notch.extrude({offset:[0,0,@hsHeights[1]]})
      @subtract( notch )
    
    if @hsToShow[2]
      hs = hShape
      if @hsFootOnly[2]
        hs = hsSimple
      notch = hs.clone()
      notch.rotateZ( 90 ).translate( [hsShapeLength,0] )
      notch = notch.extrude({offset:[0,0,@hsHeights[2]]})
      @subtract( notch )
    
    
    if @hsToShow[3]
      hs = hShape
      if @hsFootOnly[3]
        hs = hsSimple
      notch = hs.clone()
      notch.rotateZ( -90 ).translate( [-hsShapeLength,0] )
      notch = notch.extrude({offset:[0,0,@hsHeights[3]]})
      @subtract( notch )
      
    
    if @centerHole
      @subtract new Cylinder({d:centerDia,h:@height})
