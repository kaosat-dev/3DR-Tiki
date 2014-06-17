 

class TNut extends Nut
  constructor:(options)->
    @defaults = {
      thickness:3.2
      holeDia:4
      headDia:7.66
      length:10
      variant:"M3"
      
      generateAtConstruct:true
      outlineOnly:false
    }
    options = @injectOptions(@defaults,options)
    super options
    
    if @generateAtConstruct
      @generate()
      
  generate:->
    nut = new Nut({outlineOnly:true,variant:@variant})
    tNut = new TSlot({height:@length,hsToShow:[false,false,true,false],invert:true})
    tNut.rotate [0,-90,0]
    zOffset = 4.3#tNut.realDepth/2-(tNut.realhsBaseH+tNut.realhsHeight)#4.3
    #console.log "hsShapeLength",tNut.hsShapeLength, zOffset, tNut.realhsBaseH,tNut.realhsHeight, tNut.hsFootH
    #tNut.translate [-zOffset,0,0]
    tNut.translate [@length/2,0,-zOffset]
    tNut.subtract nut
    
    hole = new Cylinder({d:nut.holeDia,h:20,center:[true,true,false]})
    tNut.subtract hole
    @union tNut