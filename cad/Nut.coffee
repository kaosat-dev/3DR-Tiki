 

class Nut extends Part
  @cache = {}
  
  @dimsLookUp = 
    M3:
      holeDia:3
      headDia:6.01
      thickness:2.4
    M4:
      holeDia:4
      headDia:7.66
      thickness:3.2
    M5:
      holeDia:5
      headDia:8.79
      thickness:4.7
      
  constructor:(options)->
    @defaults = {
      thickness:3.2
      holeDia:4
      headDia:7.66
      variant:"M4"
      
      generateAtConstruct:true
      outlineOnly:false
    }
    options = @injectOptions(@defaults,options)
    super options
    
    @thickness = Nut.dimsLookUp[@variant].thickness
    @holeDia   = Nut.dimsLookUp[@variant].holeDia
    @headDia   = Nut.dimsLookUp[@variant].headDia
    
    if @generateAtConstruct
      @generate()
      
  generate:->
    holeShape = new Cylinder({d:@holeDia,h:@thickness})
    outlineShape = new Cylinder({d:@headDia,h:@thickness,$fn:6})
    if not @outlineOnly
      outlineShape.subtract holeShape
    @union outlineShape
    
    