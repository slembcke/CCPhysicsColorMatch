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

#import "Ball.h"
#import "ColorMatchScene.h"

@implementation Ball
{
	Ball *_componentParent;
}

-(id)init
{
	NSArray *colors = @[@"red", @"orange", @"yellow", @"green", @"blue", @"violet"];
	NSString *color = colors[arc4random()%colors.count];
	
	if((self = [super initWithImageNamed:[NSString stringWithFormat:@"Ball_%@.png", color]])){
		// Give the balls some variation in size.
		self.scale = 0.5 + 0.15*CCRANDOM_0_1();
		
		// Estimate the ball's radius using half of the sprite's width.
		CGFloat padding = 5;
		CGFloat radius = 0.5*(self.contentSize.width - padding);
		
		// First we need to create a physics body with a circle shape.
		CCPhysicsBody *body = [CCPhysicsBody bodyWithCircleOfRadius:radius andCenter:self.anchorPointInPoints];
		
		// Bodies default to a mass of 1.0. We want bigger balls to weight more.
		// Setting the density is an easy way to accomplish that.
		// Keep in mind that if you resize the object the mass is kept constant and the density will change.
		body.density = 1.0;
		
		// Give the body some friction. 0.7 is a good go-to number if you need a guess.
		// Values over 1.0 are ok too.
		body.friction = 0.7;
		
		// The collision type is a string that is used to figuer out which collision delegate method to call.
		// See ColorMatchScene.m for more information.
		body.collisionType = color;
		
		// Done with setup. Assign the physics body!
		self.physicsBody = body;
		
		// Lastly, we need to enable user interaction so we can click on the balls.
		self.userInteractionEnabled = YES;
	}
	
	return self;
}

+(Ball *)ball
{
	return [[Ball alloc] init];
}

//-(BOOL)hitTestWithWorldPos:(CGPoint)pos
//{
//	return 
//}

-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	ColorMatchScene *scene = (ColorMatchScene *)self.scene;
	[scene removeBall:self];
	
	int half_steps = (arc4random()%(2*4 + 1) - 4);
	float pitch = pow(2.0f, half_steps/12.0f);
	[[OALSimpleAudio sharedInstance] playEffect:@"pop.wav" volume:1.0 pitch:pitch pan:0 loop:NO];
}

//MARK: Graph Components

// The following two methods implement the other half of the disjoint set forest algorithm.
// See [ColorMatchScene markPairs:space:] for more information.

@dynamic componentRoot;

-(Ball *)componentRoot
{
	if(_componentParent != self){
		// Path compression.
		// Make the next lookup quicker by caching the parent's root.
		_componentParent = _componentParent.componentRoot;
	}
	
	return _componentParent;
}

-(void)setComponentRoot:(Ball *)componentRoot
{
	if(componentRoot == self){
		_componentParent = self;
	} else {
		_componentParent = componentRoot.componentRoot;
	}
}

@end
