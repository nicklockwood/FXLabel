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

@property (nonatomic, retain) IBOutlet FXLabel *label;
@property (nonatomic, retain) IBOutlet UILabel *oversamplingLabel;
@property (nonatomic, retain) IBOutlet UISlider *oversamplingSlider;
@property (nonatomic, retain) IBOutlet UILabel *fontSizeLabel;
@property (nonatomic, retain) IBOutlet UISlider *fontSizeSlider;

- (IBAction)setOversampling:(UISlider *)slider;
- (IBAction)setFontSize:(UISlider *)slider;

@end
