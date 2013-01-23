# Sprite is a wrapper for canvas, it makes canvas a Node.
# To reduce memory usage, canvas can be reused.
# Sprite constructor can be given width height or an existing canvas:
#   sprite1 = new Sprite(width, height)
#   sprite2 = new Sprite(existingCanvas)
class Sprite extends Node
  constructor: (canvasOrCanvasWidth, canvasHeight) ->
    super()  # @contentWidth and @contentHeight are set to 0 here

    if (typeof canvasOrCanvasWidth != 'number')
      # Reuse an existing canvas
      @content       = @canvas = canvasOrCanvasWidth
      @context       = @canvas.context
      @contentWidth  = @canvas.width
      @contentHeight = @canvas.height
    else
      # Create a new canvas
      @contentWidth       = canvasOrCanvasWidth
      @contentHeight      = canvasHeight
      [@canvas, @context] = jsg.createCanvasAndContext(canvasOrCanvasWidth, canvasHeight)
      @content            = @canvas

  # args:
  #   no arg
  #   alpha (0.0-1.0)
  #   gray (0-255), alpha
  #   r, g, b, alpha
  darken: (args...) ->
    [r, g, b, a] =
      if args.length == 0
        [0, 0, 0, 0.6]
      else if args.length == 1
        [0, 0, 0, args[0]]
      else if args.length == 2
        c = args[0]
        a = args[1]
        [c, c, c, a]
      else
        args

    @context.fillStyle = "rgba(#{r}, #{g}, #{b}, #{a})"
    @context.fillRect(0, 0, @contentWidth, @contentHeight)

  clear: ->
    @context.clearRect(0, 0, @contentWidth, @contentHeight)

  drawImageFit: (imageOrImageSrc, keepRatio = false) ->
    image =
      if typeof imageOrImageSrc == 'string'
        jsg.loadImage(imageOrImageSrc)
      else
        imageOrImageSrc

    if keepRatio
      w1 = Math.min(image.width, @contentWidth)
      h1 = image.height * w1 / image.width

      h2 = Math.min(h1, @contentHeight)
      w2 = image.width * h2 / image.height

      x = (@contentWidth  - w2) / 2
      y = (@contentHeight - h2) / 2
      @context.drawImage(image, 0, 0, image.width, image.height, x, y, w2, h2)
    else
      @context.drawImage(image, 0, 0, image.width, image.height, 0, 0, @contentWidth, @contentHeight)

  updateImageFit: (imageOrImageSrc, keepRatio = false) ->
    @clear()
    @drawImageFit(imageOrImageSrc, keepRatio)
