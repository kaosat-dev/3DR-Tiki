 


class BottomCorner extends CornerBase
  constructor:(options)->
    @defaults = {
      height : 20
      smoothRodMounts:false
      tSlotHeads:[true,true,true,false]
      tSlotHeadSizes: [null,null,30,null]
      idlerDia : 20
      footHeight:57
      footJoinerHeight: 10
      
      motorMountThickness:6
    }
    options = @injectOptions(@defaults,options)
    
    @idlerZPos = -47/2
    @smoothRodHoleDepth = @height/2
    super options
    
  generate:->
    footWidth = @extrusionSize[0] + 4
    motorMountOffset = 53 #TODO: calculate actual position
    motorMountThickness = @motorMountThickness
    footJoinerHeight = @footJoinerHeight
    cablingHoleWidth = Math.min(footWidth-4,15)
    cablingHoleHeight = Math.min(footJoinerHeight-4,6)
    
    motorMount = new MotorMount({thickness:motorMountThickness,generateAtConstruct:true})
    motorMount.translate([motorMountOffset-motorMountThickness/2,0,0])
    @union( motorMount )
    
    #set correct cut size for tslot subtractions
    cutStSlotHeight = motorMount.height+footJoinerHeight-cablingHoleHeight/2
    @tSlotHeadSizes= [null,null,cutStSlotHeight,null]
    
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
    
    super()#call super() here since we need to cut from it afterwards#@add cablingHole
    
    #@add cablingHole
    footEndToMotorMount = motorMountOffset-18
    cablingHoleLength = footEndToMotorMount
    #cabling hole
    cablingHole = new Cube({size:[cablingHoleLength,cablingHoleWidth,cablingHoleHeight],
    center:[false,true,true]})
    cablingHole.translate([motorMountOffset-cablingHoleLength,0,motorMount.height+footJoinerHeight/2])
    @subtract cablingHole
    
    @color([0.8,0.53,0.1,0.9])
    
    motor = new NemaMotor()
    motor.translate([-motor.motorBody_len/2,0,-motor.motorBody_len-motorMountOffset])
    motor.rotate([0,90,-180])
    @add(motor)


    
    

