//
//  FXLabelExampleViewController.m
//  FXLabelExample
//
//  Created by Nick Lockwood on 20/08/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FXLabelExampleViewController.h"

@implementation FXLabelExampleViewController

@synthesize label1;
@synthesize label2;
@synthesize label3;
@synthesize label4;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //demonstrate shadow
    label1.shadowOffset = CGSizeMake(0.0f, 2.0f);
    label1.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.75f];
    label1.shadowBlur = 5.0f;
    
    //demonstrate inner shadow
    label2.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.8f];
    label2.shadowOffset = CGSizeMake(1.0f, 2.0f);
    label2.shadowBlur = 1.0f;
    label2.innerShadowColor = [UIColor colorWithWhite:0.0f alpha:0.8f];
    label2.innerShadowOffset = CGSizeMake(1.0f, 2.0f);
    
    //demonstrate gradient fill
    label3.gradientStartColor = [UIColor redColor];
    label3.gradientEndColor = [UIColor blueColor];
    
    
    //everything
    label4.shadowColor = [UIColor blackColor];
    label4.shadowBlur = 10.0f;
    label4.innerShadowColor = [UIColor yellowColor];
    label4.innerShadowOffset = CGSizeMake(1.0f, 2.0f);
    label4.gradientStartColor = [UIColor redColor];
    label4.gradientEndColor = [UIColor yellowColor];
}

- (void)viewDidUnload
{
    self.label1 = nil;
    self.label2 = nil;
    self.label3 = nil;
    self.label4 = nil;
    [super viewDidUnload];
}

- (void)dealloc
{
    [label1 release];
    [label2 release];
    [label3 release];
    [label4 release];
    [super dealloc];
}

@end
