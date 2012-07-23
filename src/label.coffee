# Default alignx: Label.LEFT, aligny: Label.TOP
class Label extends Sprite
  constructor: (canvasWidth, canvasHeight) ->
    super(canvasWidth, canvasHeight)
    @_fontName  = null
    @_fontSize  = 14
    @_text      = null
    @_textColor = '#ffffff'
    @_alignx    = Label.LEFT
    @_aligny    = Label.TOP

  updateCanvas: ->
    if @_text?
      if @_text.length > 0
        jsg.drawLabel(
          @canvas,
          @_fontName, @_fontSize,
          @_text, @_textColor, @_alignx, @_aligny)
      else
        @clear()

#-------------------------------------------------------------------------------

Label.prototype.__defineGetter__('fontName', ->
  @_fontName
)

Label.prototype.__defineGetter__('fontSize', ->
  @_fontSize
)

Label.prototype.__defineGetter__('text', ->
  @_text
)

Label.prototype.__defineGetter__('textColor', ->
  @_textColor
)

Label.prototype.__defineGetter__('alignx', ->
  @_alignx
)

Label.prototype.__defineGetter__('aligny', ->
  @_aligny
)

#-------------------------------------------------------------------------------

Label.prototype.__defineSetter__('fontName', (val) ->
  @_fontName = val
  @updateCanvas()
)

Label.prototype.__defineSetter__('fontSize', (val) ->
  @_fontSize = val
  @updateCanvas()
)

Label.prototype.__defineSetter__('text', (val) ->
  @_text = val
  @updateCanvas()
)

Label.prototype.__defineSetter__('textColor', (val) ->
  @_textColor = val
  @updateCanvas()
)

Label.prototype.__defineSetter__('alignx', (val) ->
  @_alignx = val
  @updateCanvas()
)

Label.prototype.__defineSetter__('aligny', (val) ->
  @_aligny = val
  @updateCanvas()
)

#-------------------------------------------------------------------------------

Label.CENTER = 0

Label.LEFT   = 1
Label.RIGHT  = 2

Label.TOP    = 1
Label.BOTTOM = 2
