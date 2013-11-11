//
//  FXLabel.m
//
//  Version 1.5.3
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


#import "FXLabel.h"


#import <Availability.h>
#if !__has_feature(objc_arc)
#error This class requires automatic reference counting
#endif


@implementation NSString (FXLabelDrawing)

- (CGContextRef)FXLabel_sizingContext
{
    static CGContextRef context = NULL;
    if (!context)
    {
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
        context = CGBitmapContextCreate(NULL, 1, 1, 8, 0, colorSpace, 0);
        CGContextSetTextDrawingMode(context, kCGTextInvisible);
        CGColorSpaceRelease(colorSpace);
    }
    return context;
}

- (BOOL)FXLabel_isPunctuation
{
    return [[NSSet setWithObjects:
             @"-", //hyphen
             @"–", //en-dash
             @"—", //em-dash
             @";",
             @":",
             nil] containsObject:self];
}

- (NSArray *)FXLabel_characters
{
    NSMutableArray *characters = [NSMutableArray array];
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, __unused NSRange substringRange, __unused NSRange enclosingRange, __unused BOOL *stop) {
        
        [characters addObject:substring];
    }];
    return characters;
}

- (NSArray *)FXLabel_linesWithFont:(UIFont *)font
                 constrainedToSize:(CGSize)size
                     lineBreakMode:(NSLineBreakMode)lineBreakMode
                       lineSpacing:(CGFloat)lineSpacing
                  characterSpacing:(CGFloat)characterSpacing
                      kerningTable:(NSDictionary *)kerningTable
                      allowOrphans:(BOOL)allowOrphans
{
    NSUInteger index = 0;
    NSMutableArray *lines = [NSMutableArray array];
    if (lineBreakMode == NSLineBreakByCharWrapping)
    {
        //split text into individual characters
        NSArray *characters = [self FXLabel_characters];
        
        //calculate lines
        while (index < [characters count])
        {
            NSInteger lineCount = [lines count];
            if (lineCount && ((lineCount + 1) * font.lineHeight + lineCount * roundf(font.pointSize * lineSpacing)) > size.height)
            {
                //append remaining text to last line
                NSArray *remainingChars = [characters subarrayWithRange:NSMakeRange(index, [characters count] - index)];
                NSString *line = [lines lastObject];
                NSString *newLine = [line length]? line: @"";
                newLine = [newLine stringByAppendingString:[remainingChars componentsJoinedByString:@""]];
                newLine = [newLine stringByReplacingOccurrencesOfString:@"\n " withString:@"\n"];
                newLine = [newLine stringByReplacingOccurrencesOfString:@" \n" withString:@"\n"];
                lines[lineCount - 1] = newLine;
                break;
            }
            NSString *line = nil;
            for (NSUInteger i = index; i < [characters count]; i++)
            {
                NSString *character = characters[i];
                NSString *newLine = line? [line stringByAppendingString:character]: character;
                CGFloat lineWidth = [newLine sizeWithFont:font
                                              minFontSize:font.pointSize
                                           actualFontSize:NULL
                                                 forWidth:INFINITY
                                            lineBreakMode:lineBreakMode
                                         characterSpacing:characterSpacing
                                             kerningTable:kerningTable].width;
                
                if ([character isEqualToString:@"\n"])
                {
                    //add line and prepare for next
                    [lines addObject:line ?: @""];
                    index = i + 1;
                    break;
                }
                else if (lineWidth > size.width && line)
                {
                    //add line and prepare for next
                    [lines addObject:line];
                    index = i;
                    break;
                }
                else if (i == [characters count] - 1)
                {
                    //add line and finish
                    [lines addObject:newLine];
                    index = i + 1;
                    break;
                }
                else
                {
                    //continue
                    line = newLine;
                }
            }
        }
    }
    else
    {
        //TODO: handle hyphenation
        
        //split text into words
        NSMutableArray *words = [NSMutableArray array];
        [self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationByLines usingBlock:^(NSString *substring, __unused NSRange substringRange, __unused NSRange enclosingRange, __unused BOOL *stop) {
            
            [words addObjectsFromArray:[substring componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
            
            [words addObject:@"\n"];
        }];
        [words removeLastObject];
        
        //calculate lines
        while (index < [words count])
        {
            NSInteger lineCount = [lines count];
            if (lineCount && ((lineCount + 1) * font.lineHeight + lineCount * roundf(font.pointSize * lineSpacing)) > size.height)
            {
                //append remaining text to last line
                NSArray *remainingWords = [words subarrayWithRange:NSMakeRange(index, [words count] - index)];
                NSString *line = [lines lastObject];
                NSString *newLine = [line length]? [line stringByAppendingString:@" "]: @"";
                newLine = [newLine stringByAppendingString:[remainingWords componentsJoinedByString:@" "]];
                newLine = [newLine stringByReplacingOccurrencesOfString:@"\n " withString:@"\n"];
                newLine = [newLine stringByReplacingOccurrencesOfString:@" \n" withString:@"\n"];
                lines[lineCount - 1] = newLine;
                break;
            }
            NSString *line = nil;
            for (NSUInteger i = index; i < [words count]; i++)
            {
                NSString *word = words[i];
                NSString *newLine = line? [line stringByAppendingFormat:@" %@", word]: word;
                CGFloat lineWidth = [newLine sizeWithFont:font
                                              minFontSize:font.pointSize
                                           actualFontSize:NULL
                                                 forWidth:INFINITY
                                            lineBreakMode:lineBreakMode
                                         characterSpacing:characterSpacing
                                             kerningTable:kerningTable].width;
                
                if ([word isEqualToString:@"\n"])
                {
                    //add line and prepare for next
                    [lines addObject:line ?: @""];
                    index = i + 1;
                    break;
                }
                else if (lineWidth > size.width && line)
                {
                    //check for orphans
                    if (!allowOrphans && i > 0 &&
                        (i == [words count] - 1 || [words[i + 1] isEqualToString:@"\n"]) &&
                        ![words[i - 1] FXLabel_isPunctuation])
                    {
                        //force line break
                        NSRange range = [line rangeOfString:@" " options:NSBackwardsSearch];
                        if (range.location != NSNotFound)
                        {
                            line = [line substringToIndex:range.location];
                            i --;
                        }
                    }
                    
                    //add line and prepare for next
                    [lines addObject:line];
                    index = i;
                    break;
                }
                else if (i == [words count] - 1)
                {
                    //add line and finish
                    [lines addObject:newLine];
                    index = i + 1;
                    break;
                }
                else
                {
                    //continue
                    line = newLine;
                }
            }
        }
    }
    return lines;
}

- (CGSize)FXLabel_sizeWithFont:(UIFont *)font
{
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
    
    return [self sizeWithAttributes:@{NSFontAttributeName: font}];
    
#else
    
    return [self sizeWithFont:font];
    
#endif
    
}

- (CGSize)FXLabel_sizeWithFont:(UIFont *)font minFontSize:(CGFloat)minFontSize actualFontSize:(CGFloat *)actualFontSize forWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
    
    minFontSize = MIN(font.pointSize, minFontSize);

    CGFloat fontSize = font.pointSize;
    CGSize size = CGSizeMake(INFINITY, font.lineHeight);
    while (size.width > width && fontSize >= minFontSize)
    {
        size.width = [self sizeWithAttributes:@{NSFontAttributeName: [font fontWithSize:fontSize]}].width;
        if (actualFontSize) *actualFontSize = fontSize;
        fontSize = MAX(minFontSize, fontSize - 1);
    }
    size.width = MIN(width, size.width);
    return size;
    
#else
    
    return [self sizeWithFont:font
                  minFontSize:minFontSize
               actualFontSize:actualFontSize
                     forWidth:width
                lineBreakMode:lineBreakMode];
    
#endif
    
}

- (CGSize)FXLabel_sizeWithFont:(UIFont *)font
             constrainedToSize:(CGSize)size
                 lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = lineBreakMode;
    
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    
    return [self boundingRectWithSize:size
                              options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin
                           attributes:@{NSFontAttributeName: font, NSParagraphStyleAttributeName: style}
                              context:context].size;
    
#else
    
    return [self sizeWithFont:font
            constrainedToSize:size
                lineBreakMode:lineBreakMode];
    
#endif
    
}

