//
//  main.m
//  CCPhysicsColorMatch
//
//  Created by Scott Lembcke on 1/13/14.
//  Copyright Howling Moon Software 2014. All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int argc, char *argv[]) {
	@autoreleasepool {
#ifdef ANDROID
    [UIScreen mainScreen].currentMode = [UIScreenMode emulatedMode:UIScreenBestNativeMode];
#endif

		int retVal = UIApplicationMain(argc, argv, nil, @"AppDelegate");
		return retVal;
	}
}
