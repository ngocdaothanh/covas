class ImageView extends Node
  # The image source can be set at the constructor or later at "setImage":
  #
  # s1 = new ImageView('image.png')
  #
  # s2 = new ImageView
  # s2.setImage('image.png')
  constructor: (@src) ->
    super()  # @contentWidth and @contentHeight are set to 0 here
    @setImage(@src) if @src?

  setImage: (@src) ->
    @content = @image = jsg.loadImage(@src)
    @contentWidth  = @image.width
    @contentHeight = @image.height
