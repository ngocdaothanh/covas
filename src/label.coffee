# Default alignx: Label.LEFT, aligny: Label.TOP
#
# To reduce memory usage, canvas can be reused.
# Label constructor can be given width height or an existing canvas:
#   label1 = new Label(width, height)
#   label2 = new Label(existingCanvas)
class Label extends Sprite
  constructor: (canvasOrCanvasWidth, canvasHeight) ->
    super(canvasOrCanvasWidth, canvasHeight)
    @fontName  = null
    @fontSize  = 14
    @text      = null
    @textColor = '#ffffff'
    @alignx    = Label.LEFT
    @aligny    = Label.TOP

  # Called on each frame by #fireDraw, after #update.
  # Subclasses should override to do their specific drawing.
  draw: (accX, accY, accScaleX, accScaleY, accDeg) ->
    @updateCanvas()
    super(accX, accY, accScaleX, accScaleY, accDeg)

  updateCanvas: ->
    if @text?
      if @text.length > 0
        jsg.drawLabel(
          @canvas, @context,
          @fontName, @fontSize,
          @text, @textColor, @alignx, @aligny)
      else
        @clear()

#-------------------------------------------------------------------------------

Label.CENTER = 0

Label.LEFT   = 1
Label.RIGHT  = 2

Label.TOP    = 1
Label.BOTTOM = 2
