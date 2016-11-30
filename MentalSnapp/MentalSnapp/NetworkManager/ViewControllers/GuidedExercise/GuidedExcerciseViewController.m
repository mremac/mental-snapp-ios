//
//  GuidedExcerciseViewController.m
//  MentalSnapp
//
//  Created by Systango on 29/11/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "GuidedExcerciseViewController.h"
#import "Paginate.h"
#import "guidedExcerciseCellCollectionViewCell.h"
#import "ExcerciseSubCategoryViewController.h"

#define _minVoteiPhoneSwipe ([[UIScreen mainScreen] bounds].size.width * 1/4)

@interface GuidedExcerciseViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource, UIGestureRecognizerDelegate, UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *topTabScrollableView;
@property (strong, nonatomic) Paginate *guidedExcercidePaginate;
@property (assign, nonatomic) NSInteger selectedIndexPath;
@property (strong, nonatomic) IBOutlet UICollectionView *guidedExcerciseCollectionView;
@property (nonatomic, assign) CGFloat lastContentOffset;
@property (nonatomic,strong) UIPageViewController *pageViewController;
@property (strong, nonatomic) IBOutlet UIView *paginationContainerView;
@property (strong, nonatomic) IBOutlet UIView *swipableView;
@property (strong, nonatomic) NSArray *guideExcerciseViewControllers;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *swipableViewLeadingConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *swipableViewTrailingConstraint;
@property (assign, nonatomic) NSInteger index;

@end

@implementation GuidedExcerciseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _selectedIndexPath = 1;
    [self setNavigationBarButtonTitle:@"Mental Snapp"];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self defaultSettings];
    });
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
    [self.guidedExcerciseCollectionView setUserInteractionEnabled:YES];
    [panGesture setCancelsTouchesInView:YES];
    [panGesture setDelaysTouchesEnded:YES];
    [panGesture setDelegate:self];
    [panGesture setMinimumNumberOfTouches:1];
    [self.guidedExcerciseCollectionView addGestureRecognizer:panGesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Private methods

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index {
    return self.guideExcerciseViewControllers[index];
}

-(void)showScrollSelectedExcerciseForIndexpath:(NSIndexPath *)indexPath withAnimation:(BOOL)animate andGrowValue:(CGFloat)growValue andShrinkValue:(CGFloat)value{
    if(indexPath.item != _selectedIndexPath){
        guidedExcerciseCellCollectionViewCell *selectedCell = (guidedExcerciseCellCollectionViewCell *)[self.guidedExcerciseCollectionView cellForItemAtIndexPath:indexPath];
        [selectedCell setSelectedViewDetail:4 withAnimation:animate andValue:(animate?0:growValue)];
        guidedExcerciseCellCollectionViewCell *unSelectedcell = (guidedExcerciseCellCollectionViewCell *)[self.guidedExcerciseCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_selectedIndexPath inSection:0]];
        [unSelectedcell setUnSelectedViewDetail:4 withAnimation:animate andValue:(animate?0:value)];
    }
}

-(void)showSelectedExcerciseForIndexpath:(NSIndexPath *)indexPath withAnimation:(BOOL)animate andGrowValue:(CGFloat)growValue andShrinkValue:(CGFloat)value{
    if(indexPath.item != _selectedIndexPath){
        [self.guidedExcerciseCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        guidedExcerciseCellCollectionViewCell *selectedCell = (guidedExcerciseCellCollectionViewCell *)[self.guidedExcerciseCollectionView cellForItemAtIndexPath:indexPath];
        [selectedCell setSelectedViewDetail:4 withAnimation:animate andValue:(animate?0:growValue)];
        guidedExcerciseCellCollectionViewCell *unSelectedcell = (guidedExcerciseCellCollectionViewCell *)[self.guidedExcerciseCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_selectedIndexPath inSection:0]];
        [unSelectedcell setUnSelectedViewDetail:4 withAnimation:animate andValue:(animate?0:value)];
        _selectedIndexPath = indexPath.item;
    }
}

- (void)defaultSettings {
    // pageViewController
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                            options:nil];
    
    for (UIView *view in self.pageViewController.view.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            [(UIScrollView *)view setDelegate:self];
            [view setTag:999];
        }
    } 

    [self addViewControllerInPagination];
    [self.paginationContainerView addSubview:self.pageViewController.view];
    [self.pageViewController.view setBackgroundColor:[UIColor clearColor]];
    NSDictionary *viewsDictionary = [[NSDictionary alloc] init];
    viewsDictionary = @{@"view":self.pageViewController.view};
    
    if([viewsDictionary count] > 0)
    {
        NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:viewsDictionary];
        NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:viewsDictionary];
        [self.paginationContainerView addConstraints:verticalConstraints];
        [self.paginationContainerView addConstraints:horizontalConstraints];
    }
    // Setup some forwarding events to hijack the scrollView
    // Set self as new delegate
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
}

-(void)addViewControllerInPagination {
    [self didMoveToParentViewController:self];
    UIStoryboard *profileStoryboard = [UIStoryboard storyboardWithName:KProfileStoryboard bundle:[NSBundle mainBundle]];
    ExcerciseSubCategoryViewController *guidedExcercisePage1 = [profileStoryboard instantiateViewControllerWithIdentifier:kExcerciseSubCategoryViewController];
    [guidedExcercisePage1.view setFrame:self.view.frame];
    [guidedExcercisePage1.view setBackgroundColor:[UIColor redColor]];
    
    ExcerciseSubCategoryViewController *guidedExcercisePage2 = [profileStoryboard instantiateViewControllerWithIdentifier:kExcerciseSubCategoryViewController];
    [guidedExcercisePage2.view setFrame:self.view.frame];
    [guidedExcercisePage2.view setBackgroundColor:[UIColor greenColor]];

    ExcerciseSubCategoryViewController *guidedExcercisePage3 = [profileStoryboard instantiateViewControllerWithIdentifier:kExcerciseSubCategoryViewController];
    [guidedExcercisePage3.view setFrame:self.view.frame];
    [guidedExcercisePage3.view setBackgroundColor:[UIColor blueColor]];

    self.guideExcerciseViewControllers = @[guidedExcercisePage1, guidedExcercisePage2, guidedExcercisePage3];
    self.index = 0;
    [self.pageViewController setViewControllers:@[guidedExcercisePage1] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

#pragma mark - Gesture methods


- (IBAction)panGestureRecognizer:(UIPanGestureRecognizer *)panGesture
{
    CGPoint translatedPoint = [panGesture translationInView:self.swipableView];
    //    NSLog(@"%@ \n %f",panGesture, translatedPoint.x);
         switch (panGesture.state) {
            
        case UIGestureRecognizerStateBegan:
                 break;
        case UIGestureRecognizerStateChanged:{
            
            if(translatedPoint.x > 0.0) // left slide
            {
                // change left slide alpha value
                translatedPoint.y = 0;
                translatedPoint.x = -translatedPoint.x;
                if(self.guidedExcerciseCollectionView.contentOffset.x>0 && translatedPoint.x <0){
                    translatedPoint.x=0;
                }
                [self.guidedExcerciseCollectionView setContentOffset:translatedPoint animated:YES];
            }
            else if(translatedPoint.x < 0.0) // right slide
            {
                // change right slide alpha value
                translatedPoint.y = 0;
                translatedPoint.x = -translatedPoint.x;
                if(translatedPoint.x < self.guidedExcerciseCollectionView.frame.size.width){
                    [self.guidedExcerciseCollectionView setContentOffset:translatedPoint animated:YES];
                }
            }
            break;
        }
            
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(translatedPoint.x > 0.0)
                {
                    if(_selectedIndexPath >0){
                        [self showSelectedExcerciseForIndexpath:[NSIndexPath indexPathForRow:(_selectedIndexPath-1) inSection:0] withAnimation:YES andGrowValue:0 andShrinkValue:0];
                        GuidedExcerciseViewController *controller = [self.guideExcerciseViewControllers objectAtIndex:((_selectedIndexPath)-1)];
                        [self.pageViewController setViewControllers:@[controller] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
                    }
                }
                else if (translatedPoint.x < 0.0)
                {
                    if(_selectedIndexPath < 4){
                        [self showSelectedExcerciseForIndexpath:[NSIndexPath indexPathForRow:(_selectedIndexPath+1) inSection:0] withAnimation:YES andGrowValue:0 andShrinkValue:0];
                        GuidedExcerciseViewController *controller = [self.guideExcerciseViewControllers objectAtIndex:((_selectedIndexPath)-1)];
                        [self.pageViewController setViewControllers:@[controller] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];

                    }
                }
                else
                {
                }
            });
            break;
        }
        default:
            break;
    }
}


