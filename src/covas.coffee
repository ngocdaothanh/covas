jsg.load("scripts/covas/lib/tweenjs-r6.min.js")

jsg.load('scripts/covas/stage.js')
jsg.load('scripts/covas/node.js')
jsg.load('scripts/covas/scene.js')

jsg.load('scripts/covas/image_view.js')
jsg.load('scripts/covas/sprite.js')

jsg.load('scripts/covas/image_button.js')
jsg.load('scripts/covas/label.js')
jsg.load('scripts/covas/button.js')
jsg.load('scripts/covas/scroll_view.js')

jsg.load('scripts/covas/node_touch.js')
jsg.load('scripts/covas/anim.js')

jsg.ready((width, height) ->
  jsg.stage = new Stage(width, height)
  jsg.tick(jsg.stage.onTick)
)
