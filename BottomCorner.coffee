 


class BottomCorner extends CornerBase
  constructor:(options)->
    @defaults = {
      height : 40
      smoothRodMounts:false
      tSlotHeads:[true,true,true,false]
    }
    options = @injectOptions(@defaults,options)
    super options
    
  generate_:->
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

