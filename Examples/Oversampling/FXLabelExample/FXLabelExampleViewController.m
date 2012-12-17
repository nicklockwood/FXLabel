//
//  FXLabelExampleViewController.m
//  FXLabelExample
//
//  Created by Nick Lockwood on 20/08/2011.
//  Copyright 2011 Charcoal Design. All rights reserved.
//

#import "FXLabelExampleViewController.h"

@implementation FXLabelExampleViewController

@synthesize label;
@synthesize oversamplingLabel;
@synthesize oversamplingSlider;
@synthesize fontSizeLabel;
@synthesize fontSizeSlider;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //no oversampling
    label.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.2f];
    label.shadowOffset = CGSizeMake(0.5f, 1.0f);
    label.innerShadowColor = [UIColor blackColor];
    label.innerShadowOffset = CGSizeMake(0.5f, 1.0f);
    label.oversampling = 1;
    
    //set minimum
    oversamplingSlider.minimumValue = label.oversampling;
    
    //update labels
    [self setOversampling:oversamplingSlider];
    [self setFontSize:fontSizeSlider];
}

- (IBAction)setOversampling:(UISlider *)slider
{
    slider.value = roundf(slider.value);
    label.oversampling = slider.value;
    
    NSString *sampling = [NSString stringWithFormat:@"%ix", (int)slider.value];
    oversamplingLabel.text = [NSString stringWithFormat:@"Oversampling (%@)", (slider.value > slider.minimumValue)? sampling: @"none"];
}

- (IBAction)setFontSize:(UISlider *)slider
{
    slider.value = roundf(slider.value);
    label.font = [label.font fontWithSize:slider.value];
    
    fontSizeLabel.text = [NSString stringWithFormat:@"Font size (%i)", (int)label.font.pointSize];
}

- (void)viewDidUnload
{
    self.label = nil;
    self.oversamplingLabel = nil;
    self.oversamplingSlider = nil;
    self.fontSizeLabel = nil;
    self.fontSizeSlider = nil;
    [super viewDidUnload];
}


@end
