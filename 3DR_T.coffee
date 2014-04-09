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

#bla = new TSlot()
#assembly.add bla

class SmoothRodMount extends Part
  constructor:(options)->
    @defaults = {
      rodDia: 6
      height:20
      boltDia:4
      orient:0 #1: front, 0 back
    }
    options = @injectOptions(@defaults,options)
    super options
    @generate()
    
  generate:->
    boltHoleSqrBorder = 1
    boltHoleSqrW = 7 
    boltHoleSqrT = 3.2
    boltHoleSqrH = @height-5
    boltHoleSqrOffset = @rodDia/2 +4 #+ boltHoleSqrT/2
    
    nutHoleZOffset = @height-boltHoleSqrH
    nutHoleXOffset = boltHoleSqrOffset - boltHoleSqrT/2

    
    #TODO: we need nuts and bolts lib
    boltShape = new Cylinder({d:8,h:boltHoleSqrT,$fn:6})
    
    boltHoleLength = 20
    boltHolePos = 0

    @subtract new Cylinder({d:@rodDia, $fn:20,h:@height,center:[0,0,false]})
    #helper hole
    @subtract new Cube({size:[3,@boltDia,@height],center:[@rodDia/2,0,false]})
    
    #nut hole
    @subtract new Cube({size:[boltHoleSqrT,boltHoleSqrW,boltHoleSqrH],center:[boltHoleSqrOffset,0,@height-boltHoleSqrH/2]})
    #nut hole bottom
    @subtract boltShape.rotate([0,90,0]).translate( [nutHoleXOffset,0,nutHoleZOffset] )
    
    
    #bolt hole
    #@subtract new Cube({size:[3,@rodDia,@height],center:[@rodDia/2+4,0,false]})

    #mounting hole
    @subtract new Cylinder({d:@boltDia,h:boltHoleLength,center:[-@height/2,0,boltHoleLength/2]}).rotate([0,90,0])

    if @orient is 1
      @mirroredX()
    

#srM = new SmoothRodMount()
#assembly.add( srM )

