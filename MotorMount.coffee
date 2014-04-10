 include("Nema.coffee")

class MotorMount extends Part
  constructor:(options)->
    @defaults = {
      width:50
      height : 50
      thickness:8
      smoothRodMounts : true
    }
    options = @injectOptions(@defaults,options)
    super options
    @generate()
    
  generate:->
    plate = new Cube({size:[@thickness,@width,@height],center:[true,true,false]})
    
    motor = new NemaMotor({generateAtConstruct:false})
    
    pilotRing = new Cylinder(
      {
        h: @thickness
        r: motor.pilotRing_radius
        center: [true, true, true]
      }).color([0.5, 0.5, 0.6])
    pilotRing.rotate([0,90,0]).translate([0,0,@height/2])
    
    @union plate
    @subtract( pilotRing )
    
    mountingholes = new Cylinder({
      h: @thickness*2
      r: motor.mountingholes_radius
      center: [-@height/2, true, true ]
    })
    
    
    mntHolRad = motor.mountingholes_radius
    mntHoleSLng = 10
    mntHoleSOffs = mntHoleSLng/2 - mntHolRad
    mntHoleSStart = new Circle({r:mntHolRad,$fn:10,center:[mntHoleSOffs,0]})
    mntHoleSEnd = new Circle({r:mntHolRad,$fn:10,center:[-mntHoleSOffs,0]})

    mntHoleShape = hull([mntHoleSEnd, mntHoleSStart] )
    mntHoleShape = mntHoleShape.extrude({offset:[0,0,@thickness]})
    #@add mntHoleShape
    
    mntHoleCenterOffset = motor.mountingholes_fromcent
    mountingholes.rotate([0,90,0])
    for i in [-1,1]
      for j in [-1,1]
        tmpShape = mntHoleShape.clone()
        tmpShape.rotate([0,90,0])
        tmpShape.rotate([45*j*-i,0,0])
        tmpShape.translate([-@thickness/2,0,@height/2])
        
        tmpShape.translate([0,mntHoleCenterOffset*i,mntHoleCenterOffset*j])

        @subtract tmpShape.color([1,0,0])
        
