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
    
    //without oversampling
    label1.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.2f];
    label1.shadowBlur = 1.0f;
    label1.shadowOffset = CGSizeMake(0.0f, 1.0f);
    label1.innerShadowColor = [UIColor blackColor];
    label1.innerShadowOffset = CGSizeMake(0.0f, 1.2f);
    label1.oversample = NO;
    
    //with oversampling
    label2.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.2f];
    label2.shadowBlur = 1.0f;
    label2.shadowOffset = CGSizeMake(0.0f, 1.0f);
    label2.innerShadowColor = [UIColor blackColor];
    label2.innerShadowOffset = CGSizeMake(0.0f, 1.2f);
    label2.oversample = YES;
}

- (void)viewDidUnload
{
    self.label1 = nil;
    self.label2 = nil;
    [super viewDidUnload];
}

- (void)dealloc
{
    [label1 release];
    [label2 release];
    [super dealloc];
}

@end
