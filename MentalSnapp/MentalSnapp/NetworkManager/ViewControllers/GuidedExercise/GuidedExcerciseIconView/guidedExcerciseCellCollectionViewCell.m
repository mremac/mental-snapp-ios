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
    self.guidedExcerciseWidthCinstraint.constant = self.guidedExcerciseHeightCinstraint.constant = (animate)?KGrowValue: value;
    [self.guidedExcerciseImageButton setBackgroundColor:[UIColor colorWithRed:233.0/255.0 green:101.0/255.0 blue:58.0/255.0 alpha:1.0]];
        
    [self.guidedExcerciseTitleLabel setTextColor:[UIColor colorWithRed:233.0/255.0 green:101.0/255.0 blue:58.0/255.0 alpha:1.0]];
    [self.guidedExcerciseTitleLabel setFont:[UIFont fontWithName:@"Roboto-Bold" size:15]];
    self.guidedExcerciseImageButton.layer.masksToBounds = YES;
        
    [self.guidedExcerciseTitleLabel setText:@""];
    [self.guidedExcerciseImageButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        if (1 != self.index){
            [self.guidedExcerciseTitleLabel setText:(self.excercise)?self.excercise.excerciseName:@""];
            if([NSURL URLWithString:self.excercise.excerciseCoverURL]){
                [self.guidedExcerciseImageButton sd_setImageWithURL:[NSURL URLWithString:(self.excercise)?self.excercise.excerciseCoverURL:@""] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"defaultExcerciseImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                }];
            }else {
                [self.guidedExcerciseImageButton setImage:[UIImage imageNamed:@"defaultExcerciseImage"] forState:UIControlStateNormal];
            }

        } else {
            [self.guidedExcerciseTitleLabel setText:@"Free form"];
            [self.guidedExcerciseImageButton setImage:[UIImage imageNamed:@"chart_large"] forState:UIControlStateNormal];
        }
        
        if(animate){
            CGFloat radius = (KGrowValue/2);
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
    [self.guidedExcerciseTitleLabel setTextColor:[UIColor clearColor]];
    [self.guidedExcerciseTitleLabel setText:@""];
    [self.guidedExcerciseImageButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
}

-(void)setUnSelectedViewDetail :(NSInteger )count withAnimation:(BOOL)animate andValue:(CGFloat)value{
    if(self.index != 0 && self.index != count){
        self.guidedExcerciseWidthCinstraint.constant = self.guidedExcerciseHeightCinstraint.constant = (animate)?KShrinkValue: value;
        [self.guidedExcerciseImageButton setBackgroundColor:[UIColor colorWithRed:15.0/255.0 green:175.0/255.0 blue:198.0/255.0 alpha:1.0]];
        [self.guidedExcerciseTitleLabel setTextColor:[UIColor colorWithRed:15.0/255.0 green:175.0/255.0 blue:198.0/255.0 alpha:1.0]];
        [self.guidedExcerciseTitleLabel setFont:[UIFont fontWithName:@"Roboto" size:13]];
        [self.guidedExcerciseTitleLabel setMinimumScaleFactor:0.5];
        self.guidedExcerciseImageButton.layer.masksToBounds = YES;
        
        [self.guidedExcerciseTitleLabel setText:@""];
        [self.guidedExcerciseImageButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        
        if (1 != self.index){
            
            [self.guidedExcerciseTitleLabel setText:self.excercise.excerciseName];
            if([NSURL URLWithString:self.excercise.excerciseSmallCoverURL]){
                [self.guidedExcerciseImageButton sd_setImageWithURL:[NSURL URLWithString:self.excercise.excerciseSmallCoverURL] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"defaultExcerciseImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                }];
            } else {
                [self.guidedExcerciseImageButton setImage:[UIImage imageNamed:@"defaultExcerciseImage"] forState:UIControlStateNormal];
            }
        } else {
            [self.guidedExcerciseTitleLabel setText:@"Free form"];
            [self.guidedExcerciseImageButton setImage:[UIImage imageNamed:@"chart"] forState:UIControlStateNormal];
        }
        if(animate){
            CGFloat radius = (KShrinkValue/2);
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
