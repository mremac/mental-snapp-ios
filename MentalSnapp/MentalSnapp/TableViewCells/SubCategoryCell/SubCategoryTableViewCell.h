//
//  SubCategoryTableViewCell.h
//  MentalSnapp
//
//  Created by Systango on 02/12/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GuidedExcercise.h"

@interface SubCategoryTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *categoryImageView;
@property (strong, nonatomic) IBOutlet UILabel *categoryTitle;
@property (strong, nonatomic) IBOutlet UILabel *categorySubdisciption;
@property (strong, nonatomic) IBOutlet UIButton *calenderButton;
@property (strong, nonatomic) IBOutlet UIButton *recordButton;


-(void)setContentsFromExcercise:(GuidedExcercise *)excercise;

@end
