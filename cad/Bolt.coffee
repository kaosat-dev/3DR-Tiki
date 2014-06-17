 

class Bolt extends Part
  @cache = {}
  constructor:(options)->
    @defaults = {
      length:10
      dia:4
      headDia: 8,
      headLength: 2.3
      generateAtConstruct:true
    }
    options = @injectOptions(@defaults,options)
    super options
    
    if @generateAtConstruct
      @generate()
    
    ###
    cacheOverride = options.cacheOverride or false
  
    if not cacheOverride
      if not  Bolt.cache[options]
        Bolt.cache[options] = @
      return Bolt.cache[options]###
    
  generate:->
    body = new Cylinder({d:@dia,h:@length,center:[true,true,true]})
    head = new Cylinder({d:@headDia,h:@headLength,center:[true,true,false]})
    head.translate([0,0,@length/2-@headLength])
    @union body
    @union head
