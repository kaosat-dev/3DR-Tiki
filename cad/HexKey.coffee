 
#TODO: this would be a good candidate for path extrude
#TODO: or rotate extrude
###
#*Dimentions for M3 by default
# * see here : http://www.meadinfo.org/2010/10/allen-key-sizes-ln-key-dimensions.html
###
class HexKey extends Part
  constructor:(options)->
    @defaults = {
      width: 20,
      depth:30
      
      generateAtConstruct:true
    }
    options = @injectOptions(@defaults,options)
    super options
    
    if @generateAtConstruct
      @generate()
      
  generate:->
    handleLength = 56
    headLength = 18
    dia = 3
    totalLength=handleLength+dia/2
    totalDepth = headLength+dia/2
    
    handle = new Cylinder({d:dia,$fn:6,h:handleLength})
    handle.rotate([0,0,90])
    
    head  = new Cylinder({d:dia,$fn:6,h:headLength})
    head.rotate([0,0,90])
    head.rotate([0,-90,0])
    head.translate([-dia/2,0,handleLength+dia/2])
    
    @union handle
    @union head
    @rotate [-90,0,-90]
    @translate [-totalLength,-totalDepth,0]