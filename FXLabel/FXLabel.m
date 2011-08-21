//
//  FXLabel.m
//
//  Version 1.0
//
//  Created by Nick Lockwood on 20/08/2011.
//  Copyright 2011 Charcoal Design. All rights reserved.
//
//  Get the latest version from either of these locations:
//
//  http://charcoaldesign.co.uk/source/cocoa#fxlabel
//  https://github.com/demosthenese/FXLabel
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


- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        self.backgroundColor = nil;
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

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //get label size
    CGFloat fontSize = 0.0f;
    CGRect textRect = CGRectZero;
    textRect.size = [self.text sizeWithFont:self.font
                                minFontSize:self.minimumFontSize
                             actualFontSize:&fontSize
                                   forWidth:rect.size.width
                              lineBreakMode:self.lineBreakMode];
    //set font
    UIFont *font = [self.font fontWithSize:fontSize];
    
    //set position
    textRect.size.width = rect.size.width;
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
        !CGSizeEqualToSize(self.shadowOffset, CGSizeZero);
    
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
    
    //set up shadow
    CGContextSaveGState(context);
    if (hasShadow)
    {
        CGContextSetShadowWithColor(context, self.shadowOffset, shadowBlur, self.shadowColor.CGColor);
    }
    
    if (hasInnerShadow)
    {
        [innerShadowColor setFill];
        [self.text drawInRect:textRect withFont:font lineBreakMode:self.lineBreakMode alignment:self.textAlignment];
        CGContextRestoreGState(context);
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
            CGContextTranslateCTM(context, innerShadowOffset.width, -innerShadowOffset.height);
            CGContextClipToMask(context, rect, alphaMask);
        }
        
        //fill text
        [self.textColor setFill];
        CGContextFillRect(context, textRect);
    }
    else
    {
        //draw text
        [self.textColor setFill];
        [self.text drawInRect:textRect withFont:font lineBreakMode:self.lineBreakMode alignment:self.textAlignment];
        CGContextRestoreGState(context);
    }
    
    if (hasGradient)
    {
        //draw gradient
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextTranslateCTM(context, 0, -rect.size.height);
        CFArrayRef colors = (CFArrayRef)[NSArray arrayWithObjects:
                                         (id)[self gradientStartColor].CGColor,
                                         (id)[self gradientEndColor].CGColor,
                                         nil];
        CGGradientRef gradient = CGGradientCreateWithColors(NULL, colors, NULL);
        CGPoint gradientStartPoint = CGPointMake(0, textRect.origin.y);
        CGPoint gradientEndPoint = CGPointMake(0, textRect.origin.y + textRect.size.height);
        CGContextDrawLinearGradient(context, gradient, gradientStartPoint, gradientEndPoint,
                                    kCGGradientDrawsAfterEndLocation | kCGGradientDrawsBeforeStartLocation);
        CGGradientRelease(gradient);
    }
    
    if (needsMask)
    {
        //end clipping
        CGContextRestoreGState(context);
        CGImageRelease(alphaMask);
    }
}

- (void)dealloc
{
    [innerShadowColor release];
    [super dealloc];
}

@end
