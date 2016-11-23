//
//  UILabel+AppFontType.m
//  Skeleton
//
//  Copyright © 2016 Systango. All rights reserved.
//

#import "UILabel+Properties.h"

@implementation UILabel (AppFontType)

- (void)appFontWithMedium
{
    self.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:self.font.pointSize];
}

- (void)appFontWithRegular
{
    self.font = [UIFont fontWithName:@"HelveticaNeue" size:self.font.pointSize];
}

- (void)appFontWithRegularWithSize:(CGFloat)fontSize
{
    self.font = [UIFont fontWithName:@"HelveticaNeue" size:fontSize];
}

- (void)appFontMediumWithSize:(CGFloat)fontSize
{
    self.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:fontSize];
    //self.font = [UIFont fontWithName:@"FreightSansBook" size:fontSize];
}

- (void)appFontWithLight
{
    self.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:self.font.pointSize];
}

- (void)appFontLightWithSize:(CGFloat)fontSize
{
    self.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:fontSize];
    //self.font = [UIFont fontWithName:@"FreightSansBook" size:fontSize];
}

- (void)adjustFontSizeToFit
{
    UIFont *font = self.font;
    CGSize size = self.frame.size;
    CGFloat minFontSize = self.minimumScaleFactor * self.font.pointSize;
    
    for (CGFloat maxSize = self.font.pointSize; maxSize >= minFontSize; maxSize -= 1.f)
    {
        font = [font fontWithSize:maxSize];
        CGSize constraintSize = CGSizeMake(size.width, MAXFLOAT);
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        NSAttributedString *attributedText =[[NSAttributedString alloc] initWithString:self.text attributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle}];
        CGSize labelSize = [attributedText boundingRectWithSize:constraintSize
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil].size;
        if(labelSize.height <= size.height)
        {
            self.font = font;
            [self setNeedsLayout];
            break;
        }
    }
    // set the font to the minimum size anyway
    self.font = font;
    [self setNeedsLayout];
}

- (CGFloat)getLabelboundWidth
{
    CGSize labelSize = CGSizeMake(([ApplicationDelegate.window getWidth]*(([self getWidth]/320)*100)/100), MAXFLOAT);
    NSMutableParagraphStyle *paragraphTitleStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphTitleStyle.lineBreakMode = self.lineBreakMode;
    CGSize titleSize = [self.text boundingRectWithSize:labelSize options: NSStringDrawingUsesLineFragmentOrigin attributes: @{ NSFontAttributeName:self.font, NSParagraphStyleAttributeName: paragraphTitleStyle} context: nil].size;
    
    CGFloat labelWidth = titleSize.width;//AL_MULTILINE_TEXT_HEIGHT(self.text, self.font, labelSize, self.lineBreakMode);
    return (self.text.length > 0? labelWidth : 0);
}

- (CGFloat)getLabelAttributedTextboundWidth
{
    CGSize labelSize = CGSizeMake(self.frame.size.width, MAXFLOAT);
    CGSize titleSize = [self.attributedText boundingRectWithSize:labelSize options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    CGFloat labelWidth = titleSize.width;//AL_MULTILINE_TEXT_HEIGHT(self.text, self.font, labelSize, self.lineBreakMode);
    return (self.text.length > 0? labelWidth : 0);
}


- (CGFloat)getLabelWidth
{
    CGFloat width =  [self.text sizeWithAttributes:@{NSFontAttributeName:self.font}].width;
    
    return width;
}

- (CGFloat)getLabelHeight
{
    CGSize labelSize = CGSizeMake(([ApplicationDelegate.window getWidth]*(([self getWidth]/320)*100)/100), MAXFLOAT);
    
    NSMutableParagraphStyle *paragraphTitleStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphTitleStyle.lineBreakMode = self.lineBreakMode;
    CGSize titleSize = [self.text boundingRectWithSize:labelSize options: NSStringDrawingUsesLineFragmentOrigin attributes: @{ NSFontAttributeName:self.font, NSParagraphStyleAttributeName: paragraphTitleStyle} context: nil].size;
    
    CGFloat labelHeight = titleSize.height;//AL_MULTILINE_TEXT_HEIGHT(self.text, self.font, labelSize, self.lineBreakMode);
    return (self.text.length > 0? labelHeight : 0);
   // return labelHeight;
}

- (CGFloat)getLabelAtrributedTextHeight
{
    CGSize labelSize = CGSizeMake(self.frame.size.width, MAXFLOAT);
    CGSize titleSize = [self.attributedText boundingRectWithSize:labelSize options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    CGFloat labelHeight = titleSize.height;//AL_MULTILINE_TEXT_HEIGHT(self.text, self.font, labelSize, self.lineBreakMode);
    return (self.text.length > 0? labelHeight : 0);
    // return labelHeight;
}

- (CGFloat)defaultHeight
{
    return self.font.pointSize + 4;
}

- (CGRect)boundingRectForCharacterRange:(NSRange)range
{
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:[self attributedText]];
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    [textStorage addLayoutManager:layoutManager];
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:[self bounds].size];
    [layoutManager addTextContainer:textContainer];
    
    NSRange glyphRange;
    
    // Convert the range for glyphs.
    [layoutManager characterRangeForGlyphRange:range actualGlyphRange:&glyphRange];
    
    return [layoutManager boundingRectForGlyphRange:glyphRange inTextContainer:textContainer];
}

- (void)underline
{
    NSMutableAttributedString *string =[[NSMutableAttributedString alloc]initWithString:self.text];
    [string addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleThick] range:NSMakeRange(0, string.length)];//Underline color
    [string addAttribute:NSUnderlineColorAttributeName value:[UIColor appOrangeColor] range:NSMakeRange(0, string.length)];//TextColor
    self.attributedText = string;
}

- (void)backgroundBlack
{
    self.text = [[@"" append:self.text] append:@"  "];
    NSMutableAttributedString *string =
    [[NSMutableAttributedString alloc] initWithString:self.text];
    
    [string addAttribute:NSBackgroundColorAttributeName
              value:[UIColor blackColor]
              range:NSMakeRange(0, string.length)];
    
    self.attributedText = string;
}

- (CGSize)updateAppFontLightWithSize:(CGFloat)fontSize{
    
    return [self updateFonts:[UIFont appFontLightWithSize:fontSize]];
}

- (CGSize)updateFonts:(UIFont *)font
{
    
    CGSize maximumLabelSize = CGSizeMake(self.frame.size.width, MAXFLOAT);
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.text];
    [attributedString addAttribute:NSFontAttributeName
                             value:font
                             range:NSMakeRange(0, self.text.length)];
    
    self.attributedText = attributedString;
    CGSize updatedSize = [self sizeThatFits:maximumLabelSize];
    return updatedSize;
}

@end
