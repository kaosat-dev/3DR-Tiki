 

class TNut extends Nut
  constructor:(options)->
    @defaults = {
      thickness:3.2
      holeDia:4
      headDia:7.66
      variant:"m4"
      
      generateAtConstruct:true
      outlineOnly:false
    }
    options = @injectOptions(@defaults,options)
    super options
    
    if @generateAtConstruct
      @generate()
      
  generate:->
    nut = new Nut({outlineOnly:true})
    tHeadShape = new TSlot({hsToShow:[false,false,true,false]})
    tNut = new Cube({size:[20,20,10],center:[true,true,false]}).subtract tHeadShape
    nut.rotate([0,90,0])
    nut.translate [0,0,5]
    tNut.translate [-4.3,0,0]
    tNut.subtract nut
    
    hole = new Cylinder({d:4,h:20})
    hole.rotate [0,90,0]
    hole.translate [0,0,5]
    tNut.subtract hole
    tNut.rotate [0,-90,0]
    @union tNut