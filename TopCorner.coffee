include("CornerBase.coffee")

class TopCorner extends CornerBase
  constructor:(options)->
    @defaults = {
      idlerCentered:false
    }
    options = @injectOptions(@defaults,options)
    super options
    
    
  generate:->
    super()
    
    footBaseSize = @footBaseSize
    vertTSlotPos = @vertTSlotPos
    
    #endstop mounting system
    endOfFoot = footBaseSize.x/2 + vertTSlotPos.x
    endStopOffset = @endStopOffset
    endstopPos = [endOfFoot+endStopOffset,0,0]
    bla = new Cylinder({d:4,h:4,center:[endstopPos,true,false]})
    endStopMount = new EndStopHolder()
    endStopMount.mirroredX()
    endStopMount.mirroredZ()
    endStopMount.translate endstopPos
    endStopMount.translate [0,0,@height]
    @union endStopMount
    @add bla
    
    @color([0.8,0.53,0.1,0.7])
    
    #for correct print orientation
    @translate [0,0,-@height]
    @mirroredZ()
    
    