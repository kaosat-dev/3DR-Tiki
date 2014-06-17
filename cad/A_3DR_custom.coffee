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
include("LcdMount.coffee")
include("ElectronicsMount.coffee")


#TODO:fix motor mount bolt holes dia
#TODO: move t-nut positions closer to corner blocks

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

#topCorner = new TopCorner({smoothRodDia:5.99})#,footHeight:10##undersize slightly for tighter fit
#topCorner.translate([0,50,0])
#assembly.add( topCorner )

#use this to test if tslot shape fits
#topCornerTest = new TopCorner({footHeight:10})#,footHeight:10##undersize slightly for tighter fit
#topCorner.translate([0,50,0])
#assembly.add( topCornerTest )

#endStopHolder = new EndStopHolder()
#assembly.add endStopHolder

bottomCorner = new BottomCorner()
#bottomCorner.translate([0,-50,0])
assembly.add( bottomCorner)

#motorMount = new MotorMount()
#assembly.add( motorMount )

#lcdMount = new LcdMount()
#assembly.add lcdMount

#elecMount = new ElectronicsMount()
#assembly.add elecMount


#compute XYZSteps
XYZ_FULL_STEPS_PER_ROTATION =200
XYZ_MICROSTEPS =32

###
XYZ_BELT_PITCH= 2
XYZ_PULLEY_TEETH= 17
XYZ_STEPS1 =(XYZ_FULL_STEPS_PER_ROTATION * XYZ_MICROSTEPS / XYZ_BELT_PITCH / XYZ_PULLEY_TEETH)
###

#pi = 3.1415926
XYZ_SPOODLRADIUS = 9
XYZ_FILAMENTRADIUS =0.2
spoolPerim = 2*Math.PI*(XYZ_SPOODLRADIUS+XYZ_FILAMENTRADIUS)
bla = spoolPerim/(XYZ_FULL_STEPS_PER_ROTATION * XYZ_MICROSTEPS)
XYZ_STEPS = ( 1/bla)
console.log("XYZ Steps",XYZ_STEPS)

#computations on where to put the "lift" in order to mount it correctly
#windinds ccw and cw should be the same
idlerDia = 13
spoolDia = 18
filamentDia = 0.4
filaLength=2000
filaSpoolWindings = 7 #how many windings ccw and cw on spool
platformKnotingOffset=13
idlerToSpoolDist = 460

idlerCircum = (2*Math.PI)*(idlerDia/2)
spoolCircum = (2*Math.PI)*(spoolDia/2)

windedLength = filaSpoolWindings*2*spoolCircum
filaRealLength=filaLength - windedLength
filaLengthExtra = filaRealLength - idlerToSpoolDist*2 - idlerCircum/2 + platformKnotingOffset
halfFilaLengthExtra = filaLengthExtra/2

console.log "idlerCircum",idlerCircum,"spoolCircum",spoolCircum,"filaRealLength",filaRealLength
console.log "filaLengthExtra",filaLengthExtra , "per strand (for knots)",halfFilaLengthExtra

distFromTop = (-idlerCircum/2 +3*platformKnotingOffset/2)/2
distFromTop += platformKnotingOffset/2
console.log("distFromTop",distFromTop)
#extraLeft = idlerCircum/4 + distFromTop
#idlerToSpoolDist-xPos = 0
#leftFilaLength = rightFilaLength = halfFilaLength
#leftFilaLength = halfFilaLength + idlerCircum/4

