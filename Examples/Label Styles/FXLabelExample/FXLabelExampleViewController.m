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
@synthesize label3;
@synthesize label4;
@synthesize label5;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //demonstrate shadow
    label1.shadowColor = nil;
    label1.shadowOffset = CGSizeMake(0.0f, 2.0f);
    label1.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.75f];
    label1.shadowBlur = 5.0f;
    
    //demonstrate inner shadow
    label2.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.8f];
    label2.shadowOffset = CGSizeMake(1.0f, 1.0f);
    label2.shadowBlur = 1.0f;
    label2.innerShadowBlur = 2.0f;
    label2.innerShadowColor = [UIColor colorWithWhite:0.0f alpha:0.8f];
    label2.innerShadowOffset = CGSizeMake(1.0f, 1.0f);
    
    //demonstrate gradient fill
    label3.gradientStartColor = [UIColor redColor];
    label3.gradientEndColor = [UIColor blackColor];

    //demonstrate multi-part gradient
    label4.gradientStartPoint = CGPointMake(0.0f, 0.0f);
    label4.gradientEndPoint = CGPointMake(1.0f, 1.0f);
    label4.gradientColors = @[[UIColor redColor],
                             [UIColor yellowColor],
                             [UIColor greenColor],
                             [UIColor cyanColor],
                             [UIColor blueColor],
                             [UIColor purpleColor],
                             [UIColor redColor]];
    
    //everything
    label5.shadowColor = [UIColor blackColor];
    label5.shadowOffset = CGSizeZero;
    label5.shadowBlur = 20.0f;
    label5.innerShadowBlur = 2.0f;
    label5.innerShadowColor = [UIColor yellowColor];
    label5.innerShadowOffset = CGSizeMake(1.0f, 1.0f);
    label5.gradientStartColor = [UIColor redColor];
    label5.gradientEndColor = [UIColor yellowColor];
    label5.gradientStartPoint = CGPointMake(0.0f, 0.5f);
    label5.gradientEndPoint = CGPointMake(1.0f, 0.5f);
    label5.oversampling = 2;
}

- (void)viewDidUnload
{
    self.label1 = nil;
    self.label2 = nil;
    self.label3 = nil;
    self.label4 = nil;
    self.label5 = nil;
    [super viewDidUnload];
}


@end
