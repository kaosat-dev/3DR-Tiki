include("MotorMount.coffee")
include("TSlot.coffee")
include("Bolt.coffee")

class CornerBase extends Part
  constructor:(options)->
    @defaults = {
      endBlockSize: [10,10]
      extrusionSize:[20,20]
      extrusionBorders : [5,2]
      extrusionMountDia:5
      
      sideExtrusionMountDia:4
      sideArmsLength:50
      sideArmsWidth :5
      sideArmsMountHoles:3
      sideArmsMountHolesOffset:0
      sideArmsMountHolesPosOveride:null
      
      idlerDia : 20
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
      tSlotFootOnly: [false,false,false,false]
      
      vertCableHoles:true
      vertCableHolesDia:5
      vertCableHolesShape:Cylinder
      
      sideTSlotLengths:200
      
      endStopOffset: 13 #offset from the inner part of the "foot" to the endstop center
      
      generateAtConstruct:true
      adjuster:0.01
    }
    options = @injectOptions(@defaults,options)
    super options
    
    if @smoothRodHoleDepth == null
      @smoothRodHoleDepth = @height
    
    
    #"safe" circle around smooth rods
    @smootRodProtectionDia = @smoothRodDia + 4

    #Mounting T-nuts size:
    #length : 10 mm http://www.profiles-pour-tous.com/ecrous-de-fixation-pour-profiles-6-mm/241-lot-de-10-ecrous-de-fixation-pour-profiles-a-fente-de-6-mm-taraudage-m5.html
    tNutLength =10
    tNutWidth  = 10
    #size of "cube" tSlot sliding helper
    #@tSlotHeadSizes[3] = (@height-@extrusionMountDia)/2 - tNutLength/2
    
    
    
    @tSlotRef = new TSlot({width:@extrusionSize[0],depth:@extrusionSize[1],generateAtConstruct:false})

    
    if @generateAtConstruct
      @generate()
    
    #TODO: how to hangle attributes that should
    #default to calculated properties based on 
    #ohter attributes
    #@height = @extrusionSize[0]

    
  generate:->
    angle = 60 #duh !
    adjuster = @adjuster
    tSlotRef = @tSlotRef
    #store a non renderered tslot instance, for size reference
    tSlotWidth = tSlotRef.width
    tSlotDepth = tSlotRef.depth
    
    extrusionBorders = @extrusionBorders
    smootRodProtectionDia = @smootRodProtectionDia
    
    extrusionXOffset = extrusionBorders[0]
    
    footBaseSize = new Vector2D( tSlotDepth+extrusionBorders[0]*2,
      tSlotRef.width+extrusionBorders[1]*2 )
    
    tSlotOffset = tSlotRef.depth/2+extrusionXOffset
    anglingOffset = tSlotOffset + tSlotRef.hsBaseW/2 #where does the angling of the sides start
    
    #smooth rods #inner dist :38.78 so 38.78 + 2*3 eye to eye
    smoothRodXPos = tSlotOffset+@smoothRodXDist
    
    #vertical TSlot position (center of TSlot)
    vertTSlotPos = new Vector3D(tSlotOffset,0,0)
    @vertTSlotPos = vertTSlotPos
    
    #positions of shape inflexions
    firstInflectPoint  = new Vector2D(anglingOffset,62/2)
    secondInflectPoint = new Vector2D(30,72/2)
    
    sideDistY = 62
    sideDistX = anglingOffset 
    
    sideDistY2 = 72
    sideDistX2 = 30
    
    endBlockSize = @extrusionSize[0]
    
    #various calculations
    flatTipWidth = tSlotWidth
    
    halfAngle = angle/2
    sStart = new Vector3D(0,10,0 )
    firstBlockDir = firstInflectPoint.toVector3D().minus( sStart )
    firstBlockDir= firstBlockDir.unit()
    
    otherFlat = 64
    halfOFlatTipW = otherFlat/2
    h2 =  (halfOFlatTipW) / Math.tan( (halfAngle*Math.PI/180) )
    lateralExtrTipPos = [-h2+anglingOffset,0,0]
    
    #this is the tip of the triangle of latteral extrusions
    
    
    sideExtrTipPos = new Vector3D( lateralExtrTipPos )
    sideExtrusionStart = new Vector3D( sideDistX, sideDistY/2, 0 )
    sideExtrusionDir = sideExtrTipPos.minus( sideExtrusionStart )
    sideExtrusionDir = sideExtrusionDir.unit() #( sideExtrusionDir.length() )
    
    #-----------------
    #latteral holders for T-slots
    sideArmLength= @sideArmsLength
    sideTSlotMountHoleDia = @sideExtrusionMountDia
    sideTSlotMountHolesNb = @sideArmsMountHoles 
    sideTSlotMountHolesPos = sideArmLength/sideTSlotMountHolesNb
    
    #NO BLOODY multiplyScalar !!
    offset = -smootRodProtectionDia/2
    offset = new Vector3D(sideExtrusionDir.x*offset,sideExtrusionDir.y*offset,0)
    
    actualStart = sideExtrusionStart.plus( offset )
    
    #normal of direction vector + multiply scalar
    sideExtrPerpDir =  new Vector3D(-sideExtrusionDir.y,sideExtrusionDir.x,0)
    #offset along normal * T-SlotWidth/2 + sideArmWidth/2
    
    sideArmWidth = @sideArmsWidth
    sideOffset = tSlotWidth + sideArmWidth/2
    sideHolderROffset = new Vector3D(sideExtrPerpDir.x*sideOffset,sideExtrPerpDir.y*sideOffset,0)
    
    #HERE
    #TODO: simplify
    sideExtrPerpDir2 = new Vector3D(-sideExtrusionDir.y*tSlotWidth/2,sideExtrusionDir.x*tSlotWidth/2,0)
    sideTSlotStart = sideExtrusionStart.plus( offset ).plus( sideExtrPerpDir2)
    sideArmStart = actualStart.plus(sideHolderROffset)
    
    
    #this is the tip of the triangle of latteral extrusions
    halfAngleRadian = halfAngle * Math.PI/180
    heading = new Vector3D(Math.cos(halfAngleRadian),Math.sin(halfAngleRadian))
    
    halfoRTipW = sideTSlotStart.y/2
    hOff =  (halfoRTipW) / Math.tan( (halfAngle*Math.PI/180) )
    realTip = new Vector3D([sideTSlotStart.x-hOff*2,0,0])
    
    realTipToSideTSlotStartVect = realTip.minus( sideTSlotStart )
    realTipToSideTSlotStartLengh = realTipToSideTSlotStartVect.length()
    sideTslotLengths = @sideTSlotLengths
    totalSideLength = realTipToSideTSlotStartLengh + sideTslotLengths
    baseVectorTip = realTipToSideTSlotStartVect.clone().unit()
    
    halfSidePos = new Vector3D(baseVectorTip.x*-totalSideLength/2,-baseVectorTip.y*totalSideLength/2,0)
    @add new Cube({size:[1,1,1],center:halfSidePos}).color([1,1,0])
    @add new Cube({size:[1,1,20],center:realTip}).color([1,0,0])
    @add new Cube({size:[1,1,20],center:sideTSlotStart}).color([1,0,0])

    
    halfSideLength = realTipToSideTSlotStartLengh+ sideTslotLengths/2
    centerPosition = halfSideLength/Math.cos(halfAngleRadian) - Math.abs(realTip.x)
    circleRadius = Math.sin(halfAngleRadian)*centerPosition
    console.log("sideTslotLengths",sideTslotLengths,"realTip.x",realTip.x,"halfSideLength", halfSideLength,"centerPosition",centerPosition,"radius",circleRadius)
    
    #TODO : here calulate center without using "realTip", just by using
    #the length of the latterial tSlots (/2)
    #vector from angle
    #V.x = cos(A)
    #V.y = sin(A)
    fooBarBaz = @sideTSlotLengths/2
    fooBuz = new Vector3D(heading.x*fooBarBaz
      ,heading.y*fooBarBaz,0).plus sideTSlotStart
    #centerPosition= fooBuz.x
    @add new Cube({size:[1,1,20],center:fooBuz}).color([1,0,0])
    #console.log("centerPosition",fooBuz.x)
    @add new Cube({size:[1,1,20],center:[centerPosition,0,0]}).color([0,1,0])
    
    
    deltaSmoothRodOffset = centerPosition- smoothRodXPos
    deltaCarriageOffset  = 17#measure IRL
    deltaEffectorOffset  = 23 #25 measured IRL, 23 in theory
    deltaMinAngle = 30
    deltaMinAngleRadian = deltaMinAngle*Math.PI/180
    ballJointLength = 17
    deltaRadius = deltaSmoothRodOffset-(deltaEffectorOffset + deltaCarriageOffset)
    deltaDiagRodLengthEyeToEye = deltaRadius/Math.sin(deltaMinAngleRadian)
    deltaDiagRodLengthRodOnly = deltaDiagRodLengthEyeToEye - (2 * ballJointLength)
    deltaVerticalDistanceFromPlatform = Math.cos(deltaMinAngleRadian)*deltaDiagRodLengthEyeToEye
    console.log("deltaArmAngle",deltaMinAngle,"deltaSmoothRodOffset",deltaSmoothRodOffset,"deltaRadius",deltaRadius
    , "deltaDiagRodLength eye to eye",deltaDiagRodLengthEyeToEye
    ,"deltaDiagRodLengthRodOnly",deltaDiagRodLengthRodOnly
    ,"deltaVerticalDistanceFromPlatform",deltaVerticalDistanceFromPlatform)

    #draw inner circle
    #innerCircle = new Circle({r:circleRadius,center:[centerPosition,0]})
    #@add innerCircle.extrude({offset:0,0,1})
    
    
    bloOffset = tSlotWidth + sideArmWidth
    blo = new Vector3D(sideExtrPerpDir.x*bloOffset,sideExtrPerpDir.y*bloOffset,0)
    sideArmTip = actualStart.plus(blo)
    
    @add new Cube({size:[1,1,10],center:sideTSlotStart}).color([1,1,0])
    @add new Cube({size:1,center:sideArmStart}).color([1,0,0])
    @add new Cube({size:1,center:sideArmTip}).color([1,1,1])

    @add new Cube({size:1,center:realTip}).color([1,0,1])
    @add new Cube({size:1,center:[lateralExtrTipPos[0],0,false]}).color([1,0,0])
    
    #@add new Cube({size:1,center:firstBlockDir}).color([1,1,0])
    #@add new Cube({size:1,center:firstInflectPoint.toVector3D()}).color([0,0,1])
    #@add new Cube({size:1,center:secondInflectPoint.toVector3D()}).color([0,0,1])
    
    @add new Cube({size:1,center:sideExtrusionStart}).color([0,1,0])
    
    #------------
    #base shape

    baseShapePts = CAGBase.fromPoints([
      [0,-adjuster]
      [0,endBlockSize/2]
      [sideDistX,sideDistY/2]
      [sideDistX2,sideDistY2/2]
      [sideArmTip.x,sideArmTip.y]
      [footBaseSize.x,footBaseSize.y/2]
      [footBaseSize.x,-adjuster]
    ])
    baseShape = baseShapePts.extrude({offset:[0,0,@height]})
    @union baseShape
    @union baseShape.mirroredY()
    
    #footblock 
    footBlock = new Rectangle({size:footBaseSize,center:[true,true,false]})
    footBlock = footBlock.extrude({offset:[0,0,@footHeight]})
    
    #vertical extrusion hole
    extrusionHole = new TSlot({height:@footHeight, hsToShow:@tSlotHeads
      ,hsHeights:@tSlotHeadSizes,hsFootOnly:@tSlotFootOnly})
    
    translate(vertTSlotPos,[footBlock,extrusionHole])
    
    plane = Plane.fromNormalAndPoint([-firstBlockDir.y,firstBlockDir.x, 0], [0,10,0])#[sideDistX, sideDistY, 0])
    plane2 = Plane.fromNormalAndPoint([-firstBlockDir.y,-firstBlockDir.x, 0], [0,-10,0])#[sideDistX, sideDistY, 0])
    
    footBlock.cutByPlane(plane)
    footBlock.cutByPlane(plane2)
    
    @union footBlock.color([1,0,0])
    @subtract extrusionHole
    
    #@add new TSlot({height:@footHeight
    #  ,hsHeights:@tSlotHeadSizes,fudge:false}).translate(vertTSlotPos).color([0,1,0,0.5])
    
    #cut away lateral positions for tslots
    sideTSlotCutR = new Cube({size:[sideArmLength,tSlotWidth,@height]
      , center:[false,true,false]})
    sideTSlotCutR.rotate([0,0,30]).translate( sideTSlotStart )
    
    #@add sideTSlotCutR
    @subtract sideTSlotCutR
    sideTSlotCutL = sideTSlotCutR.clone().mirroredY()
    @subtract sideTSlotCutL
    
    #just a test : REMOVE me
    sideTSlotFull = new Cube({size:[100,tSlotWidth,@height]
      , center:[false,true,false]})
    sideTSlotFull.rotate([0,0,30]).translate( sideTSlotStart )
    @add sideTSlotFull.color([1,0,1,0.5])
    
    centerInit = [false,true, false]
    sideHolderR = new Cube({size:[sideArmLength,sideArmWidth,@height], center:centerInit})
    
    
    nbVerticalTSlots = @height/tSlotDepth
    sideArmsMountHolesPosOveride = @sideArmsMountHolesPosOveride
    
    sideHolderR = new TSlotSideMount({length:sideArmLength
      ,thickness:sideArmWidth,width:@height
      ,mountHolePositions:sideArmsMountHolesPosOveride})
    
    
    sideHolderR.mirroredY()
    sideHolderR.rotate([0,0,halfAngle])
    sideHolderR.translate actualStart.plus(sideHolderROffset)
    @union sideHolderR
    sideHolderL = sideHolderR.clone().mirroredY()
    @union sideHolderL
    
    
    #vertical extrusion front mount hole reinforcement
    extrusionMountDia = @extrusionMountDia
    reinfoHeight = 1
    reinfoDia = extrusionMountDia+10
    #hack to avoid coplanar face/tjunctions at export
    adjHack=2
    extrusionMountHoleReinforce = new Cylinder({d:reinfoDia,h:reinfoHeight+adjHack
      ,center:[-@footHeight/2,adjuster,-reinfoHeight/2+adjHack/2]}).rotate([0,90,0])
    @union extrusionMountHoleReinforce
    #@add extrusionMountHoleReinforce
    
    #vertical extrusion front mount hole
    extrusionMountDepth = reinfoHeight + extrusionXOffset 
    extrusionMountPos = extrusionXOffset/2 - reinfoHeight/2
    extrusionMountHole = new Cylinder({d:extrusionMountDia,h:extrusionMountDepth+adjuster
      ,center:[-@footHeight/2,0,extrusionMountPos]}).rotate([0,90,0])
    @subtract extrusionMountHole
    
    
    #idler cutaway
    idlerHoleDepth = extrusionBorders[0]#6
    idlerHolePos = vertTSlotPos.x+ tSlotDepth/2 +idlerHoleDepth/2
    if @idlerCentered
      idlerHoleZPos = -@height/2
    else
      idlerHoleZPos = 0
    if @idlerZPos != null
      idlerHoleZPos = @idlerZPos
      
    idlerHole = new Cylinder({d:@idlerDia,h:idlerHoleDepth,center:[idlerHoleZPos,0,idlerHolePos]}).rotate([0,90,0])
    @subtract idlerHole
    #@add idlerHole
    
    sRMountBlockDepth = 4
    sRMountDia = @smoothRodMountDia
    rodOnly = !(@smoothRodMounts)
    
    smoothRodPos = new Vector2D(smoothRodXPos, @smoothRodYDist/2)
    
    for i in [-1,1]
      sr = new SmoothRodMount({rodDia:@smoothRodDia,height:@smoothRodHoleDepth,orient:1,rodOnly:rodOnly,helperHole:@smoothRodHelpers,boltHoleLength:10})#,boltDia:@sRMountDia,orient:1
      @subtract sr.inverse().rotate([0,0,@smoothRodAngle*i]).translate([smoothRodXPos,i*@smoothRodYDist/2,0])
    
    @color([0.8,0.53,0.1,0.7])

    
    #cable passing hole
    if @vertCableHoles
      cableHoleDia = @vertCableHolesDia
      cableHolePos = new Vector3D(vertTSlotPos.x, footBaseSize.x/2+2,
      0)
      #cableHole =new Cube({size:[7,4,@height],center:[true,true,false]})
      cableHole = new Cylinder({d:cableHoleDia,h:@height,center:[true,true,false]})
      @subtract cableHole.translate(cableHolePos)
      @subtract cableHole.clone().mirroredY()
    
    #assign to instance, so they can be re-used
    @footBaseSize = footBaseSize
    @vertTSlotPos = vertTSlotPos