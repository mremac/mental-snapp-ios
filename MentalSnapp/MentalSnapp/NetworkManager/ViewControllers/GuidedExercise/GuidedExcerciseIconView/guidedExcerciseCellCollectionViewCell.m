//
//  guidedExcerciseCellCollectionViewCell.m
//  MentalSnapp
//
//  Created by Systango on 29/11/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "guidedExcerciseCellCollectionViewCell.h"

@implementation guidedExcerciseCellCollectionViewCell

-(void)setSelectedViewDetail :(NSInteger )count withAnimation:(BOOL)animate andValue:(CGFloat)value{
    if(self.index != 0 && self.index != count){
        self.guidedExcerciseWidthCinstraint.constant = self.guidedExcerciseHeightCinstraint.constant = (animate)?102: value;
    [self.guidedExcerciseImageButton setBackgroundColor:[UIColor colorWithRed:233.0/255.0 green:101.0/255.0 blue:58.0/255.0 alpha:1.0]];
    [self.guidedExcerciseTitleButton setTitleColor:[UIColor colorWithRed:233.0/255.0 green:101.0/255.0 blue:58.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.guidedExcerciseTitleButton.titleLabel setFont:[UIFont fontWithName:@"Roboto-Bold" size:16]];
    self.guidedExcerciseImageButton.layer.masksToBounds = YES;
    
        if(animate){
            CGFloat radius = (102/2);
            [UIView animateWithDuration:0.1 animations:^{
                [self layoutIfNeeded];
                [self.guidedExcerciseImageButton.layer setCornerRadius:radius];
            } completion:^(BOOL finished) {
                
            }];
        } else {
            [self.guidedExcerciseImageButton.layer setCornerRadius:value/2];
            [self layoutIfNeeded];
        }
    } else {
        [self setDefaultViewDetail];
    }
}

-(void)setDefaultViewDetail {
    [self.guidedExcerciseImageButton setBackgroundColor:[UIColor clearColor]];
    [self.guidedExcerciseTitleButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [self.guidedExcerciseTitleButton setTitle:@"" forState:UIControlStateNormal];
}

-(void)setUnSelectedViewDetail :(NSInteger )count withAnimation:(BOOL)animate andValue:(CGFloat)value{
    if(self.index != 0 && self.index != count){
    self.guidedExcerciseWidthCinstraint.constant = self.guidedExcerciseHeightCinstraint.constant = (animate)?68: value;
    [self.guidedExcerciseImageButton setBackgroundColor:[UIColor colorWithRed:15.0/255.0 green:175.0/255.0 blue:198.0/255.0 alpha:1.0]];
    [self.guidedExcerciseTitleButton setTitleColor:[UIColor colorWithRed:15.0/255.0 green:175.0/255.0 blue:198.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.guidedExcerciseTitleButton.titleLabel setFont:[UIFont fontWithName:@"Roboto" size:13]];
    self.guidedExcerciseImageButton.layer.masksToBounds = YES;
        
        if(animate){
            CGFloat radius = (68/2);
            [UIView animateWithDuration:0.1 animations:^{
                [self layoutIfNeeded];
                [self.guidedExcerciseImageButton.layer setCornerRadius:radius];
            } completion:^(BOOL finished) {
                
            }];
        } else {
            [self.guidedExcerciseImageButton.layer setCornerRadius:value/2];
            [self layoutIfNeeded];
        }
    }else {
        [self setDefaultViewDetail];
    }
}

@end
