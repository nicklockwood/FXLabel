//
//  FXLabel.m
//
//  Version 1.3.7
//
//  Created by Nick Lockwood on 20/08/2011.
//  Copyright 2011 Charcoal Design
//
//  Distributed under the permissive zlib license
//  Get the latest version from here:
//
//  https://github.com/nicklockwood/FXLabel
//
//  This software is provided 'as-is', without any express or implied
//  warranty.  In no event will the authors be held liable for any damages
//  arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//  claim that you wrote the original software. If you use this software
//  in a product, an acknowledgment in the product documentation would be
//  appreciated but is not required.
//
//  2. Altered source versions must be plainly marked as such, and must not be
//  misrepresented as being the original software.
//
//  3. This notice may not be removed or altered from any source distribution.
//

//
//  ARC Helper
//
//  Version 2.1
//
//  Created by Nick Lockwood on 05/01/2012.
//  Copyright 2012 Charcoal Design
//
//  Distributed under the permissive zlib license
//  Get the latest version from here:
//
//  https://gist.github.com/1563325
//

#ifndef ah_retain
#if __has_feature(objc_arc)
#define ah_retain self
#define ah_dealloc self
#define release self
#define autorelease self
#else
#define ah_retain retain
#define ah_dealloc dealloc
#define __bridge
#endif
#endif

//  ARC Helper ends


#import "FXLabel.h"


@interface FXLabel ()

@property (nonatomic, assign) NSUInteger minSamples;
@property (nonatomic, assign) NSUInteger maxSamples;

@end


@implementation FXLabel

@synthesize shadowBlur; //avoid conflict with private property
@synthesize innerShadowOffset = _innerShadowOffset;
@synthesize innerShadowColor = _innerShadowColor;
@synthesize gradientColors = _gradientColors;
@synthesize gradientStartPoint = _gradientStartPoint;
@synthesize gradientEndPoint = _gradientEndPoint;
@synthesize oversampling =_oversampling;
@synthesize minSamples = _minSamples;
@synthesize maxSamples = _maxSamples;
@synthesize textInsets = _textInsets;

- (void)setDefaults
{
    _gradientStartPoint = CGPointMake(0.5f, 0.0f);
    _gradientEndPoint = CGPointMake(0.5f, 0.75f);
    _minSamples = _maxSamples = 1;
    if ([UIScreen instancesRespondToSelector:@selector(scale)])
    {
        _minSamples = [UIScreen mainScreen].scale;
        _maxSamples = 32;
    }
    _oversampling = _minSamples;
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        self.backgroundColor = nil;
        [self setDefaults];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self setDefaults];
    }
    return self;
}

- (void)setInnerShadowOffset:(CGSize)offset
{
    if (!CGSizeEqualToSize(_innerShadowOffset, offset))
    {
        _innerShadowOffset = offset;
        [self setNeedsDisplay];
    }
}

- (void)setInnerShadowColor:(UIColor *)color
{
    if (_innerShadowColor != color)
    {
        [_innerShadowColor release];
        _innerShadowColor = [color ah_retain];
        [self setNeedsDisplay];
    }
}

- (UIColor *)gradientStartColor
{
    return [_gradientColors count]? [_gradientColors objectAtIndex:0]: nil;
}

- (void)setGradientStartColor:(UIColor *)color
{
    if (color == nil)
    {
        self.gradientColors = nil;
    }
    else if ([_gradientColors count] < 2)
    {
        self.gradientColors = [NSArray arrayWithObjects:color, color, nil];
    }
    else if ([_gradientColors objectAtIndex:0] != color)
    {
        NSMutableArray *colors = [_gradientColors mutableCopy];
        [colors replaceObjectAtIndex:0 withObject:color];
        self.gradientColors = colors;
        [colors release];
    }
}

- (UIColor *)gradientEndColor
{
    return [_gradientColors lastObject];
}

- (void)setGradientEndColor:(UIColor *)color
{
    if (color == nil)
    {
        self.gradientColors = nil;
    }
    else if ([_gradientColors count] < 2)
    {
        self.gradientColors = [NSArray arrayWithObjects:color, color, nil];
    }
    else if ([_gradientColors lastObject] != color)
    {
        NSMutableArray *colors = [_gradientColors mutableCopy];
        [colors replaceObjectAtIndex:[colors count] - 1 withObject:color];
        self.gradientColors = colors;
        [colors release];
    }
}

- (void)setGradientColors:(NSArray *)colors
{
    if (_gradientColors != colors)
    {
        [_gradientColors release];
        _gradientColors = [colors copy];
        [self setNeedsDisplay];
    }
}

- (void)setOversampling:(NSUInteger)samples
{
    samples = MIN(_maxSamples, MAX(_minSamples, samples));
    if (_oversampling != samples)
    {
		_oversampling = samples;
        [self setNeedsDisplay];
    }
}

- (void)setTextInsets:(UIEdgeInsets)insets
{
    if (!UIEdgeInsetsEqualToEdgeInsets(_textInsets, insets))
    {
        _textInsets = insets;
        [self setNeedsDisplay];
    }
}

- (void)getComponents:(CGFloat *)rgba forColor:(CGColorRef)color
{
    CGColorSpaceModel model = CGColorSpaceGetModel(CGColorGetColorSpace(color));
    const CGFloat *components = CGColorGetComponents(color);
    switch (model)
    {
        case kCGColorSpaceModelMonochrome:
        {
            rgba[0] = components[0];
            rgba[1] = components[0];
            rgba[2] = components[0];
            rgba[3] = components[1];
            break;
        }
        case kCGColorSpaceModelRGB:
        {
            rgba[0] = components[0];
            rgba[1] = components[1];
            rgba[2] = components[2];
            rgba[3] = components[3];
            break;
        }
        default:
        {
            NSLog(@"Unsupported gradient color format: %i", model);
            rgba[0] = 0.0f;
            rgba[1] = 0.0f;
            rgba[2] = 0.0f;
            rgba[3] = 1.0f;
            break;
        }
    }
}

- (UIColor *)color:(CGColorRef)a blendedWithColor:(CGColorRef)b
{
    CGFloat aRGBA[4];
    [self getComponents:aRGBA forColor:a];
    CGFloat bRGBA[4];
    [self getComponents:bRGBA forColor:b];
    CGFloat source = aRGBA[3];
    CGFloat dest = 1.0f - source;
    return [UIColor colorWithRed:source * aRGBA[0] + dest * bRGBA[0]
                           green:source * aRGBA[1] + dest * bRGBA[1]
                            blue:source * aRGBA[2] + dest * bRGBA[2]
                           alpha:bRGBA[3] + (1.0f - bRGBA[3]) * aRGBA[3]];
}

- (void)drawTextInRect:(CGRect)rect withFont:(UIFont *)font
{
    if (self.adjustsFontSizeToFitWidth && self.numberOfLines == 1 && font.pointSize < self.font.pointSize)
    {
        CGFloat fontSize = 0.0f;
        [self.text drawAtPoint:rect.origin forWidth:rect.size.width withFont:self.font minFontSize:font.pointSize actualFontSize:&fontSize lineBreakMode:self.lineBreakMode baselineAdjustment:self.baselineAdjustment];
    }
    else
    {
        [self.text drawInRect:rect withFont:font lineBreakMode:self.lineBreakMode alignment:self.textAlignment];
    }
}

- (void)drawRect:(CGRect)rect
{
    //get drawing context
    BOOL subcontext = _oversampling > _minSamples || (self.backgroundColor && ![self.backgroundColor isEqual:[UIColor clearColor]]);
	if (subcontext)
    {
        UIGraphicsBeginImageContextWithOptions(rect.size, NO, _oversampling);
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //apply insets
    CGRect contentRect = CGRectMake(0.0f, 0.0f, self.bounds.size.width, self.bounds.size.height);
    contentRect.origin.x += _textInsets.left;
    contentRect.origin.y += _textInsets.top;
    contentRect.size.width -= (_textInsets.left + _textInsets.right);
    contentRect.size.height -= (_textInsets.top + _textInsets.bottom);
    
    //get label size
    CGRect textRect = contentRect;
    CGFloat fontSize = self.font.pointSize;
    CGFloat minimumFontSize;
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED == __IPHONE_6_0
    minimumFontSize = self.minimumScaleFactor? self.minimumScaleFactor * fontSize: fontSize;
#else
    minimumFontSize = self.minimumFontSize;
#endif
    
    if (self.adjustsFontSizeToFitWidth && self.numberOfLines == 1)
    {
        textRect.size = [self.text sizeWithFont:self.font
                                    minFontSize:minimumFontSize
                                 actualFontSize:&fontSize
                                       forWidth:contentRect.size.width
                                  lineBreakMode:self.lineBreakMode];
    }
    else
    {
        textRect.size = [self.text sizeWithFont:self.font
                              constrainedToSize:contentRect.size
                                  lineBreakMode:self.lineBreakMode];
    }
    
    //set font
    UIFont *font = [self.font fontWithSize:fontSize];
    
    //set color
    UIColor *highlightedColor = self.highlightedTextColor ?: self.textColor;
    UIColor *textColor = self.highlighted? highlightedColor: self.textColor;
    textColor = textColor ?: [UIColor clearColor];
    
    //set position
    switch (self.textAlignment)
    {
        case NSTextAlignmentCenter:
        {
            textRect.origin.x = contentRect.origin.x + (contentRect.size.width - textRect.size.width) / 2.0f;
            break;
        }
        case NSTextAlignmentRight:
        {
            textRect.origin.x = contentRect.origin.x + contentRect.size.width - textRect.size.width;
            break;
        }
        default:
        {
            textRect.origin.x = contentRect.origin.x;
            break;
        }
    }
    switch (self.contentMode)
    {
        case UIViewContentModeTop:
        case UIViewContentModeTopLeft:
        case UIViewContentModeTopRight:
        {
            textRect.origin.y = contentRect.origin.y;
            break;
        }
        case UIViewContentModeBottom:
        case UIViewContentModeBottomLeft:
        case UIViewContentModeBottomRight:
        {
            textRect.origin.y = contentRect.origin.y + contentRect.size.height - textRect.size.height;
            break;
        }
        default:
        {
            textRect.origin.y = contentRect.origin.y + (contentRect.size.height - textRect.size.height)/2.0f;
            break;
        }
    }
    
    BOOL hasShadow = self.shadowColor &&
    ![self.shadowColor isEqual:[UIColor clearColor]] &&
    (shadowBlur > 0.0f || !CGSizeEqualToSize(self.shadowOffset, CGSizeZero));
    
    BOOL hasInnerShadow = _innerShadowColor &&
    ![_innerShadowColor isEqual:[UIColor clearColor]] &&
    !CGSizeEqualToSize(_innerShadowOffset, CGSizeZero);
    
    BOOL hasGradient = [_gradientColors count] > 1;
    
    BOOL needsMask = hasInnerShadow || hasGradient;
    
    CGImageRef alphaMask = NULL;
    if (needsMask)
    {
        //draw mask
        CGContextSaveGState(context);
        [self drawTextInRect:textRect withFont:font];
        CGContextRestoreGState(context);
        
        // Create an image mask from what we've drawn so far
        alphaMask = CGBitmapContextCreateImage(context);
        
        //clear the context
        CGContextClearRect(context, textRect);
    }
    
    if (hasShadow)
    {
        //set up shadow
        CGContextSaveGState(context);
        CGFloat textAlpha = CGColorGetAlpha(textColor.CGColor);
        CGContextSetShadowWithColor(context, self.shadowOffset, shadowBlur, self.shadowColor.CGColor);
        [needsMask? [self.shadowColor colorWithAlphaComponent:textAlpha]: textColor setFill];
        [self drawTextInRect:textRect withFont:font];
        CGContextRestoreGState(context);
    }
    else if (!needsMask)
    {
        //just draw the text
        [textColor setFill];
        [self drawTextInRect:textRect withFont:font];
    }
    
    if (needsMask)
    {
        //clip the context
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, 0, contentRect.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextClipToMask(context, contentRect, alphaMask);
        
        if (hasInnerShadow)
        {
            //fill inner shadow
            [_innerShadowColor setFill];
            CGContextFillRect(context, textRect);
            
            //clip to unshadowed part
            CGContextTranslateCTM(context, _innerShadowOffset.width, -_innerShadowOffset.height);
            CGContextClipToMask(context, contentRect, alphaMask);
        }
        
        if (hasGradient)
        {
            //create array of pre-blended CGColors
            NSMutableArray *colors = [NSMutableArray arrayWithCapacity:[_gradientColors count]];
            for (UIColor *color in _gradientColors)
            {
                UIColor *blended = [self color:color.CGColor blendedWithColor:textColor.CGColor];
                [colors addObject:(__bridge id)blended.CGColor];
            }
            
            //draw gradient
            CGContextScaleCTM(context, 1.0, -1.0);
            CGContextTranslateCTM(context, 0, -contentRect.size.height);
            CGGradientRef gradient = CGGradientCreateWithColors(NULL, (__bridge CFArrayRef)colors, NULL);
            CGPoint startPoint = CGPointMake(textRect.origin.x + _gradientStartPoint.x * textRect.size.width,
                                             textRect.origin.y + _gradientStartPoint.y * textRect.size.height);
            CGPoint endPoint = CGPointMake(textRect.origin.x + _gradientEndPoint.x * textRect.size.width,
                                           textRect.origin.y + _gradientEndPoint.y * textRect.size.height);
            CGContextDrawLinearGradient(context, gradient, startPoint, endPoint,
                                        kCGGradientDrawsAfterEndLocation | kCGGradientDrawsBeforeStartLocation);
            CGGradientRelease(gradient);
        }
        else
        {
            //fill text
            [textColor setFill];
            CGContextFillRect(context, textRect);
        }
        
        //end clipping
        CGContextRestoreGState(context);
        CGImageRelease(alphaMask);
    }
    
    if (subcontext)
    {
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [image drawInRect:rect];
    }
}

- (void)dealloc
{
    [_innerShadowColor release];
    [_gradientColors release];
    [super ah_dealloc];
}

@end