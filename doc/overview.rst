Overview
========

Logical structure of game objects
---------------------------------

::

  stage
    scene
      sprite
      node
        sprite
        sprite

* There's only one stage.
* On the stage there are many scenes, but only one can be active at a time.
* Scenes are stacked. They can be pushed in or popped out.
* In a scene there are many sprites.
* Sprites can be grouped into nodes.

Coodinates
----------

::

  0
  +--------------+--- x
  |              |
  |              |
  |              |
  |              |
  |              |
  |              |
  +--------------+
  |
  |
  y

Included libs
-------------

tween.js
https://github.com/sole/tween.js
