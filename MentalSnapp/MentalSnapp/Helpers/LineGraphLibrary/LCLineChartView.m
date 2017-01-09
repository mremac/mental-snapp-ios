//
//  LCLineChartView.m
//
//
//  Created by Marcel Ruegenberg on 02.08.13.
//
//

#import "LCLineChartView.h"
#import "LCLegendView.h"
#import "LCInfoView.h"
#import "Util.h"

@interface LCLineChartDataItem ()

@property (readwrite) double x; // should be within the x range
@property (readwrite) double y; // should be within the y range
@property (readwrite) NSString *xLabel; // label to be shown on the x axis
@property (readwrite) NSString *dataLabel; // label to be shown directly at the data item
@property (readwrite) id dataObject;

- (id)initWithhX:(double)x y:(double)y xLabel:(NSString *)xLabel dataLabel:(NSString *)dataLabel;

@end

@implementation LCLineChartDataItem

- (id)initWithhX:(double)x y:(double)y xLabel:(NSString *)xLabel dataLabel:(NSString *)dataLabel withData:(id)dataObject {
    if((self = [super init])) {
        self.x = x;
        self.y = y;
        self.xLabel = xLabel;
        self.dataLabel = dataLabel;
        self.dataObject = dataObject;
    }
    return self;
}


+ (LCLineChartDataItem *)dataItemWithX:(double)x y:(double)y xLabel:(NSString *)xLabel dataLabel:(NSString *)dataLabel withData:(id)dataObject{
    return [[LCLineChartDataItem alloc] initWithhX:x y:y xLabel:xLabel dataLabel:dataLabel withData:dataObject];
}

@end



@implementation LCLineChartData

- (id)init {
  self = [super init];
  if(self) {
    self.drawsDataPoints = YES;
  }
  return self;
}

@end



@interface LCLineChartView ()

@property LCLegendView *legendView;
@property LCInfoView *infoView;
@property UIView *currentPosView;
@property UILabel *xAxisLabel;

- (BOOL)drawsAnyData;

@property LCLineChartData *selectedData;
@property NSUInteger selectedIdx;

@end


#define X_AXIS_SPACE 15
#define PADDING 10


@implementation LCLineChartView
@synthesize data=_data;

- (void)setDefaultValues {
    CGFloat extraSpace10 = floorf((self.superview.frame.size.width*2.7)/100);
    self.currentPosView = [[UIView alloc] initWithFrame:CGRectMake(extraSpace10, extraSpace10, 1 / self.contentScaleFactor, 50)];
    self.currentPosView.backgroundColor = [UIColor clearColor];
    self.currentPosView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.currentPosView.alpha = 0.0;
    [self addSubview:self.currentPosView];

    self.legendView = [[LCLegendView alloc] init];
    self.legendView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.legendView.backgroundColor = [UIColor clearColor];
   // [self addSubview:self.legendView];

    self.axisLabelColor = [UIColor darkGrayColor];

    self.xAxisLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    self.xAxisLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    self.xAxisLabel.font = [UIFont boldSystemFontOfSize:8];
    self.xAxisLabel.textColor = self.axisLabelColor;
    self.xAxisLabel.textAlignment = NSTextAlignmentCenter;
    self.xAxisLabel.alpha = 0.0;
    self.xAxisLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:self.xAxisLabel];

    self.backgroundColor = [UIColor clearColor];
    self.scaleFont = [UIFont systemFontOfSize:8];
    self.xScaleFont = [UIFont systemFontOfSize:8];

    self.autoresizesSubviews = YES;
    self.contentMode = UIViewContentModeRedraw;

    self.drawsDataPoints = YES;
    self.drawsDataLines  = YES;
    
    self.selectedIdx = INT_MAX;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if((self = [super initWithCoder:aDecoder])) {
        [self setDefaultValues];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if((self = [super initWithFrame:frame])) {
        [self setDefaultValues];
    }
    return self;
}

- (void)setAxisLabelColor:(UIColor *)axisLabelColor {
    if(axisLabelColor != _axisLabelColor) {
        [self willChangeValueForKey:@"axisLabelColor"];
        _axisLabelColor = axisLabelColor;
        self.xAxisLabel.textColor = axisLabelColor;
        [self didChangeValueForKey:@"axisLabelColor"];
    }
}

- (void)showLegend:(BOOL)show animated:(BOOL)animated {
    if(! animated) {
        self.legendView.alpha = show ? 1.0 : 0.0;
        return;
    }

    [UIView animateWithDuration:0.3 animations:^{
        self.legendView.alpha = show ? 1.0 : 0.0;
    }];
}

- (void)layoutSubviews {
    [self.legendView sizeToFit];
    CGFloat extraSpace10 = floorf((self.superview.frame.size.width*2.7)/100);
    CGFloat extraSpace15 = floorf((self.superview.frame.size.width*4)/100);
    CGRect r = self.legendView.frame;
    r.origin.x = self.bounds.size.width - self.legendView.frame.size.width - 3 - extraSpace10;
    r.origin.y = 3 + extraSpace10;
    self.legendView.frame = r;

    r = self.currentPosView.frame;
    CGFloat h = self.bounds.size.height;
    r.size.height = h - 2 * extraSpace10 - extraSpace15;
    self.currentPosView.frame = r;

    [self.xAxisLabel sizeToFit];
    r = self.xAxisLabel.frame;
    r.origin.y = self.bounds.size.height - extraSpace10 - extraSpace10 + 2;
    self.xAxisLabel.frame = r;

    [self bringSubviewToFront:self.legendView];
}

