 
###
*Rod jig tool , for easier carbon fiber rod cutting/sizing
###
class RodJig extends Part
  constructor:(options)->
    @defaults = {
      width: 20,
      length: 30
      thickness:5.5
      mountHoleDia:5
      eyeHoleDia:3
      generateAtConstruct:true
    }
    options = @injectOptions(@defaults,options)
    super options
    
    if @generateAtConstruct
      @generate()
      
  generate:->
    body = new Cube({size:[@length,@width,@thickness-1],center:[true,true,false]})
    tSlotSlider = new Cube({size:[@length,5.5,1],center:[true,true,false]})
    tSlotSlider.translate [0,0,@thickness-1]
    
    mountHole = new Cylinder({d:@mountHoleDia,h:@thickness,center:[@length/4,true,false]})
    deltaArmMountHole = new Cylinder({d:@eyeHoleDia,h:@thickness,center:[-@length/4,true,false]})
    
    @union body
    @union tSlotSlider
    @subtract mountHole
    @subtract deltaArmMountHole
    