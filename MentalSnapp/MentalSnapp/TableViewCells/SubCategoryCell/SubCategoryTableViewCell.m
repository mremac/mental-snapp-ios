//
//  SubCategoryTableViewCell.m
//  MentalSnapp
//
//  Created by Systango on 02/12/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "SubCategoryTableViewCell.h"

@implementation SubCategoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setContentsFromExcercise:(GuidedExcercise *)excercise {
    [self.categoryImageView sd_setImageWithURL:[NSURL URLWithString:excercise.coverURL] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"defaultExcerciseImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if(image){
            [self.categoryImageView setImage:image forState:UIControlStateNormal];
        }
    }];
    [self.categoryImageView setUserInteractionEnabled:NO];
    [self.categoryTitle setText:excercise.excerciseName];
    [self.categorySubdisciption setText:excercise.excerciseDescription];    
}

@end