class TopCorner extends Part
  constructor:(options)->
    @defaults = {
      smoothRodDia: 6,
      endBlockSize: [10,10]
      extrusionSize:[20,20]
      idlerDia : 12
      
    }
    options = @injectOptions(@defaults,options)
    @height = @extrusionSize[0]
    super options
    @generate()
    
    
  generate:->
    extrusionXOffset = 5
    angle = 60
    
    #various calculations
    flatTipWidth = 20
    theoreticalTriangleTip = []
    
    halfFlatTipW = flatTipWidth/2
    halfAngle = angle/2
    #tan(angle/2) = (flatTipWidth/2) / H
    h =  (halfFlatTipW) / Math.tan( (halfAngle*Math.PI/180) )
    
    otherFlat = 64
    halfOFlatTipW = otherFlat/2
    h2 =  (halfOFlatTipW) / Math.tan( (halfAngle*Math.PI/180) )
    console.log("h",h,"h2",h2)
    
    @add new Cube({size:1,center:[-h,0,false]}).color([1,0,0])
    @add new Cube({size:1,center:[-h2+21,0,false]}).color([1,0,0])

    
    #"safe" circle around smooth rods
    smootRodProtectionDia = @smoothRodDia + 4
    sideExtrusionStart = null
    
    
    bla = 12/2
    tSlotOffset = @extrusionSize[0]/2+extrusionXOffset
    anglingOffset = tSlotOffset + bla 
    console.log("anglingOffset",anglingOffset)
    

    sideDistY = 62
    sideDistX = anglingOffset 
    
    sideDistY2 = 75
    sideDistX2 = 30
    
    endBlockSize = @extrusionSize[0]
    cornerBlock = new Rectangle({size:[1,endBlockSize],center:[0,0]})
    
    lBlock1 = new Rectangle({size:2,center:[sideDistX,sideDistY/2]})
    rBlock1 = new Rectangle({size:2,center:[sideDistX,-sideDistY/2]})
    
    lBlock2 = new Rectangle({size:2,center:[sideDistX2,sideDistY2/2]})
    rBlock2 = new Rectangle({size:2,center:[sideDistX2,-sideDistY2/2]})
    
    baseOutline = hull([cornerBlock, lBlock1, rBlock1, lBlock2, rBlock2])
    baseOutline = baseOutline.extrude({offset:[0,0,@height]})
    @union baseOutline
    
    #vertical extrusion hole
    extrusionXPos = extrusionXOffset + @extrusionSize[0]/2
    extrusionHole = new Cube({size:[@extrusionSize[0],@extrusionSize[1],@height],center:[extrusionXPos,true,false] })
    
    extrusionHole = new TSlot({hsToShow:[true,true,false,false]})
    extrusionHole.translate([tSlotOffset,0,0])
    
    #latteral holders for t slots
    sideTSlotMountHoleDia = 4
    sideTSlotMountHoleDist = 20 #distance from the tip of the t-slot
    sideHolderLength= 45
    sideHolderWidth = 5
    sideHolderR = new Cube({size:[sideHolderLength,sideHolderWidth,@height], center:[0,0, false]})
    sideHolderR.rotate([0,0,30])
    sideHolderR.translate([sideHolderLength/2+sideDistX2/2+10,sideHolderWidth/2+sideDistY2/2-15,0])
    @union sideHolderR
    sideHolderL = sideHolderR.clone().mirroredY()
    @union sideHolderL
    
    bla = sideHolderLength
    sideBarHoleR = new Cube({size:[bla,20,@height], center:[0,0, false]})
    sideBarHoleR.rotate([0,0,30])
    sideBarHoleR.translate([bla/2+sideDistX2/2+10,10+sideDistY2/2-9,0])
    sideBarHoleR.color([1,0,0])
    #@add sideBarHoleR
    @subtract sideBarHoleR
    @subtract sideBarHoleR.clone().mirroredY()
    
    
    #hsBaseW
    @subtract extrusionHole
    
    extrusionMountDia = 5
    #extrusion mount hole reinforcement
    reinfoHeight = 2
    reinfoDia = extrusionMountDia+8
    extrusionMountHoleReinforce = new Cylinder({d:reinfoDia,h:reinfoHeight,center:[-@height/2,0,-reinfoHeight/2]}).rotate([0,90,0])
    @union extrusionMountHoleReinforce
    
    #extrusion mount hole
    extrusionMountDepth = reinfoHeight + extrusionXOffset 
    extrusionMountPos = extrusionXOffset/2 - reinfoHeight/2
    extrusionMountHole = new Cylinder({d:extrusionMountDia,h:extrusionMountDepth,center:[-@height/2,0,extrusionMountPos]}).rotate([0,90,0])
    @subtract extrusionMountHole

    #extrusion "lock" block : small square at the tip
    extrusionLockBlocLng = 6
    extrusionLockBlocHeight = (@height-extrusionMountDia)/2
    extrusionlockBlocPos = extrusionLockBlocLng/2 + extrusionXOffset 
    extrusionLockBloc = new Cube({size:[extrusionLockBlocLng,6,extrusionLockBlocHeight],center:[extrusionlockBlocPos,true,false]})
    @union extrusionLockBloc
    
    #idler rounding
    idlerHoleDepth = 6
    idlerHolePos = idlerHoleDepth + @extrusionSize[0]
    idlerDia = @height
    idlerHole = new Cylinder({d:idlerDia,h:10,center:[-@height,0,idlerHolePos]}).rotate([0,90,0])
    @subtract idlerHole
    
    
    #smooth rods #inner dist :38.78 so 38.78 + 2*3 eye to eye
    smoothRodXPos = anglingOffset+@smoothRodDia/2
    smoothRodYDist = 44.78
    
    sRMountBlockDepth = 4
    sRMountDia = 4
    
    for i in [-1,1]
      sr = new SmoothRodMount({rodDia:@smoothRodDia,height:@height,orient:1})#,boltDia:@sRMountDia,orient:1
      @subtract sr.inverse().translate([smoothRodXPos,i*smoothRodYDist/2,0])
    
      ###
      @subtract new Cylinder({d:@smoothRodDia, $fn:20,h:@height,center:[smoothRodXPos,i*smoothRodYDist/2,false]})
      #mounting cube
      @subtract new Cube({size:[2,@smoothRodDia-1,@height],center:[smoothRodXPos+@smoothRodDia/2,i*smoothRodYDist/2,false]})
      #bolt hole
      @subtract new Cube({size:[3,@smoothRodDia,@height],center:[smoothRodXPos+@smoothRodDia/2+4,i*smoothRodYDist/2,false]})
      
      #mounting hole
      @subtract new Cylinder({d:sRMountDia,h:100,center:[-@height/2,i*smoothRodYDist/2,0]}).rotate([0,90,0])
      ###
    @color([0.8,0.53,0.1])
    

class BottomCorner extends Part
  constructor:(options)->
    @defaults = {
      smoothRodDia: 6,
      endBlockSize: [10,10]
      extrusionSize:[20,20]
      idlerDia : 20
      height : 40
    }
    options = @injectOptions(@defaults,options)
    super options
    @generate()
    
    
  generate:->
    extrusionXOffset = 5
    angle = 60
    
    bla = 12/2
    tSlotOffset = @extrusionSize[0]/2+extrusionXOffset
    anglingOffset = tSlotOffset + bla 
    

    sideDistY = 62
    sideDistX = anglingOffset 
    
    sideDistY2 = 75
    sideDistX2 = 30
    
    endBlockSize = @extrusionSize[0]
    cornerBlock = new Rectangle({size:[1,endBlockSize],center:[0,0]})
    
    lBlock1 = new Rectangle({size:2,center:[sideDistX,sideDistY/2]})
    rBlock1 = new Rectangle({size:2,center:[sideDistX,-sideDistY/2]})
    
    lBlock2 = new Rectangle({size:2,center:[sideDistX2,sideDistY2/2]})
    rBlock2 = new Rectangle({size:2,center:[sideDistX2,-sideDistY2/2]})
    
    baseOutline = hull([cornerBlock, lBlock1, rBlock1, lBlock2, rBlock2])
    baseOutline = baseOutline.extrude({offset:[0,0,@height]})
    @union baseOutline
    
    #vertical extrusion hole
    extrusionXPos = extrusionXOffset + @extrusionSize[0]/2
    extrusionHole = new Cube({size:[@extrusionSize[0],@extrusionSize[1],@height],center:[extrusionXPos,true,false] })
    
    #TODO: add to options
    tSlotHeads = [true,true,true,false] #
    extrusionHole = new TSlot({height:@height, hsToShow:tSlotHeads})
    extrusionHole.translate([tSlotOffset,0,0])
    
    #latteral holders for t slots
    sideTSlotMountHoleDia = 4
    sideTSlotMountHoleDist = 20 #distance from the tip of the t-slot
    sideHolderLength= 45
    sideHolderWidth = 5
    sideHolderR = new Cube({size:[sideHolderLength,sideHolderWidth,@height], center:[0,0, false]})
    sideHolderR.rotate([0,0,30])
    sideHolderR.translate([sideHolderLength/2+sideDistX2/2+10,sideHolderWidth/2+sideDistY2/2-15,0])
    @union sideHolderR
    sideHolderL = sideHolderR.clone().mirroredY()
    @union sideHolderL
    
    bla = sideHolderLength
    sideBarHoleR = new Cube({size:[bla,20,@height], center:[0,0, false]})
    sideBarHoleR.rotate([0,0,30])
    sideBarHoleR.translate([bla/2+sideDistX2/2+10,10+sideDistY2/2-9,0])
    sideBarHoleR.color([1,0,0])
    #@add sideBarHoleR
    @subtract sideBarHoleR
    @subtract sideBarHoleR.clone().mirroredY()
    
    
    #hsBaseW
    @subtract extrusionHole
    
    extrusionMountDia = 5
    #extrusion mount hole reinforcement
    reinfoHeight = 2
    reinfoDia = extrusionMountDia+8
    extrusionMountHoleReinforce = new Cylinder({d:reinfoDia,h:reinfoHeight,center:[-@height/2,0,-reinfoHeight/2]}).rotate([0,90,0])
    @union extrusionMountHoleReinforce
    
    #extrusion mount hole
    extrusionMountDepth = reinfoHeight + extrusionXOffset 
    extrusionMountPos = extrusionXOffset/2 - reinfoHeight/2
    extrusionMountHole = new Cylinder({d:extrusionMountDia,h:extrusionMountDepth,center:[-@height/2,0,extrusionMountPos]}).rotate([0,90,0])
    @subtract extrusionMountHole

    #extrusion "lock" block : small square at the tip
    extrusionLockBlocLng = 6
    extrusionLockBlocHeight = (@height-extrusionMountDia)/2
    extrusionlockBlocPos = extrusionLockBlocLng/2 + extrusionXOffset 
    extrusionLockBloc = new Cube({size:[extrusionLockBlocLng,6,extrusionLockBlocHeight],center:[extrusionlockBlocPos,true,false]})
    @union extrusionLockBloc
    
    #idler rounding
    idlerHoleDepth = 6
    idlerHolePos = idlerHoleDepth + @extrusionSize[0]
    idlerHoleZPos = -@height/2
    idlerDia = @idlerDia
    idlerHole = new Cylinder({d:idlerDia,h:10,center:[idlerHoleZPos,0,idlerHolePos]}).rotate([0,90,0])
    @subtract idlerHole
    
    
    #smooth rods #inner dist :38.78 so 38.78 + 2*3 eye to eye
    smoothRodXPos = anglingOffset+@smoothRodDia/2
    smoothRodYDist = 44.78
    
    sRMountBlockDepth = 4
    sRMountDia = 4
    
    #TODO: add to options
    smoothRodMounts = true
    if smoothRodMounts
      for i in [-1,1]
        sr = new SmoothRodMount({rodDia:@smoothRodDia,height:@height,orient:1})#,boltDia:@sRMountDia,orient:1
        @subtract sr.inverse().translate([smoothRodXPos,i*smoothRodYDist/2,0])
      
    @color([0.8,0.53,0.1])

topCorner = new TopCorner()
assembly.add( topCorner )

#bottomCorner = new BottomCorner()
#assembly.add( bottomCorner)


    