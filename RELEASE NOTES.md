Version 1.3.1

- Added automatic support for ARC compile targets
- Now requires Apple LLVM 3.0 compiler target

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