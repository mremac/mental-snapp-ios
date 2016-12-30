//
//  SubCategoryPageViewController.m
//  MentalSnapp
//
//  Created by Systango on 12/12/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "SubCategoryPageViewController.h"
#import "SubCategoryDetailViewController.h"

@implementation SubCategoryPageViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO];
    [self setNavigationBarButtonTitle:[NSString stringWithFormat:@"%@",[self exerciseNameWithIndex:self.currentIndex]]];
    [self setLeftMenuButtons:[NSArray arrayWithObject:[self backButton]]];

    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageController.dataSource = self;
    self.pageController.delegate = self;
    [[self.pageController view] setFrame:[[self view] bounds]];
    
    SubCategoryDetailViewController *initialViewController = [self viewControllerAtIndex:self.currentIndex];
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageController];
    [[self view] addSubview:[self.pageController view]];
    [self.pageController didMoveToParentViewController:self];
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

#pragma mark - Private methods

- (NSString *)exerciseNameWithIndex:(NSUInteger)index
{
    GuidedExcercise *exercise = [self.exerciseList objectAtIndex:index];
    return exercise.excerciseName;
}

- (UIViewController *)currentController
{
    if ([self.pageController.viewControllers count])
    {
        return self.pageController.viewControllers[0];
    }
    
    return nil;
}

- (NSUInteger)currentControllerIndex
{
    SubCategoryDetailViewController *scdvc = (SubCategoryDetailViewController *) [self currentController];
    
    if (scdvc)
    {
        return scdvc.index;
    }
    
    return -1;
}

- (SubCategoryDetailViewController *)viewControllerAtIndex:(NSUInteger)index {
        
    SubCategoryDetailViewController *childViewController = [[UIStoryboard storyboardWithName:KProfileStoryboard bundle:nil] instantiateViewControllerWithIdentifier:kSubCategoryDetailViewController];
    childViewController.selectedExcercise = [self.exerciseList objectAtIndex:index];
    
    childViewController.index = index;
    
    return childViewController;
    
}

#pragma mark - UIPageViewController delegate

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if(completed)
    {
        self.currentIndex = [self currentControllerIndex];
        [self setNavigationBarButtonTitle:[NSString stringWithFormat:@"%@",[self exerciseNameWithIndex:self.currentIndex]]];
    }
}

#pragma mark - UIPageViewController data source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(SubCategoryDetailViewController *)viewController index];
    
    if (index == 0) {
        return nil;
    }
    
    // Decrease the index by 1 to return
    index--;
    
    return [self viewControllerAtIndex:index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(SubCategoryDetailViewController *)viewController index];
    
    index++;
    
    if (index == self.exerciseList.count) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
    
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // The number of items reflected in the page indicator.
    return self.exerciseList.count;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    return 0;
}

@end