- (CGSize)FXLabel_drawInRect:(CGRect)rect
                    withFont:(UIFont *)font
               lineBreakMode:(__unused NSLineBreakMode)lineBreakMode
                   alignment:(NSTextAlignment)alignment
{
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = lineBreakMode;
    style.alignment = alignment;
    
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    
    [self drawWithRect:rect
               options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin
            attributes:@{NSFontAttributeName: font, NSParagraphStyleAttributeName: style}
               context:context];
    
    return context.totalBounds.size;
    
#else
    
    return [self drawInRect:rect
                   withFont:font
              lineBreakMode:lineBreakMode
                  alignment:alignment];
    
#endif
    
}

- (CGSize)FXLabel_drawAtPoint:(CGPoint)point withFont:(UIFont *)font
{
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
    
    [self drawAtPoint:point withAttributes:@{NSFontAttributeName: font}];
    return [self FXLabel_sizeWithFont:font];
    
#else
    
    return [self drawAtPoint:point withFont:font];
    
#endif
    
}

- (CGSize)FXLabel_drawAtPoint:(CGPoint)point forWidth:(CGFloat)width withFont:(UIFont *)font minFontSize:(CGFloat)minFontSize actualFontSize:(CGFloat *)actualFontSize lineBreakMode:(NSLineBreakMode)lineBreakMode baselineAdjustment:(__unused UIBaselineAdjustment)baselineAdjustment
{
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
    
    CGFloat fontSize = 0;
    CGSize size = [self FXLabel_sizeWithFont:font minFontSize:minFontSize actualFontSize:&fontSize forWidth:width lineBreakMode:lineBreakMode];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = lineBreakMode;
    
    font = [font fontWithSize:fontSize];
    [self drawAtPoint:point withAttributes:@{NSFontAttributeName: font, NSParagraphStyleAttributeName: style}];
    
    if (actualFontSize) *actualFontSize = fontSize;
    return size;
    
#else
    
    return [self drawAtPoint:point
                    forWidth:width
                    withFont:font
                 minFontSize:minFontSize
              actualFontSize:actualFontSize
               lineBreakMode:lineBreakMode
          baselineAdjustment:baselineAdjustment];
    
#endif
    
}


- (CGSize)FXLabel_sizeWithFont:(UIFont *)font
                   minFontSize:(CGFloat)minFontSize
                actualFontSize:(CGFloat *)actualFontSize
                      forWidth:(CGFloat)width
                 lineBreakMode:(NSLineBreakMode)lineBreakMode
              characterSpacing:(CGFloat)characterSpacing
                  kerningTable:(NSDictionary *)kerningTable
              charactersFitted:(NSInteger *)charactersFitted
              includesEllipsis:(BOOL *)includesEllipsis
{
    UIGraphicsPushContext([self FXLabel_sizingContext]);
    
    if (includesEllipsis) *includesEllipsis = NO;
    minFontSize = minFontSize ?: font.pointSize;
    UIFont *subFont = font;
    while (true)
    {
        //TODO: doesn't correctly handle head or center truncation
        
        NSInteger i = 0;
        CGFloat x = 0.0f;
        NSArray *characters = [self FXLabel_characters];
        NSInteger charCount = [characters count];
        NSMutableArray *widths = [NSMutableArray arrayWithCapacity:charCount];
        for (i = 0; i < charCount; i++)
        {
            //get character width
            NSString *character = characters[i];
            CGFloat charWidth = [character FXLabel_drawAtPoint:CGPointZero withFont:subFont].width;
            if (i == charCount - 1 || x + charWidth > width)
            {
                [widths addObject:@(charWidth)];
                x += charWidth;
                break;
            }
            else
            {
                charWidth += ([kerningTable[character] floatValue] + characterSpacing) * subFont.pointSize;
                [widths addObject:@(charWidth)];
                x += charWidth;
            }
        }
        if (floorf(x) <= ceilf(width))
        {
            //the text fits, return size
            UIGraphicsPopContext();
            if (actualFontSize) *actualFontSize = subFont.pointSize;
            if (charactersFitted) *charactersFitted = charCount;
            return CGSizeMake(ceilf(x), font.lineHeight);
        }
        else if (subFont.pointSize == minFontSize)
        {
            //text is truncated
            if (lineBreakMode == NSLineBreakByClipping)
            {
                //subtract width of last character
                x -= [[widths lastObject] floatValue];
                
                UIGraphicsPopContext();
                if (actualFontSize) *actualFontSize = subFont.pointSize;
                if (charactersFitted) *charactersFitted = i + 1;
                return CGSizeMake(ceilf(x), font.lineHeight);
            }
            else
            {
                //allow space for ellipsis
                CGFloat ellipsisWidth = [@"…" FXLabel_sizeWithFont:subFont].width;
                if (ellipsisWidth > width)
                {
                    //can't fit any text at all
                    UIGraphicsPopContext();
                    if (actualFontSize) *actualFontSize = subFont.pointSize;
                    if (charactersFitted) *charactersFitted = 0;
                    return CGSizeMake(0.0f, font.lineHeight);
                }
                else
                {
                    //remove enough characters to allow space for ellipsis
                    for (i = [widths count] - 1; i >= 0; i--)
                    {
                        x -= [widths[i] floatValue];
                        if (x + ellipsisWidth <= width) break;
                    }
                    UIGraphicsPopContext();
                    if (actualFontSize) *actualFontSize = subFont.pointSize;
                    if (charactersFitted) *charactersFitted = MAX(0, i);
                    if (includesEllipsis) *includesEllipsis = YES;
                    return CGSizeMake(ceilf(x + ellipsisWidth), font.lineHeight);
                }
            }
        }
        else
        {
            //try again with the next point size
            CGFloat pointSize = MAX(minFontSize, subFont.pointSize - 1.0f);
            subFont = [font fontWithSize:pointSize];
        }
    }
}

- (CGSize)sizeWithFont:(UIFont *)font
           minFontSize:(CGFloat)minFontSize
        actualFontSize:(CGFloat *)actualFontSize
              forWidth:(CGFloat)width
         lineBreakMode:(NSLineBreakMode)lineBreakMode
      characterSpacing:(CGFloat)characterSpacing
          kerningTable:(NSDictionary *)kerningTable
{
    if (characterSpacing || [kerningTable count])
    {
        CGSize size = [self FXLabel_sizeWithFont:font
                                     minFontSize:minFontSize
                                  actualFontSize:actualFontSize
                                        forWidth:width
                                   lineBreakMode:lineBreakMode
                                characterSpacing:characterSpacing
                                    kerningTable:kerningTable
                                charactersFitted:NULL
                                includesEllipsis:NULL];
        
        //round up size to nearest point like normal NSString size functions do
        return CGSizeMake(ceilf(size.width), ceilf(size.height));
    }
    else
    {
        //use standard implementation
        return [self FXLabel_sizeWithFont:font
                              minFontSize:minFontSize
                           actualFontSize:actualFontSize
                                 forWidth:width
                            lineBreakMode:lineBreakMode];
    }
}

- (CGSize)drawAtPoint:(CGPoint)point
             forWidth:(CGFloat)width
             withFont:(UIFont *)font
          minFontSize:(CGFloat)minFontSize
       actualFontSize:(CGFloat *)actualFontSize
        lineBreakMode:(NSLineBreakMode)lineBreakMode
   baselineAdjustment:(UIBaselineAdjustment)baselineAdjustment
     characterSpacing:(CGFloat)characterSpacing
         kerningTable:(NSDictionary *)kerningTable
{
    if (characterSpacing || [kerningTable count])
    {
        //TODO: draw text to image and then paste into context to avoid overlap issues
        //TODO: doesn't correctly handle head or center truncation
        
        NSInteger charactersFitted = 0;
        BOOL includesEllipsis = NO;
        CGFloat fontSize = font.pointSize;
        CGSize size = [self FXLabel_sizeWithFont:font
                                     minFontSize:minFontSize
                                  actualFontSize:&fontSize
                                        forWidth:width
                                   lineBreakMode:lineBreakMode
                                characterSpacing:characterSpacing
                                    kerningTable:kerningTable
                                charactersFitted:&charactersFitted
                                includesEllipsis:&includesEllipsis];
        
        CGFloat y = point.y;
        UIFont *subFont = [font fontWithSize:fontSize];
        if (fontSize < font.pointSize)
        {
            switch (baselineAdjustment)
            {
                case UIBaselineAdjustmentAlignCenters:
                {
                    y += (font.lineHeight - subFont.lineHeight) / 2.0f;
                    break;
                }
                case UIBaselineAdjustmentAlignBaselines:
                {
                    y += (font.ascender - subFont.ascender);
                    break;
                }
                case UIBaselineAdjustmentNone:
                default:
                {
                    //no adjustment needed
                    break;
                }
            }
        }
        
        CGFloat x = point.x;
        for (int i = 0; i < charactersFitted; i++)
        {
            NSString *character = [self substringWithRange:NSMakeRange(i, 1)];
            CGFloat charWidth = [character FXLabel_drawAtPoint:CGPointMake(x, y) withFont:subFont].width;
            x += charWidth + ([kerningTable[character] floatValue] + characterSpacing) * subFont.pointSize;
        }
        if (includesEllipsis)
        {
            [@"…" FXLabel_drawAtPoint:CGPointMake(x, point.y) withFont:subFont];
        }
        
        if (actualFontSize) *actualFontSize = fontSize;
        return size;
    }
    else
    {
        //use standard implementation
        return [self FXLabel_drawAtPoint:point
                                forWidth:width
                                withFont:font
                             minFontSize:minFontSize
                          actualFontSize:actualFontSize
                           lineBreakMode:lineBreakMode
                      baselineAdjustment:baselineAdjustment];
    }
}

- (CGSize)sizeWithFont:(UIFont *)font
     constrainedToSize:(CGSize)size
         lineBreakMode:(NSLineBreakMode)lineBreakMode
           lineSpacing:(CGFloat)lineSpacing
      characterSpacing:(CGFloat)characterSpacing
          kerningTable:(NSDictionary *)kerningTable
          allowOrphans:(BOOL)allowOrphans
{
    if (lineSpacing || characterSpacing || [kerningTable count] || !allowOrphans)
    {
        NSArray *lines = [self FXLabel_linesWithFont:font
                                   constrainedToSize:size
                                       lineBreakMode:lineBreakMode
                                         lineSpacing:lineSpacing
                                    characterSpacing:characterSpacing
                                        kerningTable:kerningTable
                                        allowOrphans:allowOrphans];
        CGSize total = CGSizeZero;
        total.height = ceilf(MIN(size.height, [lines count] * font.lineHeight + ([lines count] - 1) * roundf(font.pointSize *lineSpacing)));
        for (NSString *line in lines)
        {
            total.width = ceilf(MAX(total.width, [line sizeWithFont:font
                                                        minFontSize:font.pointSize
                                                     actualFontSize:NULL
                                                           forWidth:size.width
                                                      lineBreakMode:lineBreakMode
                                                   characterSpacing:characterSpacing
                                                       kerningTable:kerningTable].width));
        }
        return total;
    }
    else
    {
        //use standard implementation
        return [self FXLabel_sizeWithFont:font
                        constrainedToSize:size
                            lineBreakMode:lineBreakMode];
    }
}

