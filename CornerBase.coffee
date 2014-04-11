include("MotorMount.coffee")

class CornerBase extends Part
  constructor:(options)->
    @defaults = {
      endBlockSize: [10,10]
      extrusionSize:[20,20]
      extrusionMountDia:5
      
      sideExtrusionMountDia:4
      sideArmsLength:45
      sideArmsWidth :5
      
      idlerDia : 19.5
      idlerZPos: null
      idlerCentered:true
      
      height : 20
      footHeight:20
      
      smoothRodDia: 6
      smoothRodYDist : 44.78
      smoothRodXDist: 9 #distance along x from center of TSlot to center of smooth rods
      smoothRodHoleDepth : null
      smoothRodMounts : false
      smoothRodHelpers : false
      smoothRodAngle : 0
      smoothRodMountDia: 4
      
      tSlotHeads : [true,true,false,false]
      tSlotHeadSizes: [null,null,null,null]
      
      generateAtConstruct:true
    }
    options = @injectOptions(@defaults,options)
    super options
    
    if @smoothRodHoleDepth == null
      @smoothRodHoleDepth = @height
    
    @extrusionBorders = [4,2]
    
    #"safe" circle around smooth rods
    @smootRodProtectionDia = @smoothRodDia + 4
    
    if @generateAtConstruct
      @generate()
    
    #TODO: how to hangle attributes that should
    #default to calculated properties based on 
    #ohter attributes
    #@height = @extrusionSize[0]

    
    
  generate:->
    angle = 60 #duh !
    #store a non renderered tslot instance, for size reference
    tSlotRef = new TSlot({width:@extrusionSize[0],depth:@extrusionSize[1],generateAtConstruct:false})
    
    extrusionBorders = @extrusionBorders
    smootRodProtectionDia = @smootRodProtectionDia
    
    extrusionXOffset = extrusionBorders[0]
    extrusionWidth = tSlotRef.width
    
    footBaseSize = new Vector2D( tSlotRef.depth+extrusionBorders[0]*2,
      tSlotRef.width+extrusionBorders[1]*2 )
    
    footWidth = @extrusionSize[0] + 4
    footLength = @extrusionSize[1] + 9.5
    
    tSlotOffset = tSlotRef.depth/2+extrusionXOffset
    anglingOffset = tSlotOffset + tSlotRef.hsBaseW/2 #where does the angling of the sides start
    
    #smooth rods #inner dist :38.78 so 38.78 + 2*3 eye to eye
    smoothRodXPos = tSlotOffset+@smoothRodXDist
    
    #vertical TSlot position (center of TSlot)
    vertTSlotPos = new Vector3D(tSlotOffset,0,0)
    
    #positions of shape inflexions
    firstInflectPoint  = new Vector2D(anglingOffset,62/2)
    secondInflectPoint = new Vector2D(30,72/2)
    
    sideDistY = 62
    sideDistX = anglingOffset 
    
    sideDistY2 = 72
    sideDistX2 = 30
    
    endBlockSize = @extrusionSize[0]
    
    #various calculations
    flatTipWidth = tSlotRef.width
    theoreticalTriangleTip = []
    
    halfAngle = angle/2
    sStart = new Vector3D(0,10,0 )
    firstBlockDir = firstInflectPoint.toVector3D().minus( sStart )
    firstBlockDir= firstBlockDir.unit()
    
    otherFlat = 64
    halfOFlatTipW = otherFlat/2
    h2 =  (halfOFlatTipW) / Math.tan( (halfAngle*Math.PI/180) )
    lateralExtrTipPos = [-h2+anglingOffset,0,0]
    
    
    sideExtrTipPos = new Vector3D( lateralExtrTipPos )
    sideExtrusionStart = new Vector3D( sideDistX, sideDistY/2, 0 )
    sideExtrusionDir = sideExtrTipPos.minus( sideExtrusionStart )
    sideExtrusionDir = sideExtrusionDir.unit() #( sideExtrusionDir.length() )
    
    #-----------------
    #latteral holders for T-slots
    sideArmLength= @sideArmsLength
    sideTSlotMountHoleDia = @sideExtrusionMountDia#4
    sideTSlotMountHolesNb = 2
    sideTSlotMountHolesPos = sideArmLength/sideTSlotMountHolesNb
    
    
    #NO BLOODY multiplyScalar !!
    offset = -smootRodProtectionDia/2
    offset = new Vector3D(sideExtrusionDir.x*offset,sideExtrusionDir.y*offset,0)
    
    actualStart = sideExtrusionStart.plus( offset )
    
    #normal of direction vector + multiply scalar
    sideExtrPerpDir =  new Vector3D(-sideExtrusionDir.y,sideExtrusionDir.x,0)
    #offset along normal * T-SlotWidth/2 + sideArmWidth/2
    
    sideArmWidth = @sideArmsWidth
    sideOffset = @extrusionSize[0] + sideArmWidth/2
    sideHolderROffset = new Vector3D(sideExtrPerpDir.x*sideOffset,sideExtrPerpDir.y*sideOffset,0)
    
    #HERE
    #TODO: simplify
    tSlotWidth = tSlotRef.width
    sideExtrPerpDir2 = new Vector3D(-sideExtrusionDir.y*tSlotWidth/2,sideExtrusionDir.x*tSlotWidth/2,0)
    sideTSlotStart = sideExtrusionStart.plus( offset ).plus( sideExtrPerpDir2)
    sideArmStart = actualStart.plus(sideHolderROffset)
    
    bloOffset = @extrusionSize[0] + sideArmWidth
    blo = new Vector3D(sideExtrPerpDir.x*bloOffset,sideExtrPerpDir.y*bloOffset,0)
    sideArmTip = actualStart.plus(blo)
    
    @add new Cube({size:[1,1,10],center:sideTSlotStart}).color([1,1,0])
    @add new Cube({size:1,center:sideArmStart}).color([1,0,0])
    @add new Cube({size:1,center:sideArmTip}).color([1,1,1])

    #@add new Cube({size:1,center:tip}).color([1,0,0])
    #@add new Cube({size:1,center:[lateralExtrTipPos[0],0,false]}).color([1,0,0])
    
    #@add new Cube({size:1,center:firstBlockDir}).color([1,1,0])
    #@add new Cube({size:1,center:firstInflectPoint.toVector3D()}).color([0,0,1])
    #@add new Cube({size:1,center:secondInflectPoint.toVector3D()}).color([0,0,1])
    
    @add new Cube({size:1,center:sideExtrusionStart}).color([0,1,0])
    
    #------------------
    
    #------------
    #base shape

    baseShapePts = CAGBase.fromPoints([
      [0,0]
      [0,endBlockSize/2]
      [sideDistX,sideDistY/2]
      [sideDistX2,sideDistY2/2]
      [sideArmTip.x,sideArmTip.y]
      [footBaseSize.x,footBaseSize.y/2]
      [footBaseSize.x,0]
    ])
    baseShape = baseShapePts.extrude({offset:[0,0,@height]})
    @union baseShape
    @union baseShape.mirroredY()
    
    #footblock 
    footBlock = new Rectangle({size:footBaseSize,center:[true,true,false]})
    footBlock = footBlock.extrude({offset:[0,0,@footHeight]})
    
    #vertical extrusion hole
    extrusionHole = new TSlot({height:@footHeight, hsToShow:@tSlotHeads
      ,hsHeights:@tSlotHeadSizes})
    
    translate(vertTSlotPos,[footBlock,extrusionHole])
    
    plane = Plane.fromNormalAndPoint([-firstBlockDir.y,firstBlockDir.x, 0], [0,10,0])#[sideDistX, sideDistY, 0])
    plane2 = Plane.fromNormalAndPoint([-firstBlockDir.y,-firstBlockDir.x, 0], [0,-10,0])#[sideDistX, sideDistY, 0])
    
    footBlock.cutByPlane(plane)
    footBlock.cutByPlane(plane2)
    
    @union footBlock.color([1,0,0])
    @subtract extrusionHole
    
    sideTSlotCutR = new Cube({size:[sideArmLength,@extrusionSize[0],@height]
      , center:[false,true,false]})
    sideTSlotCutR.rotate([0,0,30]).translate( sideTSlotStart )
    
    #@add sideTSlotCutR
    @subtract sideTSlotCutR
    sideTSlotCutL = sideTSlotCutR.clone().mirroredY()
    @subtract sideTSlotCutL
    
    centerInit = [false,true, false]
    sideHolderR = new Cube({size:[sideArmLength,sideArmWidth,@height], center:centerInit})
    
    nbVerticalTSlots = @height/@extrusionSize[0]
    bli = @extrusionSize[0]
    
    for i in [0...sideTSlotMountHolesNb]
      for j in [0...nbVerticalTSlots]
        sideHolderMountHole = new Cylinder({d:sideTSlotMountHoleDia,h:sideArmWidth*10,center:[true,false,true]})
        sideHolderMountHole.rotate([90,0,0])
        sideHolderMountHole.translate([sideTSlotMountHolesPos/2+i*sideTSlotMountHolesPos,0,j*bli+bli/2])
        sideHolderR.subtract sideHolderMountHole
    sideHolderR.rotate([0,0,30])
    sideHolderR.translate actualStart.plus(sideHolderROffset)
    @union sideHolderR
    sideHolderL = sideHolderR.clone().mirroredY()
    @union sideHolderL
    
    
    #vertical extrusion front mount hole reinforcement
    extrusionMountDia = @extrusionMountDia
    reinfoHeight = 1
    reinfoDia = extrusionMountDia+8
    extrusionMountHoleReinforce = new Cylinder({d:reinfoDia,h:reinfoHeight,center:[-@footHeight/2,0,-reinfoHeight/2]}).rotate([0,90,0])
    @union extrusionMountHoleReinforce
    
    #vertical extrusion front mount hole
    extrusionMountDepth = reinfoHeight + extrusionXOffset 
    extrusionMountPos = extrusionXOffset/2 - reinfoHeight/2
    extrusionMountHole = new Cylinder({d:extrusionMountDia,h:extrusionMountDepth,center:[-@footHeight/2,0,extrusionMountPos]}).rotate([0,90,0])
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
    if @idlerZPos != null
      idlerHoleZPos = @idlerZPos
      
    idlerHole = new Cylinder({d:@idlerDia,h:10,center:[idlerHoleZPos,0,idlerHolePos]}).rotate([0,90,0])
    @subtract idlerHole
    
    sRMountBlockDepth = 4
    sRMountDia = @smoothRodMountDia
    rodOnly = !(@smoothRodMounts)
    
    for i in [-1,1]
      sr = new SmoothRodMount({rodDia:@smoothRodDia,height:@smoothRodHoleDepth,orient:1,rodOnly:rodOnly,helperHole:@smoothRodHelpers,boltHoleLength:10})#,boltDia:@sRMountDia,orient:1
      @subtract sr.inverse().rotate([0,0,@smoothRodAngle*i]).translate([smoothRodXPos,i*@smoothRodYDist/2,0])
    @color([0.8,0.53,0.1,0.7])
    
