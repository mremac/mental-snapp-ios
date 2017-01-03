//
//  SubCategoryDetailViewController.h
//  MentalSnapp
//
//  Created by Systango on 12/12/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "MSViewController.h"
#import "GuidedExcercise.h"
#import "SubCategoryPageViewController.h"

@interface SubCategoryDetailViewController : MSViewController

@property (strong, nonatomic) GuidedExcercise *selectedExcercise;
@property (strong, nonatomic) NSArray *allSubExcercises;
@property (strong, nonatomic) SubCategoryPageViewController *pageControl;

@property (assign, nonatomic) NSInteger index;

@end
