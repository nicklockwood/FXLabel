//
//  ViewController.m
//  FXLabelTest
//
//  Created by Nick Lockwood on 02/12/2011.
//  Copyright (c) 2011 Charcoal Design. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

@synthesize label;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    label.gradientStartColor = [UIColor redColor];
    label.gradientEndColor = [UIColor clearColor];
}

- (IBAction)toggleHighlight
{
    label.highlighted = !label.highlighted;
}

- (void)viewDidUnload
{
    self.label = nil;
    [super viewDidUnload];
}



@end
