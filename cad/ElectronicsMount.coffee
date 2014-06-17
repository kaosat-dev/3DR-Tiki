 

###
*Motherboard mount system (Rumba)
###
class ElectronicsMount extends Part
  constructor:(options)->
    @defaults = {
      
      length:17#74
      width:10
      height:30
      thickness:6
      
      #for the electronics
      mountHoleDia:3.1
      mountHoles:2
      mountHolesDist:65#center to center
      nutHolesOnTop:false
      
      structMountHoleDia:4.1
      structMountHoles:2
      structMountHolesDist:75
      
      generateAtConstruct:true
    }
    options = @injectOptions(@defaults,options)
    super options
    
    if @generateAtConstruct
      @generate()
  
  
  generate:->
    thickness = @thickness
    width = @width
    height = @height
    elecMount = new Cube({size:[@length,@width+@thickness,@thickness],center:[true,false,false]})
    structMount = new Cube({size:[@length+15,@thickness,@height],center:[true,true,false]})
    
    #@union elecMount
    #@union structMount
    
    ###
    for i in [0...@mountHoles]
      mountHole = new Cylinder({d:@mountHoleDia,h:@thickness,$fn:15})
      mountHole.translate [@mountHolesDist/2*(-i*2+1),thickness+width/2,0]
      @subtract mountHole
      
      nut = new Nut({outlineOnly:true})
      nut.translate [@mountHolesDist/2*(-i*2+1),thickness+width/2,0]
      @subtract nut

      
    for i in [0...@structMountHoles]
      mountHole = new Cylinder({d:@structMountHoleDia,h:thickness,$fn:15,center:[true,true,false]})
      mountHole.rotate [90,0,0]
      mountHole.translate [@structMountHolesDist/2*(-i*2+1),thickness/2,height/2]
      
      @subtract mountHole
    ###
    
    #testshape
    nut = new Nut({outlineOnly:true})
    structMountHoleHeight = height-10  #thickness+nut.headDia/2
    
    
    borders=5
    shapeWidth = @mountHoleDia + borders
    shapeLength = @length #30 #15#30#50
    blockLength = shapeLength-shapeWidth/2
    
    endingShape = new Cylinder({d:shapeWidth,h:@thickness,center:[true,true,false]})
    elecMount = new Cube({size:[shapeWidth,blockLength,@thickness],center:[true,false,false]})
    structMount = new Cube({size:[shapeWidth,@thickness,@height],center:[true,true,false]})

    
    for i in [0...@structMountHoles]
      mountHole = new Cylinder({d:@structMountHoleDia,h:thickness,$fn:15,center:[true,true,false]})
      mountHole.rotate [90,0,0]
      mountHole.translate [0,thickness/2,structMountHoleHeight]
      structMount.subtract mountHole

    endingShape.union elecMount
    structMount.translate [0,blockLength]
    endingShape.union structMount
    @union endingShape


    holeWidth = @mountHoleDia
    holeLength = blockLength- thickness #shapeLength-4
    blockLength = holeLength - holeWidth/2
    nutHoleTmpl = new Nut({outlineOnly:true,variant:"M3"})
    
    endingHole = new Cylinder({d:holeWidth,h:@thickness,center:[true,true,false]})
    elecHole = new Cube({size:[holeWidth,blockLength,@thickness],center:[true,false,false]})
    
    nutHole = new Cube({size:[nutHoleTmpl.headDia,blockLength,nutHoleTmpl.thickness],center:[true,false,false]})
    nutHoleEnd = new Cylinder({d:nutHoleTmpl.headDia,h:nutHoleTmpl.thickness,center:[true,true,false]})
    nutHole.union nutHoleEnd
    nutHole.translate [0,(nutHoleTmpl.headDia-holeWidth)/2,0]
    if @nutHolesOnTop
      nutHole.translate [0,0,thickness-nutHoleTmpl.thickness]
    
    endingHole.union elecHole
    endingHole.union nutHole
    #endingHole.translate [0,-thickness/2,0]
    @subtract endingHole
    
    
    

