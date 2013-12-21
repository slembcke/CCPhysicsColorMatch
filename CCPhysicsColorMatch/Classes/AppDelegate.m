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

#import "AppDelegate.h"
#import "ColorMatchScene.h"

// TODO
#import "CCDirector_Private.h"

@implementation AppDelegate

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// TODO
	CCFileUtils *sharedFileUtils = [CCFileUtils sharedFileUtils];

	sharedFileUtils.suffixesDict = [@{
		CCFileUtilsSuffixiPad: @"-ipad",
		CCFileUtilsSuffixiPadHD: @"-ipadhd",
		CCFileUtilsSuffixiPhone: @"",
		CCFileUtilsSuffixiPhoneHD: @"-hd",
		CCFileUtilsSuffixiPhone5: @"-iphone5",
		CCFileUtilsSuffixiPhone5HD: @"-iphone5hd",
		CCFileUtilsSuffixDefault: @"",
	} mutableCopy];

	sharedFileUtils.searchPath = @[
		[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Resources-shared"],
		[[NSBundle mainBundle] resourcePath],
	];
	
	sharedFileUtils.enableiPhoneResourcesOniPad = YES;
	sharedFileUtils.searchMode = CCFileUtilsSearchModeSuffix;
	[sharedFileUtils buildSearchResolutionsOrder];

	[self setupCocos2dWithOptions:@{
		// Use v3's new fixed size screen mode to make it easier to support multiple device scales and resolutions.
		// It sets up Cocos2D with a 568x384 point "design size".
		// On iPhone 4 you see the middle 480x320 of it and the rest is cropped.
		// On iPhone 5 you see the middle 568x320 of it.
		// On iPad you see the middle 512x384 of that. (It sets the iPad's content scale to 2 or 4 for retina)
		CCSetupScreenMode: CCScreenModeFixed,
		// Don't show the stats (fps, draw call count, etc) counter.
		CCSetupHideDebugStats: @YES,
		
		// Examples of other settings you can use. See the documentation for the full list.
//		CCSetupScreenOrientation: CCScreenOrientationPortrait,
//		CCSetupTabletScale2X: @YES,
	}];
	
	// TODO
	[CCDirector sharedDirector].scheduler.fixedTimeStep = 1.0/120.0;
	
	return YES;
}

-(CCScene *)startScene
{
	// Cocos2D needs to know what scene it should start with when your app starts.
	// Normally you would return a menu scene here, but we skipped that in the example.
	return [ColorMatchScene node];
}

@end