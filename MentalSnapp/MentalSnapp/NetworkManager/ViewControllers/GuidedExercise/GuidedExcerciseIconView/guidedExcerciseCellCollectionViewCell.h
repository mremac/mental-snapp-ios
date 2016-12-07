//
//  guidedExcerciseCellCollectionViewCell.h
//  MentalSnapp
//
//  Created by Systango on 29/11/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GuidedExcercise.h"

@interface guidedExcerciseCellCollectionViewCell : UICollectionViewCell

#define KGrowValue 102
#define KShrinkValue 68

@property (strong, nonatomic) IBOutlet UIButton *guidedExcerciseImageButton;
@property (strong, nonatomic) IBOutlet UILabel *guidedExcerciseTitleLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *guidedExcerciseHeightCinstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *guidedExcerciseWidthCinstraint;
@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) GuidedExcercise *excercise;

- (void)setSelectedViewDetail:(NSInteger )count withAnimation:(BOOL)animate andValue:(CGFloat)value;
- (void)setUnSelectedViewDetail:(NSInteger )count withAnimation:(BOOL)animate andValue:(CGFloat)value;
- (void)setDefaultViewDetail;

@end
