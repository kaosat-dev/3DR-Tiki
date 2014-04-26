include("HexKey.coffee")

class BottomCorner extends CornerBase
  constructor:(options)->
    @defaults = {
      height : 20
      smoothRodMounts:false
      tSlotHeads:[true,true,false,false]
      tSlotHeadSizes: [null,null,30,null]
      tSlotFootOnly: [false,false,false,true]
      idlerDia : 20
      footHeight:57
      footJoinerHeight: 10
      
      sideArmsMountHoles:2
      sideArmsMountHolesOffset:-2
      sideArmsMountHolesPosOveride: [8,38]
      
      motorMountThickness:6
      motorMountBoltDia:3#used for mounting holes and hex key hole system
      verticalTSlotBottomOffset:6#space below the main vertical t slot
    
      drawAccessories:false
    }
    options = @injectOptions(@defaults,options)
    
    @idlerZPos = -47/2
    @smoothRodHoleDepth = @height/2
    super options
    
    #@tSlotHeadSizes[3] = 6
    #@tSlotHeadSizes[3] = (@height-@extrusionMountDia)/2
    
  generate:->
    spoolLength  = 23

    footWidth = @extrusionSize[0] + 4
    motorMountOffset = 58 #TODO: calculate actual position
    motorMountThickness = @motorMountThickness
    footJoinerHeight = @footJoinerHeight
    cablingHoleWidth = Math.min(footWidth-4,15)
    cablingHoleHeight = Math.min(footJoinerHeight-4,6)
    
    motorMount = new MotorMount({thickness:motorMountThickness,generateAtConstruct:true})
    motorMount.translate([motorMountOffset-motorMountThickness/2,0,0])
    @union( motorMount )
    
    #set correct cut size for tslot subtractions
    cutStSlotHeight = motorMount.height+footJoinerHeight/2-cablingHoleHeight/2
    @tSlotHeadSizes= [null,null,cutStSlotHeight,null]
    @tSlotHeadSizes[3] = 6
    #@add new Cube({size:[1,30,0.1],center:[25,0,cutStSlotHeight]}).color([1,0,0])
    
    mntWidth = motorMount.width
    mntFootJoinerShape = CAGBase.fromPoints([
      [-footWidth/2,-footJoinerHeight/2],
      [footWidth/2,-footJoinerHeight/2],
      [mntWidth/2,footJoinerHeight/2],
      [-mntWidth/2,footJoinerHeight/2]
    ])
    motorMountFootJoiner = mntFootJoinerShape.extrude({offset:[0,0,motorMountThickness]})
    motorMountFootJoiner.rotate([0,0,-90])
    motorMountFootJoiner.rotate([0,90,0])
    motorMountFootJoiner.translate([motorMountOffset-motorMountThickness,0,motorMount.height+footJoinerHeight/2])
    @union motorMountFootJoiner
    
    #bridge between motor mount and "foot"
    bridgeLength = motorMountOffset-20
    motorMountFootBridge = new Cube({size:[bridgeLength,footWidth,footJoinerHeight],
    center:[false,true,false]})
    motorMountFootBridge.translate([motorMountOffset-bridgeLength,0,motorMount.height])
    @union( motorMountFootBridge )
    
    #add smooth transition, for easier printing
    sCHeight = 7
    scLength = sCHeight
    smoothCorner = new Cube({size:[scLength,footWidth,sCHeight],center:[false,true,false]})
    smoothCornerCut = new Cylinder({r:scLength,h:footWidth,center:[true,true,true],$fn:25})
    smoothCornerCut.rotate([0,90,90])
    #smoothCornerCut.translate([-scLength/2,0,0])
    smoothCorner.subtract( smoothCornerCut  )
    smoothCorner.mirroredX()
    
    #@add smoothCorner.color([1,0,0])
    #@add smoothCornerCut
    smoothCorner.translate([0,0,motorMount.height-sCHeight])
    smoothCornerEnd = smoothCorner.clone()
    smoothCorner.translate([motorMountOffset-bridgeLength+10+scLength,0,0])
    @union smoothCorner.color([1,0,0])
    @union smoothCornerEnd.mirroredX().translate([motorMountOffset-motorMountThickness-scLength,0,0])
    
    
    super()#call super() here since we need to cut from it afterwards#@add cablingHole
    
    
    footEndToMotorMount = motorMountOffset-(20+@extrusionBorders[0])
    cablingHoleLength = footEndToMotorMount
    #cabling hole
    cablingHole = new Cube({size:[cablingHoleLength,cablingHoleWidth,cablingHoleHeight],
    center:[false,true,true]})
    cablingHole.translate([motorMountOffset-cablingHoleLength,0,motorMount.height+footJoinerHeight/2])
    @subtract cablingHole
    #@add cablingHole
    
    
    #make a bit more space to mount the motor, if needed
    motorMountCut = new Cube({size:[4,35,20],center:[motorMountOffset-motorMountThickness-2,true,false]})
    @subtract motorMountCut
    
    #add "feet" blocks underneath vertical t slot
    blockerHeight= motorMount.height + footJoinerHeight-cutStSlotHeight
    console.log("inner foot height",blockerHeight)
    tSlotBlocker = new TSlot({height:blockerHeight,hsToShow:[true,true,false,false]})
    tSlotBlockerBlock = new Cube({size:[tSlotBlocker.width+1,tSlotBlocker.depth+1,blockerHeight],center:[true,true,false]})
    #tSlotBlocker = tSlotBlockerBlock.subtract( tSlotBlocker )
    centralCut = new Cube({size:[21,12,blockerHeight],center:[true,true,false]})
    tSlotBlockerBlock.subtract( centralCut )
    tSlotBlockerBlock.translate([@vertTSlotPos.x ,0, @footHeight-blockerHeight])
    @union tSlotBlockerBlock#.color([1,0,0])
    
    @color([0.8,0.53,0.1,0.9])
    
    #visual aids, nothing structural
    if @drawAccessories
      motor = new NemaMotor()
      motor.translate([-motor.motorBody_len/2,0,-motor.motorBody_len-motorMountOffset])
      motor.rotate([0,90,-180])
      @add(motor)
      
      spool = new Cylinder({d:22,h:spoolLength,center:[false,false,false]})
      spool.translate([-motor.motorBody_len/2,0,motorMountOffset-spoolLength-2])
      spool.rotate([0,90,0])
      @add spool
    
    ###
    hexKey = new HexKey()
    hexKey.color([1,0,0])
    hexKey.rotate([0,0,-90])
    
    motorMountBoltLength = 10
    motorMountBoltHoleEnd = motorMountBoltLength-2
    hexKey.translate([motorMountOffset-motorMountBoltHoleEnd,16,10])
    #hexKey.rotate([0,90,180])
    hexKeyMountHole = new Cylinder({d:5,h:100,center:[false,true,true]})
    hexKeyMountHole.rotate([90,0,0])
    hexKeyMountHole.color([0,1,0])
    hexKeyMountHole.translate([motorMountOffset-motorMountBoltHoleEnd-15,16,10])
    
    otherMountHole = new Cylinder({d:5,h:100,center:[false,true,false]})
    otherMountHole.rotate([90,0,90])
    otherMountHole.translate([0,16,10])###
    
    #@add otherMountHole.color([0,0,1])
    #@add hexKey
    #@subtract hexKeyMountHole
    @color([0.8,0.53,0.1,0.9])
