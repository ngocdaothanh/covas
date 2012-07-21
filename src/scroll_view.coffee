# TODO: Only vertical scrolling is supported now; need to add support for hirizontal scrolling
class ScrollView extends Node
  constructor: (contentWidth, contentHeight) ->
    super()  # @contentWidth and @contentHeight are set to 0 here
    @contentWidth       = contentWidth
    @contentHeight      = contentHeight
    [@canvas, @context] = jsg.createCanvasAndContext(ScrollView.SCROLLBAR_WIDTH, contentHeight)
    @content            = @canvas

    @scrollbarAlpha = 0.0
    @touch.down(@onDown)
    @touch.move(@onMove)

  #-----------------------------------------------------------------------------

  update: ->
    @scrollbarAlpha -= 0.1 if @scrollbarAlpha > 0

  # Draws children in side its region, then draws scrollbar if neccessary.
  fireDraw: (parentAccX, parentAccY, parentAccScaleX, parentAccScaleY, parentAccDeg) ->
    if @visible && @children.length > 0
      accX      = parentAccX      + @x
      accY      = parentAccY      + @y
      accScaleX = parentAccScaleX * @scaleX
      accScaleY = parentAccScaleY * @scaleY
      accDeg    = parentAccDeg    + @deg

      accWidth  = @contentWidth  * @prescaleX * accScaleX
      accHeight = @contentHeight * @prescaleY * accScaleY

      # Set the scroll view area as the clipping region
      ctx = jsg.stage.context
      ctx.save()
      ctx.beginPath()
      ctx.rect(accX, accY, accWidth, accHeight)
      ctx.clip()

      # Children will be drawn inside the clipping region
      for c in @children
        # Check is needed because child may be removed during the loop
        c.fireDraw(accX, accY, accScaleX, accScaleY, accDeg) if c?

      # Remove the clipping region
      ctx.restore()

      # Draw scrollbar
      if @scrollbarAlpha > 0.1
        @drawScrollbar()
        scrollbarAccWidth  = ScrollView.SCROLLBAR_WIDTH * @prescaleX * accScaleX
        scrollbarAccX      = accX + accWidth - scrollbarAccWidth
        scrollbarAccY      = accY
        scrollbarAccHeight = accHeight
        jsg.stage.drawToStage(
          @content,
          scrollbarAccX, scrollbarAccY, scrollbarAccWidth, scrollbarAccHeight,
          @offsetX, @offsetY, accDeg)

    this

  drawScrollbar: ->
    # Calculate childrenHeight
    minY1 =  9999
    maxY2 = -9999
    for c in @children
      if c?
        y1 = c.y
        y2 = y1 + c.height
        minY1 = y1 if y1 < minY1
        maxY2 = y2 if y2 > maxY2

    # Only draw if neccessary
    canvas         = @canvas
    canvasHeight   = canvas.height
    childrenHeight = maxY2 - minY1
    return if childrenHeight <= canvasHeight

    percent         = canvasHeight / childrenHeight
    scrollBarHeight = canvasHeight * percent

    scrollBarX = 0

    s          = canvasHeight - scrollBarHeight
    percent    = @children[0].y / (canvasHeight - childrenHeight)
    scrollBarY = s * percent

    ctx = @context
    ctx.clearRect(0, 0, @canvas.width, @canvas.height)
    ctx.beginPath()
    ctx.rect(scrollBarX, scrollBarY, ScrollView.SCROLLBAR_WIDTH, scrollBarHeight)
    ctx.fillStyle = "rgba(191, 191, 191, #{@scrollbarAlpha})"
    ctx.fill()

  #-----------------------------------------------------------------------------

  onDown: (@lastTouchX, @lastTouchY) =>

  onMove: (x, y) =>
    length = @children.length
    return if length == 0

    fy = @children[0].y

    lc = @children[length - 1]
    ly = lc.y + lc.height

    return if fy >= 0 && ly <= @canvas.height

    dy          = y - @lastTouchY
    @lastTouchY = y

    if dy > 0
      dy = -fy if fy + dy > 0
    else if dy < 0
      dy = @contentHeight - ly if ly + dy < @contentHeight

    @scrollbarAlpha = 1.0
    for c in @children
      c.y += dy

#-------------------------------------------------------------------------------

ScrollView.SCROLLBAR_WIDTH = 5
