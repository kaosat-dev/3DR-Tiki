include("CornerBase.coffee")

class TopCorner extends CornerBase
  constructor:(options)->
    @defaults = {
    }
    options = @injectOptions(@defaults,options)
    super options
