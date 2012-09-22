Purpose
--------------

The standard iOS UILabel is fairly limited in terms of visual customisation; You can set the font, colour and a hard-edged shadow, and that's about it.

FXLabel improves upon the standard UILabel by providing a subclass that supports soft shadows, inner shadow and gradient fill, and which can easily be used in place of any standard UILabel.


Supported iOS & SDK Versions
-----------------------------

* Supported build target - iOS 6.0 / Mac OS 10.7 (Xcode 4.5, Apple LLVM compiler 4.1)
* Earliest supported deployment target - iOS 5.0 / Mac OS 10.6
* Earliest compatible deployment target - iOS 3.0

NOTE: 'Supported' means that the library has been tested with this version. 'Compatible' means that the library should work on this iOS version (i.e. it doesn't rely on any unavailable SDK features) but is no longer being tested for compatibility and may require tweaking or bug fixes to run correctly.


ARC Compatibility
------------------

FXLabel makes use of the ARC Helper library to automatically work with both ARC and non-ARC projects through conditional compilation. There is no need to exclude FXLabel files from the ARC validation process, or to convert FXLabel using the ARC conversion tool.


Installation
---------------

To use FXLabel, just drag the class files into your project. You can create FXLabels programatically, or create them in Interface Builder by dragging an ordinary UILabel into your view and setting its class to FXLabel.


FXLabel properties
----------------

	@property (nonatomic, assign) CGFloat shadowBlur;
	
The softness of the text shadow. Defaults to zero, which creates a hard shadow, identical to the standard UILabel shadow. Note that the shadow's other properties such as shadowOffset and shadowColor are inherited from UILabel and can be found in the standard Apple docs.
	
	@property (nonatomic, assign) CGSize innerShadowOffset;
	
The offset for the inner shadow. Works the same way as shadowOffset. Currently only hard-edged inner shadows are supported.
	
	@property (nonatomic, strong) UIColor *innerShadowColor;
	
The colour of the inner shadow.

	@property (nonatomic, copy) NSArray *gradientColors;
	
An array of colors used to produce a gradient effect across the text. The minimum number of gradient colours you can specify is two - if the array contains fewer than two colours it will be ignored. If the alpha component of any of the colours is less than 1.0, it will be blended with the textColor. Patterned, indexed or HSV colours are not supported. The direction of the gradient is controlled by the gradientStartPoint and gradientEndPoint properties. The default direction is vertical.
	
	@property (nonatomic, strong) UIColor *gradientStartColor;
	
The starting/upper color of the gradient. This property is just a convenience accessor for the first element in the gradientColors array.
	
	@property (nonatomic, strong) UIColor *gradientEndColor;
	
The ending/lower color of the gradient. This property is just a convenience accessor for the last element in the gradientColors array.

	@property (nonatomic, assign) CGPoint gradientStartPoint;
	
The starting position of the gradient. The x and y coordinates are in the range 0 to 1, where (0, 0) is the top-left of the text and (1, 1) is the bottom-right. This means that use can use the same settings for multiple strings and the gradient will scale to fit. The default value is (0.5, 0.0), i.e. the top, center.

	@property (nonatomic, assign) CGPoint gradientEndPoint;
	
The ending position of the gradient. The x and y coordinates are in the range 0 to 1, where (0, 0) is the top-left of the text and (1, 1) is the bottom-right. This means that use can use the same settings for multiple strings and the gradient will scale to fit. The default value is (0.5, 0.75), which is the center of the baseline for most strings. For string with a lot of descenders (characters that hang below the baseline), you may find that a value of (0.5, 1.0) looks better.

	@property (nonatomic, assign) NSUInteger oversampling;
	
You may find that for some combinations of effects, the quality of the text edges is poor, particularly on non-Retina devices. In these cases, you can make use of the oversampling property, which will cause the text to be drawn at higher resolution and then downscaled to improve the quality of the drawing, at a slight cost to performance. The default (and minimum) value of the oversampling property matches the [UIScreen mainScreen].scale value. For best results, set oversampling to a power of two, i.e. 1, 2, 4, 8, 16, etc. For performance reasons, you should use the lowest value that yields acceptable results. Note that this property relies on iOS 4 features and has no effect on iOS 3.x.

	@property (nonatomic, assign) UIEdgeInsets textInsets;

FXLabel effects cannot be drawn outside of the bounds of the label view. For labels that are not centre aligned, you may need to make use of the textInsets property to inset the text from the edge of the view so that text effects such as shadows are not cropped.

	
Notes
----------------

FXLabels have a nice additional layout feature, which is that (unlike UILabels) they respect the contentMode property with regard to vertical layout. Setting the contentMode to top, center or bottom will vertically align the text to the top, center or bottom of the view respectively. Note however that for horizontal alignment, the FXLabel ignores contentMode in favour of the textAlignment property.

FXLabels are slower to draw than UILabels, so be wary of overusing them, especially for text that needs to be resized or animated.

FXLabel effects cannot be drawn outside of the bounds of the label view. For labels with large shadowBlur or shadowOffset values, you will need to increase the size of the label frame to prevent the shadow being cropped. If your text is not centre aligned, you will also need to make use of the textInsets property to inset the text from the edge of the view so the text effect is not cropped.

The gradientColor properties do not support patterned, indexed or HSV colours.