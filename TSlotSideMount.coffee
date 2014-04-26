
class TSlotSideMount extends Part
  constructor:(options)->
    @defaults = {
      length:20
      width:20
      thickness:5
      
      slideLength:30
      slideBorderDepth:0.6
      tNutLength:10
      
      mountHoleDia : 4
      mountBoltHeadInset : 1.5
      nbHorizMountHoles:2
      nbVertMountHoles:2
      mountHoleSliderCleareance : 2
      mountHolePositions:null
      clearance:0.5
      
    }
    options = @injectOptions(@defaults,options)
    super options
    
    refBolt = new Bolt({generateAtConstruct:false})
    @refBolt = refBolt
    
    if @mountHolePositions is null
      @mountHolePositions= []
      borderSize = 0#refBolt.headDia/2
      validRange = (@length - borderSize)
      offset = validRange/@nbHorizMountHoles
      bLength = validRange-(@nbHorizMountHoles-1)*offset;
      for i in [0...@nbHorizMountHoles]
        @mountHolePositions.push( i*offset+bLength/2+borderSize/2 )
    
    else
      @nbHorizMountHoles = @mountHolePositions.length
    
    @slideHelperPositions= []
    @sliderHelperLengths = []
    
    tNutLength = @tNutLength+@clearance
    pos = 0
    start = 0
    end = @mountHolePositions[0]
    length = (end - start)/2 
    pos = start + length
    @slideHelperPositions.push pos-tNutLength/4
    @sliderHelperLengths.push end-start-tNutLength/2
    
    for i in [0...@nbHorizMountHoles-1]
      start = @mountHolePositions[i]
      end = @mountHolePositions[i+1]
      length = (end - start)/2 
      pos = start + length
      @slideHelperPositions.push pos
      @sliderHelperLengths.push end-start-tNutLength
      
    start = @mountHolePositions[@mountHolePositions.length-1]
    end = @length
    length = (end - start)/2 
    pos = start + length
    @slideHelperPositions.push pos+tNutLength/4
    @sliderHelperLengths.push end-start-tNutLength/2
    
    @generate()
  
  genSlideHelper:(slideLength,baseOnly)->
    baseOnly = baseOnly or false
    thickness = @thickness
    length = @length
    tSlotRef = new TSlot({generateAtConstruct:false})
    reduction = 3
    slideWidth = tSlotRef.hsFootW
    slideDepth = tSlotRef.hsHeight/2
    slideBorderDepth = 0.6
    if baseOnly
      slideHelper = CAGBase.fromPoints([
        [slideDepth-slideBorderDepth, slideWidth/2]
        [slideDepth,slideWidth/2]
        [slideDepth,-slideWidth/2]
        [slideDepth-slideBorderDepth, -slideWidth/2]
      ])
    else
      slideHelper = CAGBase.fromPoints([
        [0,-(slideWidth-reduction)/2]
        [0, (slideWidth-reduction)/2]
        [slideDepth-slideBorderDepth, slideWidth/2]
        [slideDepth,slideWidth/2]
        [slideDepth,-slideWidth/2]
        [slideDepth-slideBorderDepth, -slideWidth/2]
      ])
    slideHelper = slideHelper.extrude({offset:[0,0,slideLength]})
    slideHelper.translate [-thickness/2-slideDepth,0,0]

    #slideHelper.translate [-thickness/2-slideDepth,0,(length-slideLength)/2]
    return slideHelper
  
  generate:->
    tSlotRef = new TSlot({generateAtConstruct:false})
    slideLength = @slideLength
    thickness = @thickness
    width = @width
    length = @length
    
    #slideLength
    
    
    for sliderPos,index in @slideHelperPositions
      segmentLength = @sliderHelperLengths[index]
      slideHelperSegment = @genSlideHelper(segmentLength)
      slideHelperSegment = slideHelperSegment.translate([0,0,sliderPos-segmentLength/2])
      @union slideHelperSegment
    
    slideHelper = @genSlideHelper(@length,true)
    slideHelper.translate [0,0,0]
    @union slideHelper
    
    armBase = new Cube({size:[thickness,20,length],center:[true,true,false]})
    @union armBase
    
    
    mountHoleDia = @mountHoleDia
    mountBoltHeadInset = @mountBoltHeadInset
    mountHoleSliderCleareance = @mountHoleSliderCleareance
    mountHolePositions= @mountHolePositions
    mountHoleZPositions = [-width/4,width/4]
    mountHoleZPositions = [0]
    
    mntHoleDepth = thickness+@slideBorderDepth
    for mntHoleZpos in mountHoleZPositions
      for mntHoleXPos in mountHolePositions
        mountHole = new Cylinder({d:mountHoleDia,h:mntHoleDepth,center:[true,false,true]})
        mountHole.rotate([90,0,90])
        mountHole.translate([-@slideBorderDepth,mntHoleZpos,mntHoleXPos])

        #TODO: this is for M4, needs to adapt to dia
        mountBoltHHole = new Cylinder({d:@refBolt.headDia,h:10,center:[false,false,false]})
        mountBoltHHole.rotate([90,0,90])
        
        holeXPos = thickness/2 - mountBoltHeadInset
        mountBoltHHole.translate([holeXPos,mntHoleZpos,mntHoleXPos])

        bolt = new Bolt()
        bolt.rotate([90,0,90])
        bolt.translate([-holeXPos,mntHoleZpos,mntHoleXPos])
        
        #boltOf = -width/2 + bolt.length-bolt.headLength
        #bolt.translate([mntHolePos,boltOf,mntHoleZpos])

        @subtract mountBoltHHole.color([1,0,0])
        @subtract mountHole
        #@add bolt
        
        #@add mountBoltHHole
    @color([0.6,1,0,0.6])
    
    @rotate [90,0,90]
    @translate [0,0,width/2]