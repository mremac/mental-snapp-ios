//
//  UIView+ReFrame.m
//  Skeleton
//
//  Copyright © 2016 Systango. All rights reserved.
//

#import "UIView+ReFrame.h"

@implementation UIView (ReFrame)

- (void)addCollectionView:(UICollectionView *)tableView target:(id)target
{
    CGRect frame = tableView.frame;
    
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
   // tableView.transform = CGAffineTransformMakeRotation(-M_PI * 0.5);
    [tableView setFrame:frame];
    
    tableView.backgroundColor = [UIColor whiteColor];
    
    // tableView.alpha = 1.0;
    
   /* tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.separatorColor = [UIColor clearColor];*/
    tableView.tag = 1;
    
    tableView.dataSource = target;
    tableView.delegate = target;
    
    [self addSubview:tableView];
}

- (void)addHorizontalTableView:(UITableView *)tableView target:(id)target
{
    CGRect frame = tableView.frame;
    
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.transform = CGAffineTransformMakeRotation(-M_PI * 0.5);
    [tableView setFrame:frame];
    
    tableView.backgroundColor = [UIColor whiteColor];

    // tableView.alpha = 1.0;
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.separatorColor = [UIColor clearColor];
    tableView.tag = 1;
    
    tableView.dataSource = target;
    tableView.delegate = target;
    
    [self addSubview:tableView];
}

- (CGFloat)getWidth
{
    return self.frame.size.width;
}

- (CGFloat)getHeight
{
    return self.frame.size.height;
}

- (CGFloat)getXPos
{
    return self.frame.origin.x;
}

- (CGFloat)getYPos
{
    return self.frame.origin.y;
}

- (CGFloat)getBottomPos
{
    return [self getYPos] + [self getHeight];
}

- (CGFloat)getRightPos
{
    return [self getXPos] + [self getWidth];
}

-(void)setXPos:(CGFloat)xPos
{
    CGRect frame = self.frame;
    frame.origin.x = xPos;
    self.frame = frame;
}

-(void)setXPos:(CGFloat)xPos widthValue:(CGFloat)widthValue
{
    CGRect frame = self.frame;
    frame.origin.x = xPos;
    frame.size.width = widthValue;
    self.frame = frame;
}

-(void)setYPos:(CGFloat)yPos
{
    CGRect frame = self.frame;
    frame.origin.y = yPos;
    self.frame = frame;
}

-(void)setYPos:(CGFloat)yPos heightValue:(CGFloat)heightValue
{
    CGRect frame = self.frame;
    frame.origin.y = yPos;
    frame.size.height = heightValue;
    self.frame = frame;
}

-(void)setWidthValue:(CGFloat)widthValue
{
    CGRect frame = self.frame;
    frame.size.width = widthValue;
    self.frame = frame;
}

-(void)setHeightValue:(CGFloat)heightValue
{
    CGRect frame = self.frame;
    frame.size.height = heightValue;
    self.frame = frame;
}

-(void)setOriginPos:(CGFloat)xPos :(CGFloat)yPos
{
    CGRect frame = self.frame;
    frame.origin.x = xPos;
    frame.origin.y = yPos;
    self.frame = frame;
}

-(void)setSizeValues:(CGFloat)widthValue heightValue:(CGFloat)heightValue
{
    CGRect frame = self.frame;
    frame.size.width = widthValue;
    frame.size.height = heightValue;
    self.frame = frame;
}

-(void)updateXPosWithAddValue:(CGFloat)xPos
{
    CGRect frame = self.frame;
    frame.origin.x += xPos;
    self.frame = frame;
}

-(void)updateYPosWithAddValue:(CGFloat)yPos
{
    CGRect frame = self.frame;
    frame.origin.y += yPos;
    self.frame = frame;
}

-(void)updateWidthWithAddValue:(CGFloat)widthValue
{
    CGRect frame = self.frame;
    frame.size.width += widthValue;
    self.frame = frame;
}

-(void)updateHeightWithAddValue:(CGFloat)heightValue
{
    CGRect frame = self.frame;
    frame.size.height += heightValue;
    self.frame = frame;
}

-(void)setCenterToView:(UIView *)view
{
    //TODO
}

-(void)setHalfPixelBorder
{
    self.layer.borderWidth= 0.50;
    self.layer.borderColor = [self.backgroundColor CGColor];
    [self setBackgroundColor:[UIColor clearColor]];
}



@end
