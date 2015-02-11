//
//  Comimix_IphoneAppDelegate.h
//  Comimix-Iphone
//
//  Created by Prabhjot on 07/01/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Comimix_IphoneViewController;

@interface Comimix_IphoneAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    Comimix_IphoneViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet Comimix_IphoneViewController *viewController;

@end

