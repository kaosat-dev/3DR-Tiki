 

class SmoothRodMount extends Part
  constructor:(options)->
    @defaults = {
      rodDia: 6
      height:20
      boltDia:4
      orient:0 #1: front, 0 back
      rodOnly : false
    }
    options = @injectOptions(@defaults,options)
    super options
    @generate()
    
  generate:->
    boltHoleSqrBorder = 1
    boltHoleSqrW = 7 
    boltHoleSqrT = 3.2
    boltHoleSqrH = @height-5
    boltHoleSqrOffset = @rodDia/2 +3 #+ boltHoleSqrT/2
    
    nutHoleZOffset = @height-boltHoleSqrH
    nutHoleXOffset = boltHoleSqrOffset - boltHoleSqrT/2

    
    #TODO: we need nuts and bolts lib
    boltShape = new Cylinder({d:8,h:boltHoleSqrT,$fn:6})
    
    boltHoleLength = 20
    boltHolePos = 0

    @subtract new Cylinder({d:@rodDia, $fn:20,h:@height,center:[0,0,false]})
    #helper hole
    @subtract new Cube({size:[1,@boltDia,@height],center:[@rodDia/2,0,false]})
    
    if not @rodOnly
      #nut hole
      @subtract new Cube({size:[boltHoleSqrT,boltHoleSqrW,boltHoleSqrH],center:[boltHoleSqrOffset,0,@height-boltHoleSqrH/2]})
      #nut hole bottom
      @subtract boltShape.rotate([0,90,0]).translate( [nutHoleXOffset,0,nutHoleZOffset] )
      
      #mounting hole
      @subtract new Cylinder({d:@boltDia,h:boltHoleLength,center:[-@height/2,0,boltHoleLength/2]}).rotate([0,90,0])

    if @orient is 1
      @mirroredX()
    
