 

class CornerBase extends Part
  constructor:(options)->
    @defaults = {
      smoothRodDia: 6,
      endBlockSize: [10,10]
      extrusionSize:[20,20]
      idlerDia : 19.5
      idlerCentered:true
      height : 20
      smoothRodMounts : true
      smoothRodAngle : 0
      smoothRodYDist : 44.78
      tSlotHeads : [true,true,false,false]
      
    }
    options = @injectOptions(@defaults,options)
    #@height = @extrusionSize[0]
    super options
    @generate()
    
    
  generate:->
    extrusionXOffset = 5
    angle = 60
    extrusionWidth = @extrusionSize[1]

    
    bla = 12/2 # tslot.hsBaseW/2
    tSlotOffset = @extrusionSize[0]/2+extrusionXOffset
    anglingOffset = tSlotOffset + bla 
    
    #positions of shape inflexions
    sideDistY = 62
    sideDistX = anglingOffset 
    
    sideDistY2 = 72
    sideDistX2 = 30
    
    endBlockSize = @extrusionSize[0]
    
    #various calculations
    flatTipWidth = 20
    theoreticalTriangleTip = []
    
    halfFlatTipW = flatTipWidth/2
    halfAngle = angle/2
    h =  (halfFlatTipW) / Math.tan( (halfAngle*Math.PI/180) )
    
    otherFlat = 64
    halfOFlatTipW = otherFlat/2
    h2 =  (halfOFlatTipW) / Math.tan( (halfAngle*Math.PI/180) )
    lateralExtrTipPos = [-h2+anglingOffset,0,0]
    
    @add new Cube({size:1,center:[-h,0,false]}).color([1,0,0])
    @add new Cube({size:1,center:[lateralExtrTipPos[0],0,false]}).color([1,0,0])
    
    #"safe" circle around smooth rods
    smootRodProtectionDia = @smoothRodDia + 4
    sideExtrTipPos = new Vector3D( lateralExtrTipPos )
    sideExtrusionStart = new Vector3D( sideDistX, sideDistY/2, 0 )
    sideExtrusionDir = sideExtrTipPos.minus( sideExtrusionStart )
    #no normalize !! ye gads!
    sideExtrusionDir = sideExtrusionDir.dividedBy( sideExtrusionDir.length() )
    
    #base shape
    shapesSize = 0.01
    cornerBlock = new Rectangle({size:[shapesSize,endBlockSize],center:[0,0]})
    
    lBlock1 = new Rectangle({size:shapesSize,center:[sideDistX,sideDistY/2]})
    rBlock1 = new Rectangle({size:shapesSize,center:[sideDistX,-sideDistY/2]})
    
    cBlock = new Rectangle({size:[shapesSize,50],center:[(sideDistX2- sideDistX)/2+6,0]})
    
    lBlock2 = new Rectangle({size:shapesSize,center:[sideDistX2,sideDistY2/2]})
    rBlock2 = new Rectangle({size:shapesSize,center:[sideDistX2,-sideDistY2/2]})
    
    blo = 9.0
    endBlock = new Rectangle({size:[shapesSize,extrusionWidth],
    center:[sideDistX2+blo,0]})
    
    bli = extrusionWidth+9
    endBlockCut = CAGBase.fromPoints([
      [-blo,-extrusionWidth/2],
      [-blo,extrusionWidth/2],
      [blo,bli/2],
      [blo,-bli/2]
    ])
    endBlockCut.translate [sideDistX2+blo,0]
    
    
    baseOutline = hull([cornerBlock, lBlock1, rBlock1, cBlock, lBlock2, rBlock2,endBlock])
    baseOutline.subtract endBlockCut
    baseOutline = baseOutline.extrude({offset:[0,0,@height]})
    @union baseOutline
    
    #vertical extrusion hole
    
    extrusionXPos = extrusionXOffset + @extrusionSize[0]/2
    
    extrusionHole = new TSlot({height:@height, hsToShow:@tSlotHeads})
    extrusionHole.translate([tSlotOffset,0,0])
    
    #hsBaseW
    @subtract extrusionHole
    
    #latteral holders for T-slots
    sideHolderLength= 45
    sideTSlotMountHoleDia = 4
    sideTSlotMountHolesNb = 2
    sideTSlotMountHolesPos = sideHolderLength/sideTSlotMountHolesNb
    
    
    basePos = [false,-10,false]
    initPos = [sideDistX,sideDistY/2, 0]
    sideBarHoleR = new Cube({size:[sideHolderLength,@extrusionSize[0],@height], center:basePos})
    sideBarHoleR.rotate([0,0,30])
    sideBarHoleR.translate(sideExtrusionStart)
    #NO BLOODY multiplyScalar !!
    offset = -smootRodProtectionDia/2
    offset = new Vector3D(sideExtrusionDir.x*offset,sideExtrusionDir.y*offset,0)
    sideBarHoleR.translate offset
    #@add sideBarHoleR
    @subtract sideBarHoleR
    sideBarHoleL = sideBarHoleR.clone().mirroredY()
    @subtract sideBarHoleL
    
    actualStart = sideExtrusionStart.plus( offset )
    
    sideExtrPerpDir =  new Vector3D(-sideExtrusionDir.y,sideExtrusionDir.x,0)
    #offset along normal * T-SlotWidth/2 + sideHolderWidth/2
    
    sideHolderWidth = 5
    sideOffset = @extrusionSize[0] + sideHolderWidth
    sideHolderROffset = new Vector3D(sideExtrPerpDir.x*sideOffset,sideExtrPerpDir.y*sideOffset,0)
    
    centerInit = [false,sideHolderWidth/2, false]
    
    sideHolderR = new Cube({size:[sideHolderLength,sideHolderWidth,@height], center:centerInit})
    
    
    nbVerticalTSlots = @height/@extrusionSize[0]
    bli = @extrusionSize[0]
    
    for i in [0...sideTSlotMountHolesNb]
      for j in [0...nbVerticalTSlots]
        sideHolderMountHole = new Cylinder({d:sideTSlotMountHoleDia,h:sideHolderWidth*10,center:[true,false,true]})
        sideHolderMountHole.rotate([90,0,0])
        sideHolderMountHole.translate([sideTSlotMountHolesPos/2+i*sideTSlotMountHolesPos,0,j*bli+bli/2])
        sideHolderR.subtract sideHolderMountHole
    sideHolderR.rotate([0,0,30])
    sideHolderR.translate actualStart.plus(sideHolderROffset)
    @union sideHolderR
    sideHolderL = sideHolderR.clone().mirroredY()
    @union sideHolderL
    
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
    if @idlerCentered
      idlerHoleZPos = -@height/2
    else
      idlerHoleZPos = 0
    idlerHole = new Cylinder({d:@idlerDia,h:10,center:[idlerHoleZPos,0,idlerHolePos]}).rotate([0,90,0])
    @subtract idlerHole
    
    #smooth rods #inner dist :38.78 so 38.78 + 2*3 eye to eye
    smoothRodXPos = anglingOffset+@smoothRodDia/2
    
    sRMountBlockDepth = 4
    sRMountDia = 4
    
    rodOnly = !(@smoothRodMounts)
    
    for i in [-1,1]
      sr = new SmoothRodMount({rodDia:@smoothRodDia,height:@height,orient:1,rodOnly:rodOnly,helperHole:rodOnly,boltHoleLength:10})#,boltDia:@sRMountDia,orient:1
      @subtract sr.inverse().rotate([0,0,@smoothRodAngle*i]).translate([smoothRodXPos,i*@smoothRodYDist/2,0])
    @color([0.8,0.53,0.1,0.8])
    
