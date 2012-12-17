//
//  ViewController.h
//  FXLabelTest
//
//  Created by Nick Lockwood on 02/12/2011.
//  Copyright (c) 2011 Charcoal Design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXLabel.h"

@interface ViewController : UIViewController

@property (nonatomic, strong) IBOutlet FXLabel *label;

- (IBAction)toggleHighlight;

@end
