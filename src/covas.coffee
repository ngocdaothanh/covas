jsg.load("scripts/covas/lib/tweenjs-r6.min.js")

jsg.load('scripts/covas/stage.coffee')
jsg.load('scripts/covas/node.coffee')
jsg.load('scripts/covas/scene.coffee')

jsg.load('scripts/covas/image_view.coffee')
jsg.load('scripts/covas/sprite.coffee')

jsg.load('scripts/covas/image_button.coffee')
jsg.load('scripts/covas/label.coffee')
jsg.load('scripts/covas/button.coffee')
jsg.load('scripts/covas/scroll_view.coffee')

jsg.load('scripts/covas/node_touch.coffee')
jsg.load('scripts/covas/anim.coffee')

jsg.ready((width, height) ->
  jsg.stage = new Stage(width, height)
  jsg.tick(jsg.stage.onTick)
)