#pragma mark - Collection view Data Souarce

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 5;//self.guidedExcercidePaginate.pageResults.count+2;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    guidedExcerciseCellCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kguidedExcerciseCellCollectionViewCell forIndexPath:indexPath];
    cell.index = indexPath.item;
    [cell setDefaultViewDetail];
    if(indexPath.item != 0 && indexPath.item !=4 /*[self.guidedExcercidePaginate pageResults].count*/){
        if(self.selectedIndexPath == indexPath.item){
            [cell setSelectedViewDetail:4/*self.guidedExcercidePaginate.pageResults.count*/ withAnimation:YES andValue:0];
        } else {
            [cell setUnSelectedViewDetail:4/*self.guidedExcercidePaginate.pageResults.count*/ withAnimation:YES andValue:0];
        }
    }
    return cell;
}

#pragma mark - Collection View Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0 || indexPath.row>=5){
        return;
    }
    BOOL scrollDirectionLeft = (indexPath.row < _selectedIndexPath)?YES:NO;
    [self showSelectedExcerciseForIndexpath:indexPath withAnimation:YES andGrowValue:0 andShrinkValue:0];
    GuidedExcerciseViewController *controller = [self.guideExcerciseViewControllers objectAtIndex:indexPath.row-1];
    [self.pageViewController setViewControllers:@[controller] direction:(scrollDirectionLeft)?UIPageViewControllerNavigationDirectionReverse:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];

}

-(CGSize) collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake([collectionView getWidth]/3, [collectionView getHeight]);
}

#pragma mark - ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(scrollView.tag == 999){
        CGPoint offset= scrollView.contentOffset;
        offset.y=0;
        offset.x=(offset.x/7);
        CGFloat growRadius= offset.x;
        CGFloat shrinkRadius= offset.x;
        growRadius += 68;
        shrinkRadius -= 102;
        growRadius = (growRadius >=102)?102:growRadius;
        shrinkRadius = (shrinkRadius <= 68)?68:shrinkRadius;
        
//        if (self.lastContentOffset > scrollView.contentOffset.x) {
//           // [self.guidedExcerciseCollectionView setContentOffset:offset];
//            [self showScrollSelectedExcerciseForIndexpath:[NSIndexPath indexPathForRow:(_selectedIndexPath-1) inSection:0] withAnimation:NO andGrowValue:growRadius andShrinkValue:shrinkRadius];
//        } else if (self.lastContentOffset < scrollView.contentOffset.x) {
//           // [self.guidedExcerciseCollectionView setContentOffset:offset];
//            [self showScrollSelectedExcerciseForIndexpath:[NSIndexPath indexPathForRow:(_selectedIndexPath+1) inSection:0] withAnimation:NO andGrowValue:growRadius andShrinkValue:shrinkRadius];
//        }
        self.lastContentOffset = scrollView.contentOffset.x;
    }
}


#pragma mark -
#pragma mark -Page Delegate and Data Source
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self.guideExcerciseViewControllers indexOfObject:viewController];
    dispatch_async(dispatch_get_main_queue(), ^{
        if(index != _selectedIndexPath){
            [self showSelectedExcerciseForIndexpath:[NSIndexPath indexPathForRow:index+1 inSection:0] withAnimation:YES andGrowValue:0 andShrinkValue:0];
        }
    });
    if (index == 0) {
        return nil;
    }
    // Decrease the index by 1 to return
    index--;
    self.index = index;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index =[self.guideExcerciseViewControllers indexOfObject:viewController];
    dispatch_async(dispatch_get_main_queue(), ^{
        if(index != _selectedIndexPath){
            [self showSelectedExcerciseForIndexpath:[NSIndexPath indexPathForRow:index+1 inSection:0] withAnimation:YES andGrowValue:0 andShrinkValue:0];
        }
    });
    index++;
    if (index >= [self.guideExcerciseViewControllers count]) { return nil; }
    
    self.index = index;
    return [self viewControllerAtIndex:index];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    if(finished) {
        NSUInteger index =[self.guideExcerciseViewControllers indexOfObject:previousViewControllers];
        [self showSelectedExcerciseForIndexpath:[NSIndexPath indexPathForRow:index+1 inSection:0] withAnimation:YES andGrowValue:0 andShrinkValue:0];

        //        TutorialViewController *tutorialViewController = [self.pageControlView.viewControllers objectAtIndex:0];
        //        NSUInteger currentIndex =[tutorialViewController index];
        //        [self.pageControl setCurrentPage:currentIndex];
        //        if (currentIndex == 0)
        //            [self showSkipButton:NO];
        //        else
        //             [self showSkipButton:YES];
    }
}

@end
