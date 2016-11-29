//
//  guidedExcerciseCellCollectionViewCell.m
//  MentalSnapp
//
//  Created by Systango on 29/11/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "guidedExcerciseCellCollectionViewCell.h"

@implementation guidedExcerciseCellCollectionViewCell

-(void)setSelectedViewDetail :(NSInteger )count{
    if(self.index != 0 && self.index != count){
    self.guidedExcerciseWidthCinstraint.constant = self.guidedExcerciseHeightCinstraint.constant = 102;
    [self.guidedExcerciseImageButton setBackgroundColor:[UIColor colorWithRed:233.0/255.0 green:101.0/255.0 blue:58.0/255.0 alpha:1.0]];
    [self.guidedExcerciseTitleButton setTitleColor:[UIColor colorWithRed:233.0/255.0 green:101.0/255.0 blue:58.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.guidedExcerciseTitleButton.titleLabel setFont:[UIFont fontWithName:@"Roboto-Bold" size:16]];
    self.guidedExcerciseImageButton.layer.masksToBounds = YES;

    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
        [self.guidedExcerciseImageButton.layer setCornerRadius:(102/2)];
    } completion:^(BOOL finished) {
        
    }];
    } else {
        [self setDefaultViewDetail];
    }
}

-(void)setDefaultViewDetail {
    [self.guidedExcerciseImageButton setBackgroundColor:[UIColor clearColor]];
    [self.guidedExcerciseTitleButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [self.guidedExcerciseTitleButton setTitle:@"" forState:UIControlStateNormal];
}

-(void)setUnSelectedViewDetail :(NSInteger )count{
    if(self.index != 0 && self.index != count){
    self.guidedExcerciseWidthCinstraint.constant = self.guidedExcerciseHeightCinstraint.constant = 68;
    [self.guidedExcerciseImageButton setBackgroundColor:[UIColor colorWithRed:15.0/255.0 green:175.0/255.0 blue:198.0/255.0 alpha:1.0]];
    [self.guidedExcerciseTitleButton setTitleColor:[UIColor colorWithRed:15.0/255.0 green:175.0/255.0 blue:198.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.guidedExcerciseTitleButton.titleLabel setFont:[UIFont fontWithName:@"Roboto" size:13]];
    self.guidedExcerciseImageButton.layer.masksToBounds = YES;
        
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
        [self.guidedExcerciseImageButton.layer setCornerRadius:(68/2)];
    } completion:^(BOOL finished) {
        
    }];
    }else {
        [self setDefaultViewDetail];
    }
}


@end