- (CGSize)drawInRect:(CGRect)rect
            withFont:(UIFont *)font
       lineBreakMode:(NSLineBreakMode)lineBreakMode
           alignment:(NSTextAlignment)alignment
         lineSpacing:(CGFloat)lineSpacing
    characterSpacing:(CGFloat)characterSpacing
        kerningTable:(NSDictionary *)kerningTable
        allowOrphans:(BOOL)allowOrphans
{
    if (lineSpacing || characterSpacing || [kerningTable count] || !allowOrphans)
    {
        //TODO: draw text to image and then paste into context to avoid overlap issues
        
        NSArray *lines = [self FXLabel_linesWithFont:font
                                   constrainedToSize:rect.size
                                       lineBreakMode:lineBreakMode
                                         lineSpacing:lineSpacing
                                    characterSpacing:characterSpacing
                                        kerningTable:kerningTable
                                        allowOrphans:allowOrphans];
        CGSize total = CGSizeZero;
        total.height = [lines count] * font.lineHeight + ([lines count] - 1) * roundf(font.pointSize * lineSpacing);
        CGPoint offset = rect.origin;
        for (NSString *line in lines)
        {
            CGSize size = [line sizeWithFont:font
                                 minFontSize:font.pointSize
                              actualFontSize:NULL
                                    forWidth:CGRectGetWidth(rect)
                               lineBreakMode:lineBreakMode
                            characterSpacing:characterSpacing
                                kerningTable:kerningTable];
            
            if (alignment == NSTextAlignmentCenter)
            {
                offset.x = roundf(rect.origin.x + (CGRectGetWidth(rect) - size.width)/ 2.0f);
            }
            else if (alignment == NSTextAlignmentRight)
            {
                offset.x = roundf(rect.origin.x + (CGRectGetWidth(rect) - size.width));
            }
            [line drawAtPoint:offset
                     forWidth:CGRectGetWidth(rect)
                     withFont:font
                  minFontSize:font.pointSize
               actualFontSize:NULL
                lineBreakMode:lineBreakMode
           baselineAdjustment:UIBaselineAdjustmentAlignBaselines
             characterSpacing:characterSpacing
                 kerningTable:kerningTable];
            
            total.width = MAX(total.width, offset.x + size.width);
            offset.y += roundf(font.lineHeight + font.pointSize * lineSpacing);
        }
        return total;
    }
    else
    {
        //use standard implementation
        return [self FXLabel_drawInRect:rect
                               withFont:font
                          lineBreakMode:lineBreakMode
                              alignment:alignment];
    }
}

@end


@interface FXLabel ()

@property (nonatomic, assign) NSUInteger minSamples;
@property (nonatomic, assign) NSUInteger maxSamples;

@end


@implementation FXLabel

@synthesize shadowBlur; //no leading _ to avoid conflict with private property

- (void)setUp
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
    _allowOrphans = YES;
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        self.backgroundColor = nil;
        [self setUp];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self setUp];
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

- (void)setInnerShadowBlur:(CGFloat)blur
{
    if (_innerShadowBlur != blur)
    {
        _innerShadowBlur = blur;
        [self setNeedsDisplay];
    }
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
        _innerShadowColor = color;
        [self setNeedsDisplay];
    }
}

- (UIColor *)gradientStartColor
{
    return [_gradientColors count]? _gradientColors[0]: nil;
}

- (void)setGradientStartColor:(UIColor *)color
{
    if (color == nil)
    {
        self.gradientColors = nil;
    }
    else if ([_gradientColors count] < 2)
    {
        self.gradientColors = @[color, color];
    }
    else if (_gradientColors[0] != color)
    {
        NSMutableArray *colors = [NSMutableArray arrayWithArray:_gradientColors];
        colors[0] = color;
        self.gradientColors = colors;
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
        self.gradientColors = @[color, color];
    }
    else if ([_gradientColors lastObject] != color)
    {
        NSMutableArray *colors = [NSMutableArray arrayWithArray:_gradientColors];
        colors[[colors count] - 1] = color;
        self.gradientColors = colors;
    }
}

