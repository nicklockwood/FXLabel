//
//  FXLabel.m
//
//  Version 1.2
//
//  Created by Nick Lockwood on 20/08/2011.
//  Copyright 2011 Charcoal Design. All rights reserved.
//
//  Get the latest version from either of these locations:
//
//  http://charcoaldesign.co.uk/source/cocoa#fxlabel
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
//  2. Altered source versions must be plainly marked as such, and must not be
//  misrepresented as being the original software.
//  3. This notice may not be removed or altered from any source distribution.
//

#import "FXLabel.h"


@implementation FXLabel

@synthesize shadowBlur;
@synthesize innerShadowOffset;
@synthesize innerShadowColor;
@synthesize gradientStartColor;
@synthesize gradientEndColor;
@synthesize gradientStartPoint;
@synthesize gradientEndPoint;
@synthesize oversample;


- (void)setDefaults
{
    gradientStartPoint = CGPointMake(0.5f, 0.0f);
    gradientEndPoint = CGPointMake(0.5f, 0.75f);
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

- (void)setShadowBlur:(CGFloat)blur
{
    if (shadowBlur != blur)
    {
        shadowBlur = blur;
        [self setNeedsDisplay];
    }
}

- (void)setInnerShadowOffset:(CGSize)offset
{
    if (!CGSizeEqualToSize(innerShadowOffset, offset))
    {
        innerShadowOffset = offset;
        [self setNeedsDisplay];
    }
}

- (void)setInnerShadowColor:(UIColor *)color
{
    if (innerShadowColor != color)
    {
        [innerShadowColor release];
        innerShadowColor = [color retain];
        [self setNeedsDisplay];
    }
}

- (void)setGradientStartColor:(UIColor *)color
{
    if (gradientStartColor != color)
    {
        [gradientStartColor release];
        gradientStartColor = [color retain];
        [self setNeedsDisplay];
    }
}

- (void)setGradientEndColor:(UIColor *)color
{
    if (gradientEndColor != color)
    {
        [gradientEndColor release];
        gradientEndColor = [color retain];
        [self setNeedsDisplay];
    }
}

- (void)setOversample:(BOOL)over
{
    if (oversample != over)
    {
		oversample = over && [[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0f;
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

- (CGColorRef)color:(CGColorRef)a blendedWithColor:(CGColorRef)b
{
    CGFloat aRGBA[4];
    [self getComponents:aRGBA forColor:a];
    if (aRGBA[3] == 1.0f)
    {
        return [UIColor colorWithRed:aRGBA[0] green:aRGBA[1] blue:aRGBA[2] alpha:aRGBA[3]].CGColor;
    }
    
    CGFloat bRGBA[4];
    [self getComponents:bRGBA forColor:b];
    CGFloat source = aRGBA[3];
    CGFloat dest = 1.0f - source;
    return [UIColor colorWithRed:source * aRGBA[0] + dest * bRGBA[0]
                           green:source * aRGBA[1] + dest * bRGBA[1]
                            blue:source * aRGBA[2] + dest * bRGBA[2]
                           alpha:bRGBA[3] + (1.0f - bRGBA[3]) * aRGBA[3]].CGColor;
}

- (void)drawRect:(CGRect)rect
{
    //get drawing context
	if (oversample)
    {
        UIGraphicsBeginImageContextWithOptions(rect.size, NO, [[UIScreen mainScreen] scale] * 2.0f);
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //get label size
    CGRect textRect = rect;
    CGFloat fontSize = self.font.pointSize;
    if (self.adjustsFontSizeToFitWidth)
    {
        textRect.size = [self.text sizeWithFont:self.font
                                    minFontSize:self.minimumFontSize
                                 actualFontSize:&fontSize
                                       forWidth:rect.size.width
                                  lineBreakMode:self.lineBreakMode];
    }
    else
    {
        textRect.size = [self.text sizeWithFont:self.font
                                       forWidth:rect.size.width
                                  lineBreakMode:self.lineBreakMode];
    }
    
    //set font
    UIFont *font = [self.font fontWithSize:fontSize];
    
    //set position
    switch (self.textAlignment)
    {
        case UITextAlignmentCenter:
        {
            textRect.origin.x = (rect.size.width - textRect.size.width) / 2.0f;
            break;
        }
        case UITextAlignmentRight:
        {
            textRect.origin.x = rect.size.width - textRect.size.width;
            break;
        }
        default:
        {
            break;
        }
    }
    switch (self.contentMode)
    {
        case UIViewContentModeTop:
        case UIViewContentModeTopLeft:
        case UIViewContentModeTopRight:
        {
            textRect.origin.y = 0.0f;
            break;
        }
        case UIViewContentModeBottom:
        case UIViewContentModeBottomLeft:
        case UIViewContentModeBottomRight:
        {
            textRect.origin.y = rect.size.height - textRect.size.height;
            break;
        }
        default:
        {
            textRect.origin.y = (rect.size.height - textRect.size.height)/2.0f;
            break;
        }
    }
    
    BOOL hasShadow = self.shadowColor &&
    ![self.shadowColor isEqual:[UIColor clearColor]] &&
    (shadowBlur > 0.0f || !CGSizeEqualToSize(self.shadowOffset, CGSizeZero));
    
    BOOL hasInnerShadow = innerShadowColor &&
    ![self.innerShadowColor isEqual:[UIColor clearColor]] &&
    !CGSizeEqualToSize(innerShadowOffset, CGSizeZero);
    
    BOOL hasGradient = gradientStartColor && gradientEndColor;
    
    BOOL needsMask = hasInnerShadow || hasGradient;
    
    CGImageRef alphaMask = NULL;
    if (needsMask)
    {
        //draw mask
        CGContextSaveGState(context);
        [self.text drawInRect:textRect withFont:font lineBreakMode:self.lineBreakMode alignment:self.textAlignment];
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
        CGFloat textAlpha = CGColorGetAlpha(self.textColor.CGColor);
        CGContextSetShadowWithColor(context, self.shadowOffset, shadowBlur, self.shadowColor.CGColor);
        [needsMask? [self.shadowColor colorWithAlphaComponent:textAlpha]: self.textColor setFill];
        [self.text drawInRect:textRect withFont:font lineBreakMode:self.lineBreakMode alignment:self.textAlignment];
        CGContextRestoreGState(context);
    }
    else if (!needsMask)
    {
        //just draw the text
        [self.textColor setFill];
        [self.text drawInRect:textRect withFont:font lineBreakMode:self.lineBreakMode alignment:self.textAlignment];
    }
    
    if (needsMask)
    {
        //clip the context
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, 0, rect.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextClipToMask(context, rect, alphaMask);
        
        if (hasInnerShadow)
        {
            //fill inner shadow
            [innerShadowColor setFill];
            CGContextFillRect(context, textRect);
            
            //clip to unshadowed part
            CGContextTranslateCTM(context, innerShadowOffset.width, -innerShadowOffset.height);
            CGContextClipToMask(context, rect, alphaMask);
        }
        
        if (hasGradient)
        {
            //pre-blend
            CGColorRef startColor = [self color:gradientStartColor.CGColor blendedWithColor:self.textColor.CGColor];
            CGColorRef endColor = [self color:gradientEndColor.CGColor blendedWithColor:self.textColor.CGColor];
            
            //draw gradient
            CGContextScaleCTM(context, 1.0, -1.0);
            CGContextTranslateCTM(context, 0, -rect.size.height);
            CFArrayRef colors = (CFArrayRef)[NSArray arrayWithObjects:(id)startColor, (id)endColor, nil];
            CGGradientRef gradient = CGGradientCreateWithColors(NULL, colors, NULL);
            CGPoint startPoint = CGPointMake(textRect.origin.x + gradientStartPoint.x * textRect.size.width,
                                             textRect.origin.y + gradientStartPoint.y * textRect.size.height);
            CGPoint endPoint = CGPointMake(textRect.origin.x + gradientEndPoint.x * textRect.size.width,
                                           textRect.origin.y + gradientEndPoint.y * textRect.size.height);
            CGContextDrawLinearGradient(context, gradient, startPoint, endPoint,
                                        kCGGradientDrawsAfterEndLocation | kCGGradientDrawsBeforeStartLocation);
            CGGradientRelease(gradient);
        }
        else
        {
            //fill text
            [self.textColor setFill];
            CGContextFillRect(context, textRect);
        }
        
        //end clipping
        CGContextRestoreGState(context);
        CGImageRelease(alphaMask);
    }
    
    if (oversample)
    {
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [image drawInRect:rect];
    }
}

- (void)dealloc
{
    [innerShadowColor release];
    [gradientStartColor release];
    [gradientEndColor release];
    [super dealloc];
}

@end