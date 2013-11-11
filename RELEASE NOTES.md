Version 1.5.3

- Fixed line wrap issue when using character wrap
- Now compiles for iOS 7+ without deprecation warnings
- Now complies with -Wall and -WExtra warning levels

Version 1.5.2

- Fixed a bug in the autoshrink logic when creating labels programatically (as opposed to using a nib)

Version 1.5.1

- Fixed rounding error that caused layout for multiline labels to not work correctly

Version 1.5

- Added innerShadowBlur property
- Added characterSpacing property
- Added kerningTable property for per-character spacing
- Added baselineOffset property
- LineSpacing property is now relative to pointSize

Version 1.4.2

- Fixed crash when calling sizeToFit or sizeThatFits: methods
- Fixed crash when label height is less than the height of a single line
- Fixed bug with text alignment for multiline labels

Version 1.4.1

- Fixed a bug when deployment target < 6.0
- Made setUp method public to aid subclassing.

Version 1.4

- FXLabel now requires ARC (see README for details)
- It is now possible to control line spacing for multiline labels
- FXLabel can now automatically avoid orphans (a single word left alone on the last line of a label)
- Improved layout algorithm to more closely match UILabel behaviour for single-line labels
- sizeToFit method now takes textInsets into account

Version 1.3.7

- Moved ARCHelper macros out of .h file so they do not affect non-ARC code in other classes

Version 1.3.6

- Fixed bug with baseline alignment when text is autoshrunk
- Fixed bug when using textInset property that could result in text appearing squashed or stretched

Version 1.3.5

- Fixed deprecation warnings under iOS 6
- Updated ARC Helper to version 2.1

Version 1.3.4

- Updated ARC Helper to version 1.3
- Fixed warning under Apple LLVM compiler 4.0

Version 1.3.3

- Fixed ARC crash introduced in version 1.3.2

Version 1.3.2

- Fixed bug when using non RGB blending colors (e.g. [UIColor blackColor])
- Fixed issue where inner shadow is applied to the label frame when background color is not transparent

Version 1.3.1

- Added automatic support for ARC compile targets
- Now requires Apple LLVM compiler 3.0 target

Version 1.3

- Added new gradientColors array for specifying multi-part gradients
- Added new textInsets property to prevent effects being truncated
- Fixed bug where multi-line fields were truncated to a single line
- Highlighted color is now respected when highlighted property is set
- Replaced oversample property with oversampling property that allows the developer to specify the degree of oversampling required
- Added additional example projects

Version 1.2

- Added oversample property to improve drawing quality for some effects.
- Fixed issue where labels without any effects or shadow were not drawn.

Version 1.1

- Added gradientStartPoint and gradientEndPoint properties.
- Gradient colours now support monochromatic colours and colour constants (e.g. [UIColor whiteColor]).
- Eliminated spurious coloured halo around gradient fonts by pre-blending gradient colours with text colour prior to drawing.
- Shadow opacity is now more consistent for different font settings.
- Fixed drawing glitch for fonts without an inner shadow.
- Fixed some memory leaks.
- Slightly improved performance by reducing overdraw.

Version 1.0

- Initial release