# "content": null, image, or canvas.
#
# "contentWidth" and "contentHeight": default 0, can be > 0 even when "content"
# is null. This is typically useful for nodes that act as containers.
#
# A node may have parent and children.
#
# Transformation relative to parent (getters and setters):
# - x, y
# - scaleX, scaleY
# - deg (ratation angle in degrees)
#
# Absolute transformation (getters only):
# - accX, accY
# - accScaleX, accScaleY
# - accDeg
#
# There are only getters for absolute transformation, to transform use
# relative setters.
#
# Node width and height by default are 0, but but scaleX and scaleY can still be
# used to scale children (if they have size).
#
# "visible":
# A node is not drawn if it or its parents are not visible.
# "add" and "remove" change z order, setting "visible" does not change z order.
#
# "active":
# A node is not touchable if it or its parent are not active.
#
# Design once, scale everywhere:
#
# When creating a game, you decide a "standard" screen size, then create
# images for that screen size. Then to support a new screen size, you scale
# the images according to the ratio between the new screen and the "standard"
# screen. Methods to do this:
# - prescale:
#   Scale width according to screen width ratio and height according to screen
#   height ratio. For things like texts or circles, to preserve proportion,
#   only one ratio should be used for scaling to preserve proportion
# - prescaleByX:
#   Scale both width and height according to screen width ratio,
#   this keeps the image width/height proportion
# - prescaleByY:
#   Same as prescaleByX, but use screen height ratio instead
#
# Prescaling does not affect children. This allows children to have different
# prescaling to their parent.
#
# Offsets:
#
# The position/pivot point is at top left corner by default.
# But you can use offsetX and offsetY to adjust.
# - offsetX: 0.0 means left, 1.0 means right corner
# - offsetY: 0.0 means top, 1.0 means bottom corner
#
# Offsets are useful for physical objects. To set the position/pivot point to
# the center of an object, set offsetX and offsetX to 0.5.
#
# Touch:
#
# Events are not fired for a Node if its width/height is 0, it or its parent is
# invisible or inactive.
#
# s = new Sprite(100, 100)
# s.touch.down((localX, localX, globalX, globalY) =>
#   console.log("#{localX}, #{localY}, #{globalX}, #{globalY}")
# )
class Node
  constructor: ->
    @content       = null
    @contentWidth  = 0
    @contentHeight = 0

    @children = []
    @parent   = null

    @visible = true
    @active  = true

    @x        = 0
    @y        = 0
    @scaleX   = 1
    @scaleY   = 1
    @deg      = 0

    @prescaleX = 1
    @prescaleY = 1

    @offsetX = 0.0
    @offsetY = 0.0

    @touch = new NodeTouch(this)

  #-----------------------------------------------------------------------------

  add: (child) ->
    if child.parent?
      console.log 'Node#add warning: child already had parent'
    else
      @children.push(child)
      child.parent = this
    this

  addFirst: (child) ->
    if child.parent?
      console.log 'Node#add warning: child already had parent'
    else
      @children.unshift(child)
      child.parent = this
    this

  remove: (child) ->
    if child.parent == this
      idx = @children.indexOf(child)
      @children.splice(idx, 1) if idx != -1
      child.parent = null
    else
      console.log 'Node#remove warning: wrong parent'
    this

  removeAll: ->
    for c in @children
      c.parent = null
    @children = []
    this

  #-----------------------------------------------------------------------------

  hide: ->
    @parent.remove(this) if @parent?
    this

  bringToFront: ->
    if @parent?
      # Move to back so that this child is drawn last
      children = @parent.children
      idx      = children.indexOf(this)
      children.splice(idx, 1)
      children.push(this)
    this

  #-----------------------------------------------------------------------------

  prescale: ->
    @prescaleX = jsg.stage.scaleX
    @prescaleY = jsg.stage.scaleY
    this

  prescaleByX: ->
    @prescaleX = jsg.stage.scaleX
    @prescaleY = jsg.stage.scaleX
    this

  prescaleByY: ->
    @prescaleX = jsg.stage.scaleY
    @prescaleY = jsg.stage.scaleY
    this

  # TODO: use deg
  # Returns [x1, y1, x2, y2] in stage (global) coordinates
  boundingBox: ->
    accWidth      = @accWidth
    accHeight     = @accHeight
    offsetXLength = @offsetX * accWidth
    offsetYLength = @offsetY * accHeight

    x1 = @accX - offsetXLength
    x2 = x1 + accWidth
    y1 = @accY - offsetYLength
    y2 = y1 + accHeight
    [x1, y1, x2, y2]

  #-----------------------------------------------------------------------------
  # Align child in parent

  center: (sizableChild) ->
    sizableChild.x = (@width  - sizableChild.width)  / 2
    sizableChild.y = (@height - sizableChild.height) / 2
    this

  topCenter: (sizableChild) ->
    sizableChild.x = (@width - sizableChild.width) / 2
    sizableChild.y = 0
    this

  #-----------------------------------------------------------------------------

  # Called on each frame by parent, before #fireDraw.
  fireUpdate: (dt, t) ->
    if @visible && @active
      @update(dt, t)
      for c in @children
        # Check is needed because child may be removed during the loop
        c.fireUpdate(dt, t) if c?
    this

  # Called on each frame by parent, after #fireUpdate, to draw itself and children.
  # Subclass that acts as container (see ScrollView) may need to override.
  #
  # To optimize by avoiding recalculating transformation, children do not pull
  # transformation parameters from parent, instead parent pushes them to children.
  fireDraw: (parentAccX, parentAccY, parentAccScaleX, parentAccScaleY, parentAccDeg) ->
    if @visible
      accX      = parentAccX      + @x
      accY      = parentAccY      + @y
      accScaleX = parentAccScaleX * @scaleX
      accScaleY = parentAccScaleY * @scaleY
      accDeg    = parentAccDeg    + @deg

      # Draw itselft fist and children later so that children are drawn above.
      # Subclass that acts as container (see ScrollView) may need to override.
      @draw(accX, accY, accScaleX, accScaleY, accDeg)
      for c in @children
        # Check is needed because child may be removed during the loop
        c.fireDraw(accX, accY, accScaleX, accScaleY, accDeg) if c?
    this

  # Called on each frame by #fireUpdate, before #draw.
  # Subclasses should override to do their specific transformation.
  update: (dt, t) ->

  # Called on each frame by #fireDraw, after #update.
  # Subclasses should override to do their specific drawing.
  draw: (accX, accY, accScaleX, accScaleY, accDeg) ->
    if @content?
      # Here, calculating directly from accScaleX is faster than calculating @accWidth
      accWidth  = @contentWidth  * @prescaleX * accScaleX
      accHeight = @contentHeight * @prescaleY * accScaleY
      jsg.stage.drawToStage(@content, accX, accY, accWidth, accHeight, @offsetX, @offsetY, accDeg)
    this

