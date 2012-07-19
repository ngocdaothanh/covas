class Button extends Label
  constructor: (canvasWidth, canvasHeight) ->
    super(canvasWidth, canvasHeight)
    @alignx   = Label.CENTER
    @aligny   = Label.CENTER
    @fontSize = canvasHeight / 2

  updateCanvas: ->
    super()
    @roundRect(@context, 0, 1, @contentWidth, @contentHeight - 1)

  # http://stackoverflow.com/questions/1255512/how-to-draw-a-rounded-rectangle-on-html-canvas
  roundRect: (ctx, x, y, width, height, radius, fill, stroke) ->
    stroke = true if !stroke?
    radius = 15 if !radius?

    ctx.beginPath()
    ctx.moveTo(x + radius, y)
    ctx.lineTo(x + width - radius, y)
    ctx.quadraticCurveTo(x + width, y, x + width, y + radius)
    ctx.lineTo(x + width, y + height - radius)
    ctx.quadraticCurveTo(x + width, y + height, x + width - radius, y + height)
    ctx.lineTo(x + radius, y + height)
    ctx.quadraticCurveTo(x, y + height, x, y + height - radius)
    ctx.lineTo(x, y + radius)
    ctx.quadraticCurveTo(x, y, x + radius, y)
    ctx.closePath()
    ctx.stroke() if stroke
    ctx.fill() if fill
