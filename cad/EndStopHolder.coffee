 

class EndStopHolder extends Part
  constructor:(options)->
    @defaults = {
      generateAtConstruct:true
      outlineOnly:false
    }
    options = @injectOptions(@defaults,options)
    super options
    
    if @generateAtConstruct
      @generate()
      
  generate:->
    angle=20
    pcbWidth=22
    pcbLength=31
    pcbThickness=1.7
    pcbHolesOffset=4.8 #from the top : the top being where the sensor is
    pcbSensorOffset = 4
    
    mountHolesDist = 17
    mountHolesDia = 3
    mountHolesToSensor = 11
    
    sensorOffset = 4
    sensorWidth = 4
    sensorLength = 3
    
    mountTubeLength = 6
    
    backblockLength=3
    backblockHeight=4
    holderBlockWallsThickness = 2
    
    pcbOffset = [pcbSensorOffset-sensorLength/2,0,0]
    
    #pcbHole =  new Cylinder({d:mountHolesDia,h:pcbThickness,center:[pcbLength-pcbHolesOffset,mountHolesDist/2,false]})
    #pcb.subtract pcbHole
    #pcb.subtract pcbHole.clone().mirroredY()
    
    #pcb.add mountTube #FIXME:this should offset the mountube when translating the pcb, but it does NOT !!!
    holderBlockLength = pcbLength+holderBlockWallsThickness*2
    holderBlockWidth  = pcbWidth+holderBlockWallsThickness*2
    holderBlockHeight = 12
    
    
    pbcHolderBlock = new Cube({size:[holderBlockLength
      ,holderBlockWidth,holderBlockHeight],center:[true,true,false]})
    pbcHolderBlock.subtract new Cube({size:[pcbLength
      ,pcbWidth,holderBlockHeight],center:[true,true,false]})
    pbcHolderBlock.translate [-holderBlockLength/2,0,0]
    
    mntTubeRealLength = mountTubeLength#-pcbThickness
    mountArmsDist = 40
    mountTubeOd = mountHolesDia+7
    mountArmLength = 13
    mountHolesPos = [-mountHolesToSensor,-mountHolesDist/2]
    
    mountTubeHole = new Cylinder({d:mountHolesDia,h:mntTubeRealLength,center:[true,true,false]})
    
    mountArm =CAGBase.fromPoints([
      [-mountTubeOd/2, -mountArmLength-3]
      [-mountTubeOd/2, 0]
      [mountTubeOd/2,0]
      [mountTubeOd/2,-mountArmLength]
    ])
    
    mountTube = new Circle({d:mountTubeOd,center:[true,true]})
    translate(mountHolesPos, [mountArm,mountTube])
    
    sensorPilarShape = new Rectangle({size:[sensorLength,sensorWidth],center:[true,true]})
    centerShape = new Rectangle({size:mountTubeOd,center:[mountHolesPos[0],true]})
    
    mountArm = hull([mountArm,mountTube,centerShape,sensorPilarShape])
    mountArm = mountArm.extrude({offset:[0,0,mntTubeRealLength]})
    
    #slight offset for easier bridging
    mountTubeHole.translate [0,0,pcbThickness+0.1]
    mountArm.subtract mountTubeHole.translate mountHolesPos
    
    mountNut = new Nut({variant:"M3",outlineOnly:true})
    mountNut.translate( [0,0,mntTubeRealLength-mountNut.thickness]).translate mountHolesPos
    mountArm.subtract mountNut
    
    pcb = new Cube({size:[pcbLength,pcbWidth,pcbThickness],center:[true,true,false]})
    mountArm.subtract pcb.translate [mountHolesPos[0],0]
    
    #mountArm.translate [-pcbHolesOffset-holderBlockWallsThickness,-mountHolesDist/2,0]
    @union mountArm
    @union mountArm.clone().mirroredY()
    
    sensorPilar = new Cube({size:[sensorLength,sensorWidth,mntTubeRealLength],center:[true,true,false]})
    @union sensorPilar
    
    return
    
    
    pbcHolderBlock.subtract mountTubeHole
    pbcHolderBlock.subtract mountTubeHole.clone().mirroredY()
    
    
    pbcHolderBlock.rotate([0,-angle,0])
    pbcHolderBlock.translate [0,0,10]
    @union pbcHolderBlock
    
    
    mountPlateDist = 60
    mountShapeWidth = 10
    mountShapeLength = 35
    mountShapeThickness = 3
    
    mountShapeWalls=3
    mountShapeHoleDia = 4
    mountShapeSideWalls = mountShapeHoleDia+4
    
    
    halfAngle = 30
    halfAngleRadian = halfAngle * Math.PI/180
    #offsetX = Math.cos(halfAngleRadian)*mountShapeWidth
    offsetY = Math.tan(halfAngleRadian)*mountShapeLength
    
    mountPlateShape = CAGBase.fromPoints([
      [-mountShapeLength,mountPlateDist/2+offsetY ]
      [-mountShapeLength,-mountPlateDist/2-offsetY ]
      [0,-mountPlateDist/2]
      [0,mountPlateDist/2]
    ])
    mountPlateShape = mountPlateShape.extrude( {offset:[0,0,mountShapeThickness]} )
    
    mountPlateShapeInner = CAGBase.fromPoints([
      [-mountShapeLength+mountShapeWalls,-mountPlateDist/2+mountShapeSideWalls]
      [-mountShapeLength+mountShapeWalls,mountPlateDist/2-mountShapeSideWalls]
      [-mountShapeWalls,mountPlateDist/2+offsetY-mountShapeSideWalls*2]
      [-mountShapeWalls,-mountPlateDist/2-offsetY+mountShapeSideWalls*2]
    ])
    #mountPlateShape.subtract( mountPlateShapeInner.extrude( {offset:[0,0,mountShapeThickness]} ))
    @union mountPlateShape
    
    mountHolesPositions = [
      [-5, mountPlateDist/2+offsetY-10]  
      [-25, mountPlateDist/2+offsetY-20]
    ]
    
    for holePos in mountHolesPositions
      [xpos, ypos] = holePos
      mountShapeHole = new Cylinder({d:mountShapeHoleDia,h:mountShapeThickness,center:[xpos,ypos,false]})
      @subtract mountShapeHole
      @subtract mountShapeHole.mirroredY()
      
      #@add mountShapeHole.color([1,0,0])
    
    
    