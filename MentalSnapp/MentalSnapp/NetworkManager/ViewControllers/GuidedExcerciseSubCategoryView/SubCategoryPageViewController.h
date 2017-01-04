//
//  SubCategoryPageViewController.h
//  MentalSnapp
//
//  Created by Systango on 12/12/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "MSViewController.h"

@interface SubCategoryPageViewController : MSViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (strong, nonatomic) UIPageViewController *pageController;
@property (strong, nonatomic) NSArray *exerciseList;
@property (assign, nonatomic) NSInteger currentIndex;
@property (strong, nonatomic) GuidedExcercise *selectedMainExcercise;
@property (strong, nonatomic) GuidedExcercise *selectedGuidedExcercise;

-(void)setSelectedViewControllerAtIndex:(NSInteger)index;
@end
