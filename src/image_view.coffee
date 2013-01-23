# The image source can be set at the constructor or later at "setSrc":
#
# s1 = new ImageView('image.png')
#
# s2 = new ImageView
# s2.setSrc('image.png')
class ImageView extends Node
  constructor: (@src) ->
    super()  # @contentWidth and @contentHeight are set to 0 here
    @setSrc(@src)

  setSrc: (@src) ->
    if @src?
      @content = @image = jsg.loadImage(@src)
      @contentWidth  = @image.width
      @contentHeight = @image.height
    else if @content?
      @content = @image = null
      @contentWidth = @contentHeight = 0
