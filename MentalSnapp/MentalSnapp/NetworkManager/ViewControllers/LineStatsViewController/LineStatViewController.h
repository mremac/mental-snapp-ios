//
//  LineStatViewController.h
//  MentalSnapp
//
//  Created by Systango on 28/12/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "MSViewController.h"

@interface LineStatViewController : MSViewController
@property (strong, nonatomic) IBOutlet UILabel *headingLabel;
@property (strong, nonatomic) IBOutlet UIView *chatContainerView;
@property (strong, nonatomic) IBOutlet UILabel *weekTitleLabel;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;
@property (strong, nonatomic) IBOutlet UIButton *previouseButton;
@property (assign, nonatomic)  id parentView;
@property (assign, nonatomic) NSInteger selectedWeek;

-(void)refreshDataForMonth:(NSInteger)month andYear:(NSInteger)year WithRecords:(NSMutableArray *)array;

@end
