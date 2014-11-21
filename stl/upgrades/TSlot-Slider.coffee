

class TSlotSlider extends Part
  @cache = {}
      
  constructor:(options)->
    @defaults = {
      thickness:4
      length:30
      
      armMoutLength:5
      armsMountHoleDia:3
      armsMountHoleExtra:1
      armsDistance: 27.8
      armsToTslotDist:20
      
      mountHolesDia:3
      
      magnetDia:1.5#for hall-o end sensor
      magnetToTslotDist:30
      
      beltThickness:1
      beltWidth:5
      
      belt:null
      tSlot: null
      
      clearance : 0.125
      
      generateAtConstruct:true
      outlineOnly:false
    }
    options = @injectOptions(@defaults,options)
    super options
    
    #@thickness = Nut.dimsLookUp[@variant].thickness
    #@holeDia   = Nut.dimsLookUp[@variant].holeDia
    #@headDia   = Nut.dimsLookUp[@variant].headDia
    
    if @generateAtConstruct
      @generate()

  generate:->
    clearance = @clearance
    thickness = @thickness
    length    = @length
    halfWidth = @armsDistance/2
    innerWidth = @armsDistance/2 - @armMoutLength
    
    armNutOffset= 2
    nutHoleLen = 8
    hornThickness = thickness*2
    
    
    #holeShape = new Cylinder({d:@holeDia,h:@thickness})
    #outlineShape = new Cylinder({d:@headDia,h:@thickness,$fn:6})
    baseShape = new Cube({size:[innerWidth,length,thickness],center:[false,true,false]})
    baseShape.translate [0,0,-thickness]
    
    #ball joint mount horns
    armHorns = new Part();
    
    horn = new Cylinder({d2 : 14, d1 : @armsMountHoleDia+@armsMountHoleExtra, 
    h : @armMoutLength, $fn:13 })
    horn.rotate [0,90,0]
    
    hornCut = new Cube({size:[halfWidth, 18, hornThickness], center : true})
    horn.intersect hornCut
    
    horn.translate [innerWidth,0,0]
    
    #horn.translate [0,@armsToTslotDist,0]
    armHorns.union horn
    
    baseShape.union armHorns
    
    armNutBoltHoles = new Part()
    
    armBolt = new Cylinder({d:@armsMountHoleDia, h : halfWidth,center:[true,true,false],$fn:7})
    nut = new Nut({thickness:nutHoleLen, outlineOnly:true})
    nut.rotate([0,0,90])
    nut.translate [0,0,innerWidth-nutHoleLen+armNutOffset]
    
    armNutBoltHoles.union armBolt
    armNutBoltHoles.union nut
    
    armNutBoltHoles.rotate [0,90,0]
    #armNutBoltHoles.translate [0,@armsToTslotDist,0]
    baseShape.subtract armNutBoltHoles
    
    
    #magnet hole for endstop
    magnet = new Cylinder({d:@magnetDia,h:3})
    magnet.rotate [90,0,0]
    magnet.translate [0,@magnetToTslotDist,0]
    baseShape.union magnet
    
    @union baseShape
    #@union baseShape.mirroredX()
    
    return
    #belt clamps for GT2
    clampBody = new Part()
    
    #teeth
    step = 3
    toothRad =0.7
    teethNb = 20
    teethDist = 3
    for x in [-teethDist/2,teethDist/2]
      for y in [0...teethNb] #by step
        offset = teethNb - y * 2
        tooth = new Cylinder( {r:toothRad,h:@armMoutLength,$fn:5} ).translate [x,offset,0]
        clampBody.union tooth
    
    @union clampBody
    
    
