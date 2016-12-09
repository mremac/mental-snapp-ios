//
//  ExcerciseSubCategoryViewController.h
//  MentalSnapp
//
//  Created by Systango on 30/11/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "MSViewController.h"
#import "GuidedExcercise.h"
#import "GuidedExcerciseViewController.h"

@interface ExcerciseSubCategoryViewController : MSViewController

@property (strong, nonatomic) GuidedExcercise *excercise;
@property (assign, nonatomic) NSInteger viewTag;
@property (strong, nonatomic) GuidedExcerciseViewController *excerciseParentViewController;

@end
