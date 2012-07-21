# Normally games should not use jsg.touch directly.
# Use Node#touch instead because it's easier and more effective.
#
# Events are not fired for a Node if its width or height is 0,
# it or its parent is not on stage, invisible, or inactive.
class NodeTouch
  constructor: (@node) ->
    @downListeners = []
    @upListeners   = []
    @moveListeners = []
    @tapListeners  = []

    # Lazy: for speed, register only when neccessary
    @downRegistered = false
    @upRegistered   = false
    @moveRegistered = false
    @tapRegistered  = false

    # Only fire up, move, tap if there was a down
    @downed = false

  down: (listener) ->
    @downListeners.push(listener)
    @registerDown()

  tap: (listener) ->
    @tapListeners.push(listener)
    @registerTap()

    @registerDown()
    @registerUp()

  move: (listener) ->
    @moveListeners.push(listener)
    @registerMove()

    @registerDown()
    @registerUp()

  up: (listener) ->
    @upListeners.push(listener)
    @registerUp()

    @registerDown()

  #-----------------------------------------------------------------------------

  registerDown: ->
    if !@downRegistered
      jsg.touch.down(@fireDown)
      @downRegistered = true
    this

  registerTap: ->
    if !@tapRegistered
      jsg.touch.tap(@fireTap)
      @tapRegistered = true
    this

  registerMove: ->
    if !@moveRegistered
      jsg.touch.move(@fireMove)
      @moveRegistered = true
    this

  registerUp: ->
    if !@upRegistered
      jsg.touch.up(@fireUp)
      @upRegistered = true
    this

  #-----------------------------------------------------------------------------

  fireDown: (x, y) =>
    return if !@node.accVisible || !@node.accActive || @node.contentWidth < 1 || @node.contentHeight < 1

    [x1, y1, x2, y2] = @node.boundingBox()
    if x1 <= x && x < x2 && y1 <= y && y < y2
      @downed = true
      localX = x - x1
      localY = y - y1
      for listener in @downListeners
        listener(localX, localY, x, y)
    null

  fireUp: (x, y) =>
    return if !@downed
    @downed = false

    [x1, y1, x2, y2] = @node.boundingBox()
    localX = x - x1
    localY = y - y1
    for listener in @upListeners
      listener(localX, localY, x, y)
    null

  fireMove: (x, y) =>
    return if !@downed

    [x1, y1, x2, y2] = @node.boundingBox()
    localX = x - x1
    localY = y - y1
    for listener in @moveListeners
      listener(localX, localY, x, y)
    null

  fireTap: (x, y) =>
    # "tap" is fired before "up"
    return if !@downed

    [x1, y1, x2, y2] = @node.boundingBox()
    localX = x - x1
    localY = y - y1
    for listener in @tapListeners
      listener(localX, localY, x, y)
    null
