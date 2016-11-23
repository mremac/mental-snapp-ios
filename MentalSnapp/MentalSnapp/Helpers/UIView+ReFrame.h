//
//  UIView+ReFrame.h
//  Skeleton
//
//  Copyright © 2016 Systango. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ReFrame)
- (void)addHorizontalTableView:(UITableView *)tableView target:(id)target;
- (CGFloat)getWidth;
- (CGFloat)getHeight;
- (CGFloat)getXPos;
- (CGFloat)getYPos;
- (CGFloat)getBottomPos;
- (CGFloat)getRightPos;
-(void)setXPos:(CGFloat)xPos;
-(void)setXPos:(CGFloat)xPos widthValue:(CGFloat)widthValue;
-(void)setYPos:(CGFloat)yPos;
-(void)setYPos:(CGFloat)yPos heightValue:(CGFloat)heightValue;
-(void)setWidthValue:(CGFloat)widthValue;
-(void)setHeightValue:(CGFloat)heightValue;
-(void)setOriginPos:(CGFloat)xPos :(CGFloat)yPos;
-(void)setSizeValues:(CGFloat)widthValue heightValue:(CGFloat)heightValue;

-(void)updateXPosWithAddValue:(CGFloat)xPos;
-(void)updateYPosWithAddValue:(CGFloat)yPos;
-(void)updateWidthWithAddValue:(CGFloat)widthValue;
-(void)updateHeightWithAddValue:(CGFloat)heightValue;

-(void)setCenterToView:(UIView *)view;
-(void)setHalfPixelBorder;
- (void)addCollectionView:(UICollectionView *)tableView target:(id)target;

@end