- (void)setData:(NSArray *)data {
    if(data != _data) {
        NSMutableArray *titles = [NSMutableArray arrayWithCapacity:[data count]];
        NSMutableDictionary *colors = [NSMutableDictionary dictionaryWithCapacity:[data count]];
        for(LCLineChartData *dat in data) {
            NSString *key = dat.title;
            if(key == nil) key = @"";
            [titles addObject:key];
            [colors setObject:dat.color forKey:key];
        }
        self.legendView.titles = titles;
        self.legendView.colors = colors;
        self.selectedData = nil;
        self.selectedIdx = INT_MAX;

        _data = data;

        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGFloat extraSpace10 = floorf((self.superview.frame.size.width*2.7)/100);
    CGFloat extraSpace5 = floorf((self.superview.frame.size.width*1.4)/100);
    CGFloat extraSpace15 = floorf((self.superview.frame.size.width*4)/100);
    CGFloat availableHeight = self.bounds.size.height - 2 * extraSpace10 - extraSpace15;

    CGFloat availableWidth = self.bounds.size.width - 2 * extraSpace10 - self.yAxisLabelsWidth;
    CGFloat xStart = extraSpace5 + self.yAxisLabelsWidth+floorf((self.superview.frame.size.width*4)/100);
    CGFloat yStart = extraSpace10;

    static CGFloat dashedPattern[] = {4,0};

    // draw scale and horizontal lines
    CGFloat heightPerStep = self.ySteps == nil || [self.ySteps count] <= 1 ? availableHeight : (availableHeight / ([self.ySteps count] - 1));

    NSUInteger i = 0;
    CGContextSaveGState(c);
    CGContextSetLineWidth(c, 1.0);
    NSUInteger yCnt = [self.ySteps count];
    for(NSString *step in self.ySteps) {
        [self.axisLabelColor set];
        CGFloat h = [self.scaleFont lineHeight];
        CGFloat y = yStart + heightPerStep * (yCnt - 1 - i);
        // TODO: replace with new text APIs in iOS 7 only version
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [step drawInRect:CGRectMake(yStart, y - h / 2+extraSpace10, self.yAxisLabelsWidth - extraSpace5, h) withFont:self.scaleFont lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentRight];
#pragma clagn diagnostic pop

        [[UIColor lightGrayColor] set];
        CGContextSetLineDash(c, 0, dashedPattern, 2);
        CGContextMoveToPoint(c, xStart-extraSpace5, round(y+extraSpace10) + 0.5);
        CGContextAddLineToPoint(c, self.bounds.size.width, round(y+extraSpace10) + 0.5);
        CGContextStrokePath(c);

        i++;
    }
    CGContextSetLineDash(c, 0, dashedPattern, 2);
    CGContextMoveToPoint(c, xStart-extraSpace5, 0);
    CGContextAddLineToPoint(c, self.bounds.size.width, round(0) + 0.5);
    CGContextStrokePath(c);

    NSUInteger j = 1;
    CGFloat value = floorf(([self.superview frame].size.width * 14.0)/100);
    CGFloat xValue = 0;

    CGContextSaveGState(c);
    CGContextSetLineWidth(c, 1.0);
    //NSUInteger x_Cnt = [self.xSteps count];
    for(NSString *step in self.xSteps) {
        [self.axisLabelColor set];
        CGFloat h = [self.xScaleFont lineHeight];
        //CGFloat x = 0;
        // TODO: replace with new text APIs in iOS 7 only version
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [step drawInRect:CGRectMake(j*value, self.bounds.size.height - extraSpace10, self.xAxisLabelsWidth, h) withFont:self.xScaleFont lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentCenter];
#pragma clagn diagnostic pop
        
        if(j>1){
            value -=1;
        }
        
        [[UIColor lightGrayColor] set];
        CGContextSetLineDash(c, 0, dashedPattern, 2);
        CGContextMoveToPoint(c, j*value, 0);
        CGContextAddLineToPoint(c, j*value, self.bounds.size.height-(extraSpace10+extraSpace5));
        CGContextStrokePath(c);
        xValue = j*value;
        CGFloat maxwidth = (self.frame.size.width-(xStart))/self.xSteps.count;
        value = (self.xAxisLabelsWidth < maxwidth)?maxwidth:self.xAxisLabelsWidth;
        if(j>=1){
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(xValue, 0, (j==self.xSteps.count)?value+extraSpace5:value+((j==1)?extraSpace5:0), self.bounds.size.height-(extraSpace10+extraSpace5))];
            [view setTag:j+100];
            if(_selectedWeek>0 && (_selectedWeek+100) == view.tag){
                _selectedView = view;
                [view setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.8]];
            }
            //[self.superview addSubview:view];
            [self.superview insertSubview:view atIndex:0];
        }
        j++;
    }

    CGContextSetLineDash(c, 0, dashedPattern, 2);
    CGContextMoveToPoint(c, self.frame.size.width, -0.5);
    CGContextAddLineToPoint(c, self.bounds.size.width, round(self.bounds.size.height-(floorf((self.superview.frame.size.width*4.8)/100))));
    CGContextStrokePath(c);
    
    NSUInteger xCnt = self.xStepsCount;
    if(xCnt > 1) {
        CGFloat widthPerStep = availableWidth / (xCnt - 1);

        [[UIColor lightGrayColor] set];
        for(NSUInteger i = 0; i < xCnt; ++i) {
            CGFloat x = xStart + widthPerStep * (xCnt - 1 - i);

            [[UIColor lightGrayColor] set];
            CGContextMoveToPoint(c, round(x) + 0.5, extraSpace10);
            CGContextAddLineToPoint(c, round(x) + 0.5, yStart + availableHeight);
            CGContextStrokePath(c);
        }
    }

    CGContextRestoreGState(c);


    if (!self.drawsAnyData) {
        NSLog(@"You configured LineChartView to draw neither lines nor data points. No data will be visible. This is most likely not what you wanted. (But we aren't judging you, so here's your chart background.)");
    } // warn if no data will be drawn

    CGFloat yRangeLen = self.yMax - self.yMin;
    if(yRangeLen == 0) yRangeLen = 1;
    for(LCLineChartData *data in self.data) {
        if (self.drawsDataLines) {
            double xRangeLen = data.xMax - data.xMin;
            if(xRangeLen == 0) xRangeLen = 1;
            if(data.itemCount >= 2) {
                LCLineChartDataItem *datItem = data.getData(0);
                CGMutablePathRef path = CGPathCreateMutable();
                CGFloat prevX = xStart + round(((datItem.x - data.xMin) / xRangeLen) * availableWidth);
                CGFloat prevY = yStart + round((1.0 - (datItem.y - self.yMin) / yRangeLen) * availableHeight);
                CGPathMoveToPoint(path, NULL, prevX, prevY);
                for(NSUInteger i = 1; i < data.itemCount; ++i) {
                    LCLineChartDataItem *datItem = data.getData(i);
                    CGFloat x = xStart + round(((datItem.x - data.xMin) / xRangeLen) * availableWidth);
                    CGFloat y = yStart + round((1.0 - (datItem.y - self.yMin) / yRangeLen) * availableHeight);
                    CGFloat xDiff = x - prevX;
                    CGFloat yDiff = y - prevY;
                    
                    if(xDiff != 0) {
                        CGFloat xSmoothing = self.smoothPlot ? MIN(30,xDiff) : 0;
                        CGFloat ySmoothing = 0.5;
                        CGFloat slope = yDiff / xDiff;
                        CGPoint controlPt1 = CGPointMake(prevX + xSmoothing, prevY + ySmoothing * slope * xSmoothing);
                        CGPoint controlPt2 = CGPointMake(x - xSmoothing, y - ySmoothing * slope * xSmoothing);
                        CGPathAddCurveToPoint(path, NULL, controlPt1.x, controlPt1.y, controlPt2.x, controlPt2.y, x, y);
                    }
                    else {
                        CGPathAddLineToPoint(path, NULL, x, y);
                    }
                    prevX = x;
                    prevY = y;
                }
                

                CGContextAddPath(c, path);
                CGContextSetStrokeColorWithColor(c, [self.backgroundColor CGColor]);
                CGContextSetLineWidth(c, 5);
                CGContextStrokePath(c);

                CGContextAddPath(c, path);
                CGContextSetStrokeColorWithColor(c, [data.color CGColor]);
                CGContextSetLineWidth(c, 3);
                CGContextStrokePath(c);

                CGPathRelease(path);
            }
        } // draw actual chart data
        if (self.drawsDataPoints) {
          if (data.drawsDataPoints) {
            double xRangeLen = data.xMax - data.xMin;
            if(xRangeLen == 0) xRangeLen = 1;
            for(NSUInteger i = 0; i < data.itemCount; ++i) {
                LCLineChartDataItem *datItem = data.getData(i);
                CGFloat xVal = xStart + round((xRangeLen == 0 ? 0.5 : ((datItem.x - data.xMin) / xRangeLen)) * availableWidth);
                CGFloat yVal = yStart + round((1.0 - (datItem.y - self.yMin) / yRangeLen) * availableHeight);
                [self.backgroundColor setFill];
                CGContextFillEllipseInRect(c, CGRectMake(xVal - 5.5, yVal - 5.5, 11, 11));
                CGSize result = [[UIScreen mainScreen] bounds].size;
                data.color = [Util getMoodColor:(round(yVal/heightPerStep)+((result.width >= 414)?0:1))];
                [[UIColor clearColor] setFill];
                
                CGContextFillEllipseInRect(c, CGRectMake(xVal - 10, yVal - 10, 35, 35));
                {
                    CGFloat brightness;
                    CGFloat r,g,b,a;
                    if(CGColorGetNumberOfComponents([data.color CGColor]) < 3)
                        [data.color getWhite:&brightness alpha:&a];
                    else {
                        [data.color getRed:&r green:&g blue:&b alpha:&a];
                        brightness = 0.299 * r + 0.587 * g + 0.114 * b; // RGB ~> Luma conversion
                    }
                   // if(brightness <= 0.68) // basically arbitrary, but works well for test cases
                        [data.color setFill];
//                    else
//                        [[UIColor blackColor] setFill];
                }
                CGContextFillEllipseInRect(c, CGRectMake(xVal - 5, yVal - 7, 15, 15));
            } // for
          } // data - draw data points
        } // draw data points
    }
}

- (void)showIndicatorForTouch:(UITouch *)touch {
    if(! self.infoView) {
        self.infoView = [[LCInfoView alloc] init];
        [self addSubview:self.infoView];
    }
    CGFloat extraSpace15 = floorf((self.superview.frame.size.width*4)/100);
    CGFloat extraSpace10 = floorf((self.superview.frame.size.width*2.7)/100);
    CGFloat extraSpace5 = floorf((self.superview.frame.size.width*1.4)/100);

    CGPoint pos = [touch locationInView:self];
    CGFloat xStart = extraSpace10 + self.yAxisLabelsWidth+extraSpace15;
    CGFloat yStart = extraSpace10;
    CGFloat yRangeLen = self.yMax - self.yMin;
    if(yRangeLen == 0) yRangeLen = 1;
    CGFloat xPos = pos.x - xStart;
    CGFloat yPos = pos.y - yStart;
    CGFloat availableWidth = self.bounds.size.width - 2 * extraSpace10 - self.yAxisLabelsWidth;
    CGFloat availableHeight = self.bounds.size.height - 2 * extraSpace10 - extraSpace15;

    LCLineChartDataItem *closest = nil;
    LCLineChartData *closestData = nil;
    NSUInteger closestIdx = INT_MAX;
    double minDist = DBL_MAX;
    double minDistY = DBL_MAX;
    CGPoint closestPos = CGPointZero;
    
    for(LCLineChartData *data in self.data) {
        double xRangeLen = data.xMax - data.xMin;
        // note: if necessary, could use binary search here to speed things up
        for(NSUInteger i = 0; i < data.itemCount; ++i) {
            LCLineChartDataItem *datItem = data.getData(i);
            
            CGFloat xVal = round((xRangeLen == 0 ? 0.0 : ((datItem.x - data.xMin) / xRangeLen)) * availableWidth);
            CGFloat yVal = round((1.0 - (datItem.y - self.yMin) / yRangeLen) * availableHeight);
            double dist = fabs(xVal - xPos);
            double distY = fabs(yVal - yPos);
            if((dist < 5 && distY < 5) || (dist == 5 && distY < 5)) {
                minDist = dist;
                minDistY = distY;
                closest = datItem;
                closestData = data;
                closestIdx = i;
                closestPos = CGPointMake(xStart + xVal - 3, yStart + yVal - 7);
            }
        }
    }
    
    if(closest == nil || (closestData == self.selectedData && closestIdx == self.selectedIdx)) {
        if(self.lineDelegate && [self.lineDelegate respondsToSelector:@selector(didSelectWeekSection:)]){
            int value = (int)(self.bounds.size.width-(xStart))/self.xSteps.count;
            value  = (pos.x+extraSpace5)/value;
            if(value == 0) {
                [self hideIndicator];
                return;
            }
            [_selectedView setBackgroundColor:[UIColor clearColor]];
            _selectedView = [self.superview viewWithTag:value+100];
            _selectedWeek = value;
            [_selectedView setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.8]];
            [self.lineDelegate didSelectWeekSection:value];
        }
        [self hideIndicator];
        return;
    }
    
    self.selectedData = closestData;
    self.selectedIdx = closestIdx;
    
    NSString *a =closest.dataLabel;
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:closest.dataLabel];
    NSRange foundRange = [a rangeOfString:@"#"];
    while (foundRange.location != NSNotFound)
    {
        [att addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:15.0/255.0 green:175.0/255.0 blue:198.0/255.0 alpha:1.0] range:foundRange];
        
        NSRange rangeToSearch;
        rangeToSearch.location = foundRange.location + foundRange.length;
        rangeToSearch.length = a.length - rangeToSearch.location;
        foundRange = [a rangeOfString:@"#" options:0 range:rangeToSearch];
    }
    
    self.infoView.infoLabel.attributedText = att;
    self.infoView.tapPoint = closestPos;
    [self.infoView sizeToFit];
    [self.infoView setNeedsLayout];
    [self.infoView setNeedsDisplay];

    if(self.currentPosView.alpha == 0.0) {
        CGRect r = self.currentPosView.frame;
        r.origin.x = closestPos.x + 3 - 1;
        self.currentPosView.frame = r;
    }

    [UIView animateWithDuration:0.1 animations:^{
        self.infoView.alpha = 1.0;
        self.currentPosView.alpha = 1.0;
        self.xAxisLabel.alpha = 1.0;

        CGRect r = self.currentPosView.frame;
        r.origin.x = closestPos.x + 3 - 1;
        self.currentPosView.frame = r;

        self.xAxisLabel.text = closest.xLabel;
        if(self.xAxisLabel.text != nil) {
            [self.xAxisLabel sizeToFit];
            r = self.xAxisLabel.frame;
            r.origin.x = round(closestPos.x - r.size.width / 2);
            self.xAxisLabel.frame = r;
        }
    }];
    
    if(self.selectedItemCallback != nil) {
        self.selectedItemCallback(closestData, closestIdx, closestPos);
    }
}


- (void)showDoubleTapForTouch:(UITouch *)touch {
    CGFloat extraSpace15 = floorf((self.superview.frame.size.width*4)/100);
    CGFloat extraSpace10 = floorf((self.superview.frame.size.width*2.7)/100);
    //CGFloat extraSpace5 = floorf((self.superview.frame.size.width*1.4)/100);

    CGPoint pos = [touch locationInView:self];
    CGFloat xStart = extraSpace10 + self.yAxisLabelsWidth+extraSpace15;
    CGFloat yStart = extraSpace10;
    CGFloat yRangeLen = self.yMax - self.yMin;
    if(yRangeLen == 0) yRangeLen = 1;
    CGFloat xPos = pos.x - xStart;
    CGFloat yPos = pos.y - yStart;
    CGFloat availableWidth = self.bounds.size.width - 2 * extraSpace10 - self.yAxisLabelsWidth;
    CGFloat availableHeight = self.bounds.size.height - 2 * extraSpace10 - extraSpace15;
    
    LCLineChartDataItem *closest = nil;
    LCLineChartData *closestData = nil;
    NSUInteger closestIdx = INT_MAX;
    double minDist = DBL_MAX;
    double minDistY = DBL_MAX;
    CGPoint closestPos = CGPointZero;
    
    for(LCLineChartData *data in self.data) {
        double xRangeLen = data.xMax - data.xMin;
        // note: if necessary, could use binary search here to speed things up
        for(NSUInteger i = 0; i < data.itemCount; ++i) {
            LCLineChartDataItem *datItem = data.getData(i);
            
            CGFloat xVal = round((xRangeLen == 0 ? 0.0 : ((datItem.x - data.xMin) / xRangeLen)) * availableWidth);
            CGFloat yVal = round((1.0 - (datItem.y - self.yMin) / yRangeLen) * availableHeight);
            double dist = fabs(xVal - xPos);
            double distY = fabs(yVal - yPos);
            if((dist < 4 && distY < 4) || (dist == 4 && distY < 4)) {
                minDist = dist;
                minDistY = distY;
                closest = datItem;
                closestData = data;
                closestIdx = i;
                closestPos = CGPointMake(xStart + xVal - 3, yStart + yVal - 7);
            }
        }
    }
    
    if(closest == nil || (closestData == self.selectedData && closestIdx == self.selectedIdx)) {
        return;
    }
    
    if(self.lineDelegate && [self.lineDelegate respondsToSelector:@selector(didDoubleTapSection:)]){
        [self.lineDelegate didDoubleTapSection:closest.dataObject];
    }
}


- (void)hideIndicator {
    if(self.deselectedItemCallback)
        self.deselectedItemCallback();
    
    self.selectedData = nil;
    
    [UIView animateWithDuration:0.1 animations:^{
        self.infoView.alpha = 0.0;
        self.currentPosView.alpha = 0.0;
        self.xAxisLabel.alpha = 0.0;
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    NSUInteger numTaps = [[touches anyObject] tapCount];
    if (numTaps < 2) {
        [self showIndicatorForTouch:[touches anyObject]];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    NSUInteger numTaps = [[touches anyObject] tapCount];
    if (numTaps < 2) {
        [self showIndicatorForTouch:[touches anyObject]];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSUInteger numTaps = [[touches anyObject] tapCount];
    if (numTaps < 2) {
        //[self hideIndicator];
    } else if(numTaps == 2){
        [self hideIndicator];
        [self showDoubleTapForTouch:[touches anyObject]];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    NSUInteger numTaps = [[touches anyObject] tapCount];
    if (numTaps < 2) {
       // [self hideIndicator];
    }
}


#pragma mark Helper methods

- (BOOL)drawsAnyData {
    return self.drawsDataPoints || self.drawsDataLines;
}

// TODO: This should really be a cached value. Invalidated iff ySteps changes.
- (CGFloat)yAxisLabelsWidth {
    double maxV = 0;
    CGFloat extraSpace10 = floorf((self.superview.frame.size.width*2.7)/100);
    for(NSString *label in self.ySteps) {
        CGSize labelSize = [label sizeWithFont:self.scaleFont];
        if(labelSize.width > maxV) maxV = labelSize.width;
    }
    return maxV + extraSpace10;
}

- (CGFloat)xAxisLabelsWidth {
    double maxV = 0;
    CGFloat extraSpace10 = floorf((self.superview.frame.size.width*2.7)/100);
    for(NSString *label in self.xSteps) {
        CGSize labelSize = [label sizeWithFont:self.xScaleFont];
        if(labelSize.width > maxV) maxV = labelSize.width;
    }
    return maxV + extraSpace10;
}

@end
