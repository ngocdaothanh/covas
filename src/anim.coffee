class Anim
  constructor: (@node) ->

  onComplete: (@onComplete) ->
    this

  #-----------------------------------------------------------------------------

  save: ->
    @active  = @node.active
    @x       = @node.x
    @y       = @node.y
    @offsetX = @node.offsetX
    @offsetY = @node.offsetY
    @scaleX  = @node.scaleX
    @scaleY  = @node.scaleY

  restore: =>
    @node.active  = @active
    @node.x       = @x
    @node.y       = @y
    @node.offsetX = @offsetX
    @node.offsetY = @offsetY
    @node.scaleX  = @scaleX
    @node.scaleY  = @scaleY

  #-----------------------------------------------------------------------------

  enterStageFromBottom: ->
    @save()
    @node.active = false
    @node.y      = jsg.stage.height
    new TWEEN.Tween(@node).to(
      {y: @y},
      500
    ).easing(
      TWEEN.Easing.Quadratic.Out
    ).onComplete(=>
      @restore()
      @onComplete() if @onComplete?
    ).start()
    this

  leaveStageToBottom: ->
    @save()
    new TWEEN.Tween(@node).to(
      {y: jsg.stage.height},
      500
    ).easing(
      TWEEN.Easing.Quadratic.In
    ).onComplete(=>
      @restore()
      @onComplete() if @onComplete?
    ).start()
    this

  #-----------------------------------------------------------------------------

  popOut: ->
    @save()
    @node.active  = false
    @node.scaleX  = 0.1
    @node.scaleY  = 0.1
    new TWEEN.Tween(@node).to(
      {scaleX: @scaleX, scaleY: @scaleY},
      1000
    ).easing(TWEEN.Easing.Elastic.Out).onComplete(@restore).start()
    this
