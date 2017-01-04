//
//  SubCategoryPageViewController.m
//  MentalSnapp
//
//  Created by Systango on 12/12/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "SubCategoryPageViewController.h"
#import "SubCategoryDetailViewController.h"
#import "Paginate.h"
#import "RequestManager.h"

@interface SubCategoryPageViewController()

@property (strong, nonatomic) Paginate *guidedExcercisePaginate;
@property (strong, nonatomic) IBOutlet UILabel *noContentLabel;

@end


@implementation SubCategoryPageViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self addPaginationViewController];
    [self.noContentLabel setHidden:YES];
    [self.navigationController setNavigationBarHidden:NO];
    [self setNavigationBarButtonTitle:[NSString stringWithFormat:@"%@",[self.selectedGuidedExcercise excerciseName]]];
    [self setLeftMenuButtons:[NSArray arrayWithObject:[self backButton]]];
    [self.noContentLabel setText:[NSString stringWithFormat:@"There are no questions of %@ excercise available yet!",self.selectedMainExcercise.excerciseName]];
    [self getSubcategoryQuestion];

}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

#pragma mark - Public methods

-(void)setSelectedViewControllerAtIndex:(NSInteger)index {
    SubCategoryDetailViewController *initialViewController = [self viewControllerAtIndex:index];
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
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
    childViewController.allSubExcercises = self.exerciseList;
    childViewController.pageControl = self;
    childViewController.index = index;
    
    return childViewController;
    
}

- (void)initGuidedPaginate {
    self.guidedExcercisePaginate = [[Paginate alloc] initWithPageNumber:[NSNumber numberWithInt:1] withMoreRecords:YES andPerPageLimit:100];
    self.guidedExcercisePaginate.details = self.selectedMainExcercise.excerciseId;
}

-(void)addPaginationViewController {
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageController.dataSource = self;
    self.pageController.delegate = self;
    [[self.pageController view] setFrame:[[self view] bounds]];
    self.currentIndex = 0;
      [self addChildViewController:self.pageController];
    [[self view] addSubview:[self.pageController view]];
    [self.pageController didMoveToParentViewController:self];
}

#pragma mark - API
-(void)getSubcategoryQuestion {
    [self initGuidedPaginate];
    [self fetchGuidedExcercise];
}

-(void)fetchGuidedExcercise {
    [self showInProgress:YES];
    [[RequestManager alloc] initWithFetchSubCategoryQuestionsExcerciseWithPaginate:self.guidedExcercisePaginate withCompletionBlock:^(BOOL success, id response) {
        if(success){
            [self.guidedExcercisePaginate updatePaginationWith:response];
            self.exerciseList = self.guidedExcercisePaginate.pageResults;
            if(self.exerciseList.count>0){
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.noContentLabel setHidden:YES];
                    [self.pageController.view setHidden:NO];
                    [self setSelectedViewControllerAtIndex:self.currentIndex];
                });
            } else {
                [self.noContentLabel setHidden:NO];
                [self.pageController.view setHidden:YES];
            }
        } else {
            [self.pageController.view setHidden:YES];
            [self.noContentLabel setHidden:NO];
        }
        [self showInProgress:NO];
    }];
}


#pragma mark - UIPageViewController delegate

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if(completed)
    {
        self.currentIndex = [self currentControllerIndex];
        //[self setNavigationBarButtonTitle:[NSString stringWithFormat:@"%@",[self exerciseNameWithIndex:self.currentIndex]]];
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
