//
//  FXLabel.h
//
//  Version 1.5.9
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


#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wobjc-missing-property-synthesis"


#import <UIKit/UIKit.h>


#ifndef IB_DESIGNABLE
#define IB_DESIGNABLE
#endif


NS_ASSUME_NONNULL_BEGIN


@interface NSString (FXLabelDrawing)

- (CGSize)sizeWithFont:(UIFont *)font
           minFontSize:(CGFloat)minFontSize
        actualFontSize:(nullable CGFloat *)actualFontSize
              forWidth:(CGFloat)width
         lineBreakMode:(NSLineBreakMode)lineBreakMode
      characterSpacing:(CGFloat)characterSpacing
          kerningTable:(nullable NSDictionary<NSString *, NSNumber *> *)kerningTable;

- (CGSize)drawAtPoint:(CGPoint)point
             forWidth:(CGFloat)width
             withFont:(UIFont *)font
          minFontSize:(CGFloat)minFontSize
       actualFontSize:(nullable CGFloat *)actualFontSize
        lineBreakMode:(NSLineBreakMode)lineBreakMode
   baselineAdjustment:(UIBaselineAdjustment)baselineAdjustment
     characterSpacing:(CGFloat)characterSpacing
         kerningTable:(nullable NSDictionary<NSString *, NSNumber *> *)kerningTable;

- (CGSize)sizeWithFont:(UIFont *)font
     constrainedToSize:(CGSize)size
         lineBreakMode:(NSLineBreakMode)lineBreakMode
           lineSpacing:(CGFloat)lineSpacing
      characterSpacing:(CGFloat)characterSpacing
          kerningTable:(nullable NSDictionary<NSString *, NSNumber *> *)kerningTable
          allowOrphans:(BOOL)allowOrphans;

- (CGSize)drawInRect:(CGRect)rect
            withFont:(UIFont *)font
       lineBreakMode:(NSLineBreakMode)lineBreakMode
           alignment:(NSTextAlignment)alignment
         lineSpacing:(CGFloat)lineSpacing
    characterSpacing:(CGFloat)characterSpacing
        kerningTable:(nullable NSDictionary<NSString *, NSNumber *> *)kerningTable
        allowOrphans:(BOOL)allowOrphans;
@end


IB_DESIGNABLE @interface FXLabel : UILabel

@property (nonatomic) CGFloat shadowBlur;
@property (nonatomic) CGFloat innerShadowBlur;
@property (nonatomic) CGSize innerShadowOffset;
@property (nonatomic, strong, nullable) UIColor *innerShadowColor;
@property (nonatomic, strong, nullable) UIColor *gradientStartColor;
@property (nonatomic, strong, nullable) UIColor *gradientEndColor;
@property (nonatomic, copy, nullable) NSArray<UIColor *> *gradientColors;
@property (nonatomic) CGPoint gradientStartPoint;
@property (nonatomic) CGPoint gradientEndPoint;
@property (nonatomic) NSUInteger oversampling;
@property (nonatomic) UIEdgeInsets textInsets;
@property (nonatomic) CGFloat lineSpacing;
@property (nonatomic) CGFloat characterSpacing;
@property (nonatomic) CGFloat baselineOffset;
@property (nonatomic, copy, nullable) NSDictionary<NSString *, NSNumber *> *kerningTable;
@property (nonatomic) BOOL allowOrphans;

- (void)setUp;

@end


NS_ASSUME_NONNULL_END


#pragma GCC diagnostic pop

