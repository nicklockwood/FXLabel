//
//  FXLabelExampleViewController.h
//  FXLabelExample
//
//  Created by Nick Lockwood on 20/08/2011.
//  Copyright 2011 Charcoal Design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXLabel.h"


@interface FXLabelExampleViewController : UIViewController

@property (nonatomic, strong) IBOutlet FXLabel *label;
@property (nonatomic, strong) IBOutlet UILabel *oversamplingLabel;
@property (nonatomic, strong) IBOutlet UISlider *oversamplingSlider;
@property (nonatomic, strong) IBOutlet UILabel *fontSizeLabel;
@property (nonatomic, strong) IBOutlet UISlider *fontSizeSlider;

- (IBAction)setOversampling:(UISlider *)slider;
- (IBAction)setFontSize:(UISlider *)slider;

@end