- (void)setGradientColors:(NSArray *)colors
{
    if (_gradientColors != colors)
    {
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

- (void)setLineSpacing:(CGFloat)lineSpacing
{
    if (_lineSpacing != lineSpacing)
    {
        _lineSpacing = lineSpacing;
        [self setNeedsDisplay];
    }
}

- (void)setCharacterSpacing:(CGFloat)characterSpacing
{
    if (_characterSpacing != characterSpacing)
    {
        _characterSpacing = characterSpacing;
        [self setNeedsDisplay];
    }
}

- (void)setBaselineOffset:(CGFloat)baselineOffset
{
    if (_baselineOffset != baselineOffset)
    {
        _baselineOffset = baselineOffset;
        [self setNeedsDisplay];
    }
}

- (void)setCharacterKerning:(NSDictionary *)kerningTable
{
    if (_kerningTable != kerningTable)
    {
        _kerningTable = [kerningTable copy];
        [self setNeedsDisplay];
    }
}

- (void)setAllowOrphans:(BOOL)allowOrphans
{
    if (_allowOrphans != allowOrphans)
    {
        _allowOrphans = allowOrphans;
        [self setNeedsDisplay];
    }
}

- (CGSize)FXLabel_sizeThatFits:(CGSize)size actualFontSize:(CGFloat *)actualFontSize
{
    size.width = size.width ?: INFINITY;
    size.height = size.height ?: INFINITY;
    
    if (self.numberOfLines == 1)
    {
        
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
        
        CGFloat minimumFontSize = self.adjustsFontSizeToFitWidth? self.minimumFontSize: self.font.pointSize;
        
#else
        
        CGFloat minimumFontSize = self.adjustsFontSizeToFitWidth? self.minimumScaleFactor * self.font.pointSize: self.font.pointSize;
        
#endif
        size = [self.text sizeWithFont:self.font
                           minFontSize:minimumFontSize
                        actualFontSize:actualFontSize
                              forWidth:size.width
                         lineBreakMode:self.lineBreakMode
                      characterSpacing:_characterSpacing
                          kerningTable:_kerningTable];
    }
    else
    {
        if (actualFontSize) *actualFontSize = self.font.pointSize;
        
        size = [self.text sizeWithFont:self.font
                     constrainedToSize:size
                         lineBreakMode:self.lineBreakMode
                           lineSpacing:_lineSpacing
                      characterSpacing:_characterSpacing
                          kerningTable:_kerningTable
                          allowOrphans:_allowOrphans];
        
        if (self.numberOfLines > 0)
        {
            size.height = MIN(size.height, self.numberOfLines * self.font.lineHeight + (self.numberOfLines - 1) * self.font.pointSize * _lineSpacing);
        }
    }
    return CGSizeMake(ceilf(size.width), size.height);
}

- (CGSize)sizeThatFits:(CGSize)size
{
    size.width -= (_textInsets.left + _textInsets.right);
    size.height -= (_textInsets.top + _textInsets.bottom);
    size = [self FXLabel_sizeThatFits:size actualFontSize:NULL];
    size.width += (_textInsets.left + _textInsets.right);
    size.height += (_textInsets.top + _textInsets.bottom);
    size.width = ceilf(size.width);
    size.height = ceilf(size.height);
    return size;
}

- (void)FXLabel_getComponents:(CGFloat *)rgba forColor:(CGColorRef)color
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

- (UIColor *)FXLabel_color:(CGColorRef)a blendedWithColor:(CGColorRef)b
{
    CGFloat aRGBA[4];
    [self FXLabel_getComponents:aRGBA forColor:a];
    CGFloat bRGBA[4];
    [self FXLabel_getComponents:bRGBA forColor:b];
    CGFloat source = aRGBA[3];
    CGFloat dest = 1.0f - source;
    return [UIColor colorWithRed:source * aRGBA[0] + dest * bRGBA[0]
                           green:source * aRGBA[1] + dest * bRGBA[1]
                            blue:source * aRGBA[2] + dest * bRGBA[2]
                           alpha:bRGBA[3] + (1.0f - bRGBA[3]) * aRGBA[3]];
}

- (void)FXLabel_drawTextInRect:(CGRect)rect withFont:(UIFont *)font
{
    rect.origin.y += font.pointSize * _baselineOffset;
    if (self.numberOfLines == 1)
    {
        [self.text drawAtPoint:rect.origin
                      forWidth:rect.size.width
                      withFont:self.font
                   minFontSize:font.pointSize
                actualFontSize:NULL
                 lineBreakMode:self.lineBreakMode
            baselineAdjustment:self.baselineAdjustment
              characterSpacing:_characterSpacing
                  kerningTable:_kerningTable];
    }
    else
    {
        [self.text drawInRect:rect
                     withFont:font
                lineBreakMode:self.lineBreakMode
                    alignment:self.textAlignment
                  lineSpacing:_lineSpacing
             characterSpacing:_characterSpacing
                 kerningTable:_kerningTable
                 allowOrphans:_allowOrphans];
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
    
    //get dimensions
    CGFloat fontSize = 0.0f;
    CGRect textRect = contentRect;
    textRect.size = [self FXLabel_sizeThatFits:contentRect.size actualFontSize:&fontSize];
    
    //set font
    UIFont *font = [self.font fontWithSize:fontSize];
    
    //adjust for minimum height
    textRect.size.height = MAX(textRect.size.height, font.lineHeight);
    
    //set color
    UIColor *highlightedColor = self.highlightedTextColor ?: self.textColor;
    UIColor *textColor = self.highlighted? highlightedColor: self.textColor;
    textColor = textColor ?: [UIColor clearColor];
    
    //set alignment
    switch (self.textAlignment)
    {
        case NSTextAlignmentCenter:
        {
            textRect.origin.x = contentRect.origin.x + roundf((contentRect.size.width - textRect.size.width) / 2.0f);
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
    (_innerShadowBlur > 0.0f || !CGSizeEqualToSize(_innerShadowOffset, CGSizeZero));
    
    BOOL hasGradient = [_gradientColors count] > 1;
    BOOL needsMask = hasInnerShadow || hasGradient;
    
    CGImageRef alphaMask = NULL;
    if (needsMask)
    {
        //draw mask
        CGContextSaveGState(context);
        [self FXLabel_drawTextInRect:textRect withFont:font];
        CGContextRestoreGState(context);
        
        //create an image mask from what we've drawn so far
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
        [self FXLabel_drawTextInRect:textRect withFont:font];
        CGContextRestoreGState(context);
    }
    else if (!needsMask)
    {
        //just draw the text
        [textColor setFill];
        [self FXLabel_drawTextInRect:textRect withFont:font];
    }
    
    if (needsMask)
    {
        //clip the context
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, 0, contentRect.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextClipToMask(context, contentRect, alphaMask);
        
        if (hasGradient)
        {
            //create array of pre-blended CGColors
            NSMutableArray *colors = [NSMutableArray arrayWithCapacity:[_gradientColors count]];
            for (UIColor *color in _gradientColors)
            {
                UIColor *blended = [self FXLabel_color:color.CGColor blendedWithColor:textColor.CGColor];
                [colors addObject:(__bridge id)blended.CGColor];
            }
            
            //draw gradient
            CGContextSaveGState(context);
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
            CGContextRestoreGState(context);
        }
        else
        {
            //fill text
            [textColor setFill];
            UIRectFill(textRect);
        }
        
        if (hasInnerShadow)
        {
            //generate inverse mask
            UIGraphicsBeginImageContextWithOptions(rect.size, NO, _oversampling);
            CGContextRef shadowContext = UIGraphicsGetCurrentContext();
            [[_innerShadowColor colorWithAlphaComponent:1.0f] setFill];
            UIRectFill(rect);
            CGContextClipToMask(shadowContext, rect, alphaMask);
            CGContextClearRect(shadowContext, rect);
            UIImage *shadowImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            //draw shadow
            CGContextSetShadowWithColor(context, _innerShadowOffset, _innerShadowBlur, _innerShadowColor.CGColor);
            CGContextSetBlendMode(context, kCGBlendModeDarken);
            [shadowImage drawInRect:rect];
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

@end
