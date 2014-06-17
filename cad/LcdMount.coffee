 

#draw pie slice
cylArc=(options)->
  options = options or {}
  radius=options.radius or 20
  startAngle = options.start or -45
  endAngle = options.end or 45
  res = options.$fn or 20
  
  pieSlicePts = []
  center = new Vector2D()
  angleOffset = ((endAngle-startAngle)/res) *Math.PI/180
  startAngleRadian = startAngle*Math.PI/180
  
  pieSlicePts.push center
  for i in [0..res]
      radians =  angleOffset*i + startAngleRadian #2 * Math.PI * i / res + startAngleRadian
      point = Vector2D.fromAngleRadians(radians).times(radius).plus(center)
      pieSlicePts.push point
  return CAGBase.fromPoints( pieSlicePts )

###
*Lcd/controller mount system
###
class LcdMount extends Part
  constructor:(options)->
    @defaults = {
      
      thickness:10
      axisID:13#8
      axisOD:20#15
      axisLimitOd:13
      axisMaxRot:180
      
      mountArmLength:70
      mountHoleDia:3
      mountHolesDist:50#center to center
      
      lockingNotches:6
      lockingNotchesDia:2
      
      generateAtConstruct:true
    }
    options = @injectOptions(@defaults,options)
    super options
    
    if @generateAtConstruct
      @generate()
  
  
  generate:->
    
    #@generateMount()
    @generateAxis()
  
  generateMount:->
    mountPos = @mountArmLength/2+@axisOD/2
    mountArmOffset = @mountArmLength/2-(@axisOD-@axisID)/2+@axisOD/2
    
    innerAxisDepth = @thickness/2
    lockingNotches = @lockingNotches
    lockingNotchesDia = @lockingNotchesDia
    innerAxisDia = @axisID-0.1#-lockingNotchesDia
    
    startAngle = 0
    endAngle =180
    angleOffset = (endAngle-startAngle) / lockingNotches
    
    sideAxis = new Cylinder({d:@axisOD,h:@thickness,$fn:15})
    sideAxisHole = new Cylinder({d:@axisID,h:@thickness,$fn:28})
    sideAxis.subtract sideAxisHole
    
    #new CSGBase()#
    mountArm = new Cube({size:[5,@mountArmLength,@thickness],center:[true,mountArmOffset,false]})
    mountHole = new Cylinder({d:@mountHoleDia,h:@thickness*10,center:[mountPos,@thickness/2,true]}).rotate [90,0,90]
    
    mountArm.union sideAxis
    mountArm.subtract mountHole.clone().translate [0,@mountHolesDist/2,0]
    mountArm.subtract mountHole.clone().translate [0,-@mountHolesDist/2,0]
    
    nut = new Nut({outlineOnly:true})
    nut.rotate [0,90,0]
    nut.translate [0,mountPos,@thickness/2]
    mountArm.subtract nut.clone().translate [0,@mountHolesDist/2,0]
    mountArm.subtract nut.translate [0,-@mountHolesDist/2,0]
    
    for i in [0...lockingNotches]
      lockinNotch = new Cylinder({d:lockingNotchesDia/2,h:innerAxisDepth,$fn:15})
      lockinNotch.translate [innerAxisDia/2,0,0]
      lockinNotch.rotate [0,0,i*angleOffset+angleOffset/2]
      mountArm.union lockinNotch
    
    cutAngle = @axisMaxRot+60
    c = new Cylinder({d:@axisLimitOd,h:innerAxisDepth,center:[true,true,false]})
    c.subtract cylArc({start:-cutAngle/2,end:cutAngle/2}).extrude({offset:[0,0,innerAxisDepth]}).mirroredX()
    c.rotate [0,0,-90]
    mountArm.union c#.color([1,0,0])
    
    @union mountArm
  
  generateAxis:->
    axisMountLength = 15
    axisMountDepth = 5
    
    innerAxisDia = @axisID-0.1#-lockingNotchesDia
    innerAxis = new Cylinder({d:innerAxisDia,h:@thickness/2+axisMountDepth,$fn:28})
    innerAxis.translate [0,0,@thickness/2]
    limiterAngle = 60
    #innerAxisLimiter = new Cylinder({d:@axisLimitOd,h:5,$fn:28,center:[true,true,false]})
    innerAxisLimiter = cylArc({start:-limiterAngle/2,end:limiterAngle/2,radius:@axisLimitOd/2}).extrude({offset:[0,0,5]}).mirroredX()
    innerAxisLimiter.rotate [0,0,-90]
    innerAxisLimiter.translate [0,0,0.1]
    innerAxis.union innerAxisLimiter
    
    innerAxisMount = new Cube({size:[innerAxisDia,axisMountLength,axisMountDepth],center:[true,false,@thickness+axisMountDepth/2]})
    innerAxisMount.translate [0,-axisMountLength,0]
    innerAxis.union innerAxisMount
    
    tNutLength = 8
    mountTowerLength=4
    innerAxisMountTower = new Cube({size:[innerAxisDia,mountTowerLength,@thickness+tNutLength],center:[true,true,false]})
    innerAxisMountTower.translate [0,-axisMountLength+mountTowerLength/2+0.5,-tNutLength]
    innerAxis.union innerAxisMountTower
    
    tSlotPos = -10.25-axisMountLength
    tSlot = new TSlot({height:@thickness+axisMountDepth, hsToShow:[false,true,false,false],invert:true})
    tSlot.translate [0,tSlotPos,0]
    
    tNut = new TNut({variant:"M3",length:tNutLength})
    tNut.rotate [0,90,90]
    tNut.translate [0,-innerAxisDia/2-axisMountLength+0.55,-tNut.length/2]
    tSlot.union tNut
    
    tSlot.translate [0,0.1,0]
    innerAxis.union tSlot
    
    boltHole = new Cylinder({d:3,h:100},center:true).rotate [90,0,0]
    boltHole.translate [0,0,-tNutLength/2]
    innerAxis.subtract boltHole

    innerAxisDepth = @thickness/2
    lockingNotches = 1
    lockingNotchesDia = @lockingNotchesDia
    startAngle = 0
    endAngle = limiterAngle
    angleOffset = (endAngle-startAngle) / lockingNotches 
    
    for i in [0...lockingNotches]
      lockingNotchHole = new Cylinder({d:lockingNotchesDia,h:innerAxisDepth,$fn:15})
      lockingNotchHole.translate [@axisID/2,0,0]
      lockingNotchHole.rotate [0,0,90]
      innerAxis.subtract lockingNotchHole
    
    innerAxis.color([1,0,0,0.5])
    @union innerAxis
    @mirroredZ()
      
    