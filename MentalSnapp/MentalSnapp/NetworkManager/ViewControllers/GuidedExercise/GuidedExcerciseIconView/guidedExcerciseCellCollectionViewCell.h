//
//  guidedExcerciseCellCollectionViewCell.h
//  MentalSnapp
//
//  Created by Systango on 29/11/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface guidedExcerciseCellCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIButton *guidedExcerciseImageButton;
@property (strong, nonatomic) IBOutlet UIButton *guidedExcerciseTitleButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *guidedExcerciseHeightCinstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *guidedExcerciseWidthCinstraint;
@property (assign, nonatomic) NSInteger index;

- (void)setSelectedViewDetail:(NSInteger )count withAnimation:(BOOL)animate andValue:(CGFloat)value;
- (void)setUnSelectedViewDetail:(NSInteger )count withAnimation:(BOOL)animate andValue:(CGFloat)value;
- (void)setDefaultViewDetail;

@end
