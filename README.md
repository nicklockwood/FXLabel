Purpose
--------------

The standard iOS UILabel is fairly limited in terms of visual customisation; You can set the font, colour and a hard-edged shadow, and that's about it.

FXLabel improves upon the standard UILabel by providing a subclass that supports soft shadows, inner shadow and gradient fill, and which can easily be used in place of any standard UILabel.


Installation
---------------

To use FXLabel, just drag the class files into your project. You can create FXLabels programatically, or create them in Interface Builder by dragging an ordinary UILabel into your view and setting its class to FXLabel.


FXLabel properties
----------------

	@property (nonatomic, assign) CGFloat shadowBlur;
	
The softness of the text shadow. Defaults to zero, which creates a hard shadow, identical to the standard UILabel shadow. Note that the shadow's other properties such as shadowOffset and shadowColor are inherited from UILabel and can be found in the standard Apple docs.
	
	@property (nonatomic, assign) CGSize innerShadowOffset;
	
The offset for the inner shadow. Works the same way as shadowOffset. Currently only hard-edged inner shadows are supported.
	
	@property (nonatomic, retain) UIColor *innerShadowColor;
	
The colour of the inner shadow.
	
	@property (nonatomic, retain) UIColor *gradientStartColor;
	
The starting/upper colour of the gradient. If the alpha component is less than 1.0, this will be blended with the textColor. See the note about gradient colours below.
	
	@property (nonatomic, retain) UIColor *gradientEndColor;
	
The ending/lower colour of the gradient. If the alpha componentis less than 1.0, this will be blended with the textColor. See the note about gradient colours below.

	@property (nonatomic, assign) CGPoint gradientStartPoint;
	
The starting position of the gradient. The x and y coordinates are in the range 0 to 1, where (0, 0) is the top-left of the text and (1, 1) is the bottom-right. This means that use can use the same settings for multiple strings and the gradient will scale to fit. The default value is (0.5, 0.0), i.e. the top, center.

	@property (nonatomic, assign) CGPoint gradientEndPoint;
	
The ending position of the gradient. The x and y coordinates are in the range 0 to 1, where (0, 0) is the top-left of the text and (1, 1) is the bottom-right. This means that use can use the same settings for multiple strings and the gradient will scale to fit. The default value is (0.5, 0.75), which is the center of the baseline for most strings. For string with a lot of descenders (characters that hang below the baseline), you may find that a value of (0.5, 1.0) looks better.

	
Notes
----------------

FXLabels have a nice additional layout feature, which is that (unlike UILabels) they respect the contentMode property with regard to vertical layout. Setting the contentMode to top, centre or bottom will vertically align the text to the top, centre or bottom of the view respectively. Note however that for horizontal alignment, the FXLabel ignores contentMode in favour of the textAlignment property.

FXLabels are slower to draw than UILabels, so be wary of overusing them, especially for text that needs to be resized or animated.

FXLabel effects cannot be drawn outside of the bounds of the label view. For labels with large shadowBlur or shadowOffset values, you will need to increase the size of the label frame to prevent the shadow being cropped.

The gradientStartColor and gradientEndColor properties do not support patterned, indexed or HSV colours.