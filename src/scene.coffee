# Scenes are added to the stage, but their parents are null, not the stage.
# A scene is a root of a node hierachy.
class Scene extends Node
  constructor: ->
    super()
    @contentWidth  = jsg.stage.width
    @contentHeight = jsg.stage.height

    # Node is visible and active after created, but scene is not because it's
    # a root of a node hierachy. It's "visible" and "active" will be reset by
    # the stage.
    @visible = false
    @active  = false

  show: ->
    jsg.stage.add(this) if !@visible

  hide: ->
    jsg.stage.remove(this)

#-------------------------------------------------------------------------------
# Redefine accVisible and accActive because scene has no parent

Scene.prototype.__defineGetter__('accVisible', ->
  @visible
)

Scene.prototype.__defineGetter__('accActive', ->
  @active
)
