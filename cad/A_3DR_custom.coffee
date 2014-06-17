include("TSlot.coffee")
include("Bolt.coffee")
include("Nut.coffee")
include("HexKey.coffee")
include("Nema.coffee")
include("TNut.coffee")


include("SRMount.coffee")
include("TopCorner.coffee")
include("BottomCorner.coffee")
include("TSlotSideMount.coffee")
include("EndStopHolder.coffee")
include("RodJig.coffee")

#tSlot = new TSlot({fudge:false,height:200})
#assembly.add tSlot

#tSlot = new TSlot()
#assembly.add tSlot

#tSlotSide = new TSlotSideMount()
#assembly.add tSlotSide

#rodJig = new RodJig()
#assembly.add rodJig

#bolt = new Bolt()
#assembly.add bolt

#nut = new Nut({variant:"M5",outlineOnly:true})
#assembly.add nut

#tNut = new TNut()
#assembly.add tNut

#hexKey = new HexKey()
#assembly.add hexKey

#srM = new SmoothRodMount()
#assembly.add( srM )

#c = new Cube({size:30})
#assembly.add c

topCorner = new TopCorner({smoothRodDia:5.99})#,footHeight:10##undersize slightly for tighter fit
#topCorner.translate([0,50,0])
assembly.add( topCorner )

#use this to test if tslot shape fits
#topCornerTest = new TopCorner({footHeight:10})#,footHeight:10##undersize slightly for tighter fit
#topCorner.translate([0,50,0])
#assembly.add( topCornerTest )

#endStopHolder = new EndStopHolder()
#assembly.add endStopHolder

#bottomCorner = new BottomCorner()
#bottomCorner.translate([0,-50,0])
#assembly.add( bottomCorner)

#motorMount = new MotorMount()
#assembly.add( motorMount )
