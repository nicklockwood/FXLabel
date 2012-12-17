//
//  FXLabelExampleViewController.m
//  FXLabelExample
//
//  Created by Nick Lockwood on 20/08/2011.
//  Copyright 2011 Charcoal Design. All rights reserved.
//

#import "FXLabelExampleViewController.h"

@implementation FXLabelExampleViewController

@synthesize label1;
@synthesize label2;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //demonstrate shadow cropping
    label1.shadowColor = nil;
    label1.shadowColor = [UIColor blackColor];
    label1.shadowBlur = 10.0f;
    
    //demonstrate use of insets to prevent cropping
    label2.shadowColor = nil;
    label2.shadowColor = [UIColor blackColor];
    label2.shadowBlur = 10.0f;
    label2.textInsets = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
}

- (void)viewDidUnload
{
    self.label1 = nil;
    self.label2 = nil;
    [super viewDidUnload];
}


@end
