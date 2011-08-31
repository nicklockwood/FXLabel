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