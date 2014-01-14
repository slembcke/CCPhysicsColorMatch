/*
 * CCPhysics Color Match Example
 *
 * Copyright (c) 2013 Scott Lembcke
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "cocos2d.h"
#import "ObjectAL.h"

#import "ColorMatchScene.h"
#import "Ball.h"


// I like to put my Z-orders in an enumeration so they are easy to rearrange.
enum Z_ORDER {
	Z_BACKGROUND,
	Z_BALLS,
	Z_PARTICLES,
	Z_FOREGROUND,
};


@implementation ColorMatchScene
{
	// Scenery sprites.
	CCSprite *_foreground, *_background;
	
	// Node that simulates the physics.
	CCPhysicsNode *_physics;
	
	// The boundaries of the "bin" that the balls are trapped inside of.
	CGRect _binRect;
	
	// List of balls in the game.
	NSMutableArray *_balls;
	
	// Number of elapsed fixed timesteps.
	NSUInteger _ticks;
	
	// Cache the particles definition.
	NSDictionary *_popParticles;
}

-(id)init
{
	if((self = [super init])){
		// We'll do a minimal amount of initialization here. See onEnter for the rest.
		_balls = [NSMutableArray array];
	}
	
	return self;
}

-(void)onEnter
{
	[super onEnter];
	
	// It's a good practice to do as much initialization work as you can in the -onEnter method instead of -init.
	// This means that you won't have two full scenes in memory at the same time when changing scenes and Cocos2D can manage memory better.
	
	// Load the background sprite that goes behind the balls.
	_background = [CCSprite spriteWithImageNamed:@"Background.png"];
	_background.anchorPoint = ccp(0, 0);
	[self addChild:_background z:Z_BACKGROUND];
	
	// Load the foregrund sprite that goes over the balls.
	_foreground = [CCSprite spriteWithImageNamed:@"Foreground.png"];
	_foreground.anchorPoint = ccp(0, 0);
	[self addChild:_foreground z:Z_FOREGROUND];
	
	// Create the physics node to simulate the physics in.
	_physics = [CCPhysicsNode node];
	_physics.gravity = ccp(0, -250);
	[self addChild:_physics z:Z_BALLS];
	
	// You can enable debug drawing if you want CCPhysics to highlight collision shapes for you.
//	_physics.debugDraw = YES;
	
	// Use the scene itself as the delegate for collision events.
	// See the collision methods below.
	_physics.collisionDelegate = self;
	
	// Make a node to attach the physics body for the "bin" the balls fall into.
	CCNode *bin = [CCNode node];
	// Make a body with a hollow rectangular shape.
	// Polyline based bodies defualt to being "static" which means that they don't move.
	_binRect = CGRectMake(68, 34, 430, 500);
	bin.physicsBody = [CCPhysicsBody bodyWithPolylineFromRect:_binRect cornerRadius:0];
	
	// To make the bin's collision shapes active, just add it as a child to the CCPhysicsNode.
	[_physics addChild:bin];
	
	// Cache the particle effect to avoid stuttering.
	NSString *path = [[CCFileUtils sharedFileUtils] fullPathFromRelativePath:@"pop.plist"];
	_popParticles = [NSDictionary dictionaryWithContentsOfFile:path];
}

// This method should look suspiciously similar to addBall:
-(void)removeBall:(Ball *)ball
{
	[_physics removeChild:ball];
	[_balls removeObject:ball];
	
	// Draw the confetti particles whenever a ball is removed.
	CCParticleSystem *particles = [[CCParticleSystem alloc] initWithDictionary:_popParticles];
	particles.position = ball.position;
	particles.autoRemoveOnFinish = TRUE;
	[self addChild:particles z:Z_PARTICLES];
}

//MARK: Collision Delegate Methods

// This method is called each fixedUpdate: for any two CCPhysicsBodies that both have a collision type of @"red".
// The names of the last two parameters decide what collision types it works on, which in this case are both red.
-(BOOL)ccPhysicsCollisionPreSolve:(CCPhysicsCollisionPair *)pair red:(Ball *)ballA red:(Ball *)ballB
{
	[self markPair:ballA and:ballB];
	
	// By returning NO, you can tell CCPhysics to ignore the collision for this fixed timestep.
	return YES;
}

// This one works only when orange balls collide.
-(BOOL)ccPhysicsCollisionPreSolve:(CCPhysicsCollisionPair *)pair orange:(Ball *)ballA orange:(Ball *)ballB
{
	[self markPair:ballA and:ballB];
	return YES;
}

// Yellow balls... you get the idea.
-(BOOL)ccPhysicsCollisionPreSolve:(CCPhysicsCollisionPair *)pair yellow:(Ball *)ballA yellow:(Ball *)ballB
{
	[self markPair:ballA and:ballB];
	return YES;
}

// The two types don't need to match of course.
// It could be green/blue or monster/bullet.
-(BOOL)ccPhysicsCollisionPreSolve:(CCPhysicsCollisionPair *)pair green:(Ball *)ballA green:(Ball *)ballB
{
	[self markPair:ballA and:ballB];
	return YES;
}

-(BOOL)ccPhysicsCollisionPreSolve:(CCPhysicsCollisionPair *)pair blue:(Ball *)ballA blue:(Ball *)ballB
{
	[self markPair:ballA and:ballB];
	return YES;
}

-(BOOL)ccPhysicsCollisionPreSolve:(CCPhysicsCollisionPair *)pair violet:(Ball *)ballA violet:(Ball *)ballB
{
	[self markPair:ballA and:ballB];
	return YES;
}

// This is the method that is called from all of the collision delegate methods above.
// So it's called each fixedUpdate: for each pair of colliding balls that are the same color.
// Once all of the pairs have been marked with this method, you'll be able to find out what group the balls are in.
// See the fixedUpdate: method for more information.
-(void)markPair:(Ball *)ballA and:(Ball *)ballB
{
	// This is half of the implementation of the disjoint set forest algorithm.
	// The other half is in the Ball.component* properties.
	// I won't further explain the algorithm here, but it's one of my favorites.
	// I use it within Chipmunk to find groups of sleeping objects.
	// You can find more information here: http://en.wikipedia.org/wiki/Disjoint_set_forest#Disjoint-set_forests
	
	Ball *rootA = ballA.componentRoot;
	Ball *rootB = ballB.componentRoot;
	
	if(rootA != rootB){
		// Merge the two component trees.
		rootA.componentRoot = rootB.componentRoot;
		rootA.componentCount = rootB.componentCount = rootA.componentCount + rootB.componentCount;
	}
}


//MARK: Game Loop Methods.

// Put stuff here that you want Cocos2D to call once per frame.
// Sometimes frames take different amounts of time to process.
// Ex: updating sprites, animating things for rendering, etc.
-(void)update:(CCTime)delta
{
	// Don't actually have anything to put here... It's just here as an example.
}

// Put stuff here like that you want Cocos2D to call at a consistent rate.
// Ex: Game logic, physics code, etc.
// The physics engine updates itself after all other fixedUpdate: methods are calle.d
-(void)fixedUpdate:(CCTime)delta
{
	// First, let's check for groups of 4 or more like colored balls.
	// Technically we are checking the results from the last fixed timestep, but that's okay.
	// In future versions of Cocos2D there might be an event that is called after physics is simulated.
	
	// Look for balls in components with 4 or more balls and remove them.
	// Note that I'm iterating a copy of the _balls array.
	// You can't remove objects from an array while iterating it.
	for(Ball *ball in [_balls copy]){
		// Get the component's root and check the count.
		Ball *root = ball.componentRoot;
		if(root.componentCount >= 4){
			[self removeBall:ball];
			
			// Play a pop noise with a little random pitch bending.
			int half_steps = (arc4random()%(2*4 + 1) - 4);
			float pitch = pow(2.0f, half_steps/12.0f);
			[[OALSimpleAudio sharedInstance] playEffect:@"ploop.wav" volume:1.0 pitch:pitch pan:0 loop:NO];
		}
	}
	
	// Add a ball every 6 ticks if the playfield doesn't have enough balls in it.
	if(_ticks%6 == 0 && _balls.count < 100){
		Ball *ball = [Ball node];
		
		// Give the ball a random starting position.
		float xmin = CGRectGetMinX(_binRect);
		float xmax = CGRectGetMaxY(_binRect);
		float rand = 0.8*CCRANDOM_MINUS1_1();
		ball.position = ccp((xmin + xmax)/2.0 - (xmin - xmax)/2.0*rand, 400.0);
		ball.physicsBody.velocity = ccp(100.0*CCRANDOM_MINUS1_1(), 0);
		ball.physicsBody.angularVelocity = 5.0*CCRANDOM_MINUS1_1();
		
		[_balls addObject:ball];
		[_physics addChild:ball];
	}
	
	// Reset the component properties so they are ready to be used again when the collision delegate methods are called.
	for(Ball *ball in _balls){
		ball.componentCount = 1;
		ball.componentRoot = ball;
	}
	
	_ticks++;
}

@end
