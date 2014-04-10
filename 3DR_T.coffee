include("TSlot.coffee")
include("SRMount.coffee")
include("TopCorner.coffee")
include("BottomCorner.coffee")
include("Nema.coffee")

#bla = new TSlot()
#assembly.add bla

#srM = new SmoothRodMount()
#assembly.add( srM )

topCorner = new TopCorner()
assembly.add( topCorner )

#bottomCorner = new BottomCorner()
#assembly.add( bottomCorner)



#motorMount = new MotorMount()
#assembly.add( motorMount )

###
motor = new NemaMotor()
motor.translate([20,0,-motor.motorBody_len*2-10])
motor.rotate([0,-90,0])
assembly.add(motor)###