#-------------------------------------------------------------------------------

Node.prototype.__defineGetter__('accVisible', ->
  @parent? && @visible && @parent.accVisible
)

Node.prototype.__defineGetter__('accActive', ->
  @parent? && @active && @parent.accActive
)

#-------------------------------------------------------------------------------

Node.prototype.__defineGetter__('accX', ->
  if @parent? then @parent.accX + @x else @x
)

Node.prototype.__defineGetter__('accY', ->
  if @parent? then @parent.accY + @y else @y
)

Node.prototype.__defineGetter__('accScaleX', ->
  if @parent? then @parent.accScaleX * @scaleX else @scaleX
)

Node.prototype.__defineGetter__('accScaleY', ->
  if @parent? then @parent.accScaleY * @scaleY else @scaleY
)

Node.prototype.__defineGetter__('accDeg', ->
  if @parent? then @parent.accDeg + @deg else @deg
)

#-------------------------------------------------------------------------------

Node.prototype.__defineSetter__('accX', (accX) ->
  if @parent? then @x = accX - @parent.accX else @x = accX
)

Node.prototype.__defineSetter__('accY', (accY) ->
  if @parent? then @y = accY - @parent.accY else @y = accY
)

#-------------------------------------------------------------------------------

Node.prototype.__defineGetter__('accWidth', ->
  @contentWidth * @prescaleX * @accScaleX
)

Node.prototype.__defineGetter__('accHeight', ->
  @contentHeight * @prescaleY * @accScaleY
)

Node.prototype.__defineGetter__('width', ->
  @contentWidth * @prescaleX * @scaleX
)

Node.prototype.__defineGetter__('height', ->
  @contentHeight * @prescaleY * @scaleY
)

Node.prototype.__defineSetter__('width', (width) ->
  @scaleX = width / (@prescaleX * @contentWidth)
)

Node.prototype.__defineSetter__('height', (height) ->
  @scaleY = height / (@prescaleY * @contentHeight)
)
