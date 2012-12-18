Purpose
--------------

The standard iOS UILabel is fairly limited in terms of visual customisation; You can set the font, colour and a hard-edged shadow, and that's about it.

FXLabel improves upon the standard UILabel by providing a subclass that supports soft shadows, inner shadow and gradient fill, and which can easily be used in place of any standard UILabel.


Supported iOS & SDK Versions
-----------------------------

* Supported build target - iOS 6.0 (Xcode 4.5, Apple LLVM compiler 4.1)
* Earliest supported deployment target - iOS 5.0
* Earliest compatible deployment target - iOS 4.3

NOTE: 'Supported' means that the library has been tested with this version. 'Compatible' means that the library should work on this iOS version (i.e. it doesn't rely on any unavailable SDK features) but is no longer being tested for compatibility and may require tweaking or bug fixes to run correctly.


ARC Compatibility
------------------

As of version 1.4, FXLabel requires ARC. If you wish to use FXLabel in a non-ARC project, just add the -fobjc-arc compiler flag to the FXLabel.m class. To do this, go to the Build Phases tab in your target settings, open the Compile Sources group, double-click FXLabel.m in the list and type -fobjc-arc into the popover.

If you wish to convert your whole project to ARC, comment out the #error line in FXLabel.m, then run the Edit > Refactor > Convert to Objective-C ARC... tool in Xcode and make sure all files that you wish to use ARC for (including FXLabel.m) are checked.


Installation
---------------

To use FXLabel, just drag the class files into your project. You can create FXLabels programatically, or create them in Interface Builder by dragging an ordinary UILabel into your view and setting its class to FXLabel.

If you are using Interface Builder, to set the custom properties of FXLabel (ones that are not supported by regular UILabels) either create an IBOutlet for your label and set the properties in code, or use the User Defined Runtime Attributes feature in Interface Builder (introduced in Xcode 4.2 for iOS 5+).


NSString extensions
--------------------

FXLabel extends NSString with the following methods:

    - (CGSize)sizeWithFont:(UIFont *)font
         constrainedToSize:(CGSize)size
             lineBreakMode:(NSLineBreakMode)lineBreakMode
               lineSpacing:(CGFloat)lineSpacing
              allowOrphans:(BOOL)allowOrphans;
              
This method calculates the size of a rendered string when using FXLabel lineSpacing and allowOrphans properties. 
    
    - (CGSize)drawInRect:(CGRect)rect
                withFont:(UIFont *)font
           lineBreakMode:(NSLineBreakMode)lineBreakMode
               alignment:(NSTextAlignment)alignment
             lineSpacing:(CGFloat)lineSpacing
            allowOrphans:(BOOL)allowOrphans;

This method renders a string using the FXLabel lineSpacing and allowOrphans properties.


FXLabel properties
----------------

	@property (nonatomic) CGFloat shadowBlur;
	
The softness of the text shadow. Defaults to zero, which creates a hard shadow, identical to the standard UILabel shadow. Note that the shadow's other properties such as shadowOffset and shadowColor are inherited from UILabel and can be found in the standard Apple docs.
	
	@property (nonatomic) CGSize innerShadowOffset;
	
The offset for the inner shadow. Works the same way as shadowOffset. Currently only hard-edged inner shadows are supported.
	
	@property (nonatomic) UIColor *innerShadowColor;
	
The colour of the inner shadow.

	@property (nonatomic, copy) NSArray *gradientColors;
	
An array of colors used to produce a gradient effect across the text. The minimum number of gradient colours you can specify is two - if the array contains fewer than two colours it will be ignored. If the alpha component of any of the colours is less than 1.0, it will be blended with the textColor. Patterned, indexed or HSV colours are not supported. The direction of the gradient is controlled by the gradientStartPoint and gradientEndPoint properties. The default direction is vertical.
	
	@property (nonatomic) UIColor *gradientStartColor;
	
The starting/upper color of the gradient. This property is just a convenience accessor for the first element in the gradientColors array.
	
	@property (nonatomic) UIColor *gradientEndColor;
	
The ending/lower color of the gradient. This property is just a convenience accessor for the last element in the gradientColors array.

	@property (nonatomic) CGPoint gradientStartPoint;
	
The starting position of the gradient. The x and y coordinates are in the range 0 to 1, where (0, 0) is the top-left of the text and (1, 1) is the bottom-right. This means that use can use the same settings for multiple strings and the gradient will scale to fit. The default value is (0.5, 0.0), i.e. the top, center.

	@property (nonatomic) CGPoint gradientEndPoint;
	
The ending position of the gradient. The x and y coordinates are in the range 0 to 1, where (0, 0) is the top-left of the text and (1, 1) is the bottom-right. This means that use can use the same settings for multiple strings and the gradient will scale to fit. The default value is (0.5, 0.75), which is the center of the baseline for most strings. For string with a lot of descenders (characters that hang below the baseline), you may find that a value of (0.5, 1.0) looks better.

	@property (nonatomic) NSUInteger oversampling;
	
You may find that for some combinations of effects, the quality of the text edges is poor, particularly on non-Retina devices. In these cases, you can make use of the oversampling property, which will cause the text to be drawn at higher resolution and then downscaled to improve the quality of the drawing, at a slight cost to performance. The default (and minimum) value of the oversampling property matches the [UIScreen mainScreen].scale value. For best results, set oversampling to a power of two, i.e. 1, 2, 4, 8, 16, etc. For performance reasons, you should use the lowest value that yields acceptable results. Note that this property relies on iOS 4 features and has no effect on iOS 3.x.

	@property (nonatomic) UIEdgeInsets textInsets;

FXLabel effects cannot be drawn outside of the bounds of the label view. For labels that are not centre aligned, you may need to make use of the textInsets property to inset the text from the edge of the view so that text effects such as shadows are not cropped.

    @property (nonatomic) CGFloat lineSpacing;
    
The lineSpacing property allows you to control the amount of space between lines in the label. The value is specified in points and defaults to zero.
    
    @property (nonatomic) BOOL allowOrphans;
    
The allowOrphans property allows you to prevent a common layout issue where a word ends up on its own on the last line of a paragraph. By default, allowOrphans is set to YES, but if you set it to NO, FXLabel will automatically ensure that a minimum of two words will appear on the last line of each paragraph.

	
Notes
----------------

FXLabels have a nice additional layout feature, which is that (unlike UILabels) they respect the contentMode property with regard to vertical layout. Setting the contentMode to top, center or bottom will vertically align the text to the top, center or bottom of the view respectively. Note however that for horizontal alignment, the FXLabel ignores contentMode in favour of the textAlignment property.

FXLabels are slower to draw than UILabels, so be wary of overusing them, especially for text that needs to be resized or animated.

FXLabel effects cannot be drawn outside of the bounds of the label view. For labels with shadowBlur or shadowOffset values, you will need to increase the size of the label frame to prevent the shadow being cropped. If your text is not centre aligned, you will also need to make use of the textInsets property to inset the text from the edge of the view so the text effects are not cropped.

The gradientColor properties do not support patterned, indexed or HSV colours.