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
    self.label1.shadowColor = nil;
    self.label1.shadowOffset = CGSizeMake(0.0f, 2.0f);
    self.label1.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.75f];
    self.label1.shadowBlur = 5.0f;

    //demonstrate inner shadow
    self.label2.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.8f];
    self.label2.shadowOffset = CGSizeMake(1.0f, 1.0f);
    self.label2.shadowBlur = 1.0f;
    self.label2.innerShadowBlur = 2.0f;
    self.label2.innerShadowColor = [UIColor colorWithWhite:0.0f alpha:0.8f];
    self.label2.innerShadowOffset = CGSizeMake(1.0f, 1.0f);
    
    //demonstrate gradient fill
    self.label3.gradientStartColor = [UIColor redColor];
    self.label3.gradientEndColor = [UIColor blackColor];

    //demonstrate multi-part gradient
    self.label4.gradientStartPoint = CGPointMake(0.0f, 0.0f);
    self.label4.gradientEndPoint = CGPointMake(1.0f, 1.0f);
    self.label4.gradientColors = @[[UIColor redColor],
                                   [UIColor yellowColor],
                                   [UIColor greenColor],
                                   [UIColor cyanColor],
                                   [UIColor blueColor],
                                   [UIColor purpleColor],
                                   [UIColor redColor]];
    
    //everything
    self.label5.shadowColor = [UIColor blackColor];
    self.label5.shadowOffset = CGSizeZero;
    self.label5.shadowBlur = 20.0f;
    self.label5.innerShadowBlur = 2.0f;
    self.label5.innerShadowColor = [UIColor yellowColor];
    self.label5.innerShadowOffset = CGSizeMake(1.0f, 1.0f);
    self.label5.gradientStartColor = [UIColor redColor];
    self.label5.gradientEndColor = [UIColor yellowColor];
    self.label5.gradientStartPoint = CGPointMake(0.0f, 0.5f);
    self.label5.gradientEndPoint = CGPointMake(1.0f, 0.5f);
    self.label5.oversampling = 2;
}

@end
