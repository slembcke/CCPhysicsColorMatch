CCPhysicsColorMatch
===================

A simple Cocos2D v3 and CCPhysics based color matching game.

![screenshot](http://files.slembcke.net/upshot/upshot_fhJzJPmI.png)

This is a very bare bones project demostrating some of the CCPhysics basics. The game consists of only three classes. AppDelegate shows how to setup Cocos2D with some of the basic options. ColorMatchScene is the main scene class that contains the game logic and physics setup code. The last class, Ball, shows how to make a CCNode with physics properties and also how to accept custom touch input.

Object of the Game
-

The game itself is a stripped down version of our old [Crayon Ball](http://howlingmoonsoftware.com/crayonball.php) game.
The object of the game is to get four balls of the same color to touch. Tapping on a ball would remove it from the game and allow other balls to fall into it's place.

In the original game, a timer would be counting down to game over. Tapping on a ball would decrease the timer duration while making matches would add to the timer. This logic was removed in the example project to make it simpler. So you can't really "win" the example game. ;)
