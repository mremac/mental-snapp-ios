//
//  LCInfoView.m
//  Classes
//
//  Created by Marcel Ruegenberg on 19.11.09.
//  Copyright 2009 Dustlab. All rights reserved.
//

#import "LCInfoView.h"
#import "UIKit+DrawingHelpers.h"


@interface LCInfoView ()

- (void)recalculateFrame;

@end


@implementation LCInfoView

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {		
        UIFont *fatFont = [UIFont fontWithName:@"Roboto" size:10];
        self.infoLabel = [[UILabel alloc] init]; self.infoLabel.font = fatFont;
        self.infoLabel.backgroundColor = [UIColor clearColor]; self.infoLabel.textColor = [UIColor colorWithRed:61.0/255.0 green:61.0/255.0 blue:61.0/255.0 alpha:1.0];
        self.infoLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        //self.infoLabel.shadowColor = [UIColor blackColor];
        //self.infoLabel.shadowOffset = CGSizeMake(0, -1);
        self.infoLabel.textAlignment = NSTextAlignmentCenter;
        [self.infoLabel setNumberOfLines:3];
        [self addSubview:self.infoLabel];
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (id)init {
	if((self = [self initWithFrame:CGRectZero])) {
		;
	}
	return self;
}

#define TOP_BOTTOM_MARGIN 5
#define LEFT_RIGHT_MARGIN 15
#define SHADOWSIZE 3
#define SHADOWBLUR 5
#define HOOK_SIZE 8

void CGContextAddRoundedRectWithHookSimple(CGContextRef c, CGRect rect, CGFloat radius) {
	//eventRect must be relative to rect.
	CGFloat hookSize = HOOK_SIZE;
	CGContextAddArc(c, rect.origin.x + radius, rect.origin.y + radius, radius, M_PI, M_PI * 1.5, 0); //upper left corner
	CGContextAddArc(c, rect.origin.x + rect.size.width - radius, rect.origin.y + radius, radius, M_PI * 1.5, M_PI * 2, 0); //upper right corner
	CGContextAddArc(c, rect.origin.x + rect.size.width - radius, rect.origin.y + rect.size.height - radius, radius, M_PI * 2, M_PI * 0.5, 0);
    {
		CGContextAddLineToPoint(c, rect.origin.x + rect.size.width / 2 + hookSize, rect.origin.y + rect.size.height);
		CGContextAddLineToPoint(c, rect.origin.x + rect.size.width / 2, rect.origin.y + rect.size.height + hookSize);
		CGContextAddLineToPoint(c, rect.origin.x + rect.size.width / 2 - hookSize, rect.origin.y + rect.size.height);
	}
	CGContextAddArc(c, rect.origin.x + radius, rect.origin.y + rect.size.height - radius, radius, M_PI * 0.5, M_PI, 0);
	CGContextAddLineToPoint(c, rect.origin.x, rect.origin.y + radius);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self sizeToFit];
    
    [self recalculateFrame];
    
    [self.infoLabel sizeToFit];
    self.infoLabel.frame = CGRectMake(self.bounds.origin.x + 7, self.bounds.origin.y + 2, (self.frame.size.width<50)?50:self.frame.size.width-20, self.frame.size.height-20);
}

- (CGSize)sizeThatFits:(CGSize)size {
    // TODO: replace with new text APIs in iOS 7 only version
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    CGSize s = [self.infoLabel.text sizeWithFont:self.infoLabel.font];
#pragma clang diagnostic pop
    s.height += 15;
    s.height += SHADOWSIZE;
    
    s.width += 2 * SHADOWSIZE + 7;
    s.width = MAX(s.width, HOOK_SIZE * 2 + 2 * SHADOWSIZE + 10);
    
    return s;
}

- (void)drawRect:(CGRect)rect {
	CGContextRef c = UIGraphicsGetCurrentContext();

	CGRect theRect = self.bounds;
	//passe x oder y Position sowie Hoehe oder Breite an, je nachdem, wo der Hook sitzt.
	theRect.size.height -= SHADOWSIZE * 2;
	theRect.origin.x += SHADOWSIZE;
	theRect.size.width -= SHADOWSIZE * 2;
    theRect.size.height -= SHADOWSIZE * 2;
    
    
    [[UIColor colorWithWhite:1.0 alpha:1.0] set];
	CGContextSetAlpha(c, 1.0);

	CGContextSaveGState(c);
	
    CGContextSetShadow(c, CGSizeMake(0.0, SHADOWSIZE), SHADOWBLUR);
	
	CGContextBeginPath(c);
    CGContextAddRoundedRectWithHookSimple(c, theRect, 7);
	CGContextFillPath(c);
	
    [[UIColor whiteColor] set];
	theRect.origin.x += 1;
	theRect.origin.y += 1;
	theRect.size.width -= 2;
	theRect.size.height = theRect.size.height / 2 + 1;
    
	CGContextSetAlpha(c, 0.2);
    CGContextFillRoundedRect(c, theRect, 6);
}

#define MAX_WIDTH 400
// calculate own frame to fit within parent frame and be large enough to hold the event.
- (void)recalculateFrame {
    CGRect theFrame = self.frame;
    theFrame.size.width = MIN(MAX_WIDTH, theFrame.size.width);
    
    CGRect theRect = self.frame; theRect.origin = CGPointZero;
    if(theFrame.size.width>120){
        theFrame.size.width =120;
    }
    if(theFrame.size.width<60){
        theFrame.size.width =60;
    }
    CGRect frame =  self.infoLabel.frame;
    frame.size.width = (theFrame.size.width<50)?50:theFrame.size.width-20;
    [self.infoLabel setFrame:frame];
    CGFloat labelHeight = [self.infoLabel getLabelAtrributedTextHeight];
    frame.size.height = labelHeight;
    [self.infoLabel setFrame:frame];
    theFrame.size.height = (labelHeight>75)?75:((labelHeight<75)?75:labelHeight);

    {
        theFrame.origin.y = self.tapPoint.y - theFrame.size.height + 2 * SHADOWSIZE + 1;
        theFrame.origin.x = round(self.tapPoint.x - ((theFrame.size.width - 2 * SHADOWSIZE)) / 2.0);
    }
    
    self.frame = theFrame;
}

@end
