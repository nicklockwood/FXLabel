//
//  FXLabelExampleAppDelegate.h
//  FXLabelExample
//
//  Created by Nick Lockwood on 20/08/2011.
//  Copyright 2011 Charcoal Design. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FXLabelExampleViewController;

@interface FXLabelExampleAppDelegate : NSObject <UIApplicationDelegate>

@property (strong, nonatomic) IBOutlet UIWindow *window;
@property (strong, nonatomic) IBOutlet FXLabelExampleViewController *viewController;

@end
