# By default "prescale" is called on the button.
# You may call "prescaleByX", "prescaleByY", or change "prescaleX" or "prescaleY"
# on the button if you want.
class ImageButton extends ImageView
  constructor: (@imgSrc, @imgOnSrc, @tapListener) ->
    super(@imgSrc)
    @prescale()

    @touch.down(@drawImageOn)

    @touch.up((localX, localY, x, y) =>
      @drawImage()
      @tapListener(localX, localY, x, y) if 0 <= localX && localX < @width && 0 <= localY && localY < @height
    )

  drawImage: ->
    @setImage(@imgSrc)

  drawImageOn: =>
    @setImage(@imgOnSrc)
