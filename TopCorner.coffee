include("CornerBase.coffee")

class TopCorner extends CornerBase
  constructor:(options)->
    @defaults = {
      idlerCentered:false
    }
    options = @injectOptions(@defaults,options)
    super options
