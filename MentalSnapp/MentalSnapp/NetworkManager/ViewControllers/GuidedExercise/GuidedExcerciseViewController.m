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

@interface GuidedExcerciseViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource>
@property (strong, nonatomic) IBOutlet UIView *topTabScrollableView;
@property (strong, nonatomic) Paginate *guidedExcercidePaginate;
@property (assign, nonatomic) NSInteger selectedIndexPath;
@property (strong, nonatomic) IBOutlet UICollectionView *guidedExcerciseCollectionView;
@property (nonatomic, assign) CGFloat lastContentOffset;
@property (nonatomic,strong) UIPageViewController *pageViewController;

@end

@implementation GuidedExcerciseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _selectedIndexPath = 1;
    [self defaultSettings];
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
- (void)defaultSettings {
    
    // pageViewController
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                            options:nil];
    [self addChildViewController:self.pageViewController];
    // Setup some forwarding events to hijack the scrollView
    // Set self as new delegate
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
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
            [cell setSelectedViewDetail:4/*self.guidedExcercidePaginate.pageResults.count*/];
        } else {
            [cell setUnSelectedViewDetail:4/*self.guidedExcercidePaginate.pageResults.count*/];
        }
    }
    return cell;
}

#pragma mark - Collection View Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.guidedExcerciseCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    guidedExcerciseCellCollectionViewCell *selectedCell = (guidedExcerciseCellCollectionViewCell *)[self.guidedExcerciseCollectionView cellForItemAtIndexPath:indexPath];
    [selectedCell setSelectedViewDetail:4];
    guidedExcerciseCellCollectionViewCell *unSelectedcell = (guidedExcerciseCellCollectionViewCell *)[self.guidedExcerciseCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_selectedIndexPath inSection:0]];
    [unSelectedcell setUnSelectedViewDetail:4];
    _selectedIndexPath = indexPath.item;
}

-(CGSize) collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake([collectionView getWidth]/3, [collectionView getHeight]);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
////- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    CGPoint centerPoint = CGPointMake(self.guidedExcerciseCollectionView.center.x + self.guidedExcerciseCollectionView.contentOffset.x, self.guidedExcerciseCollectionView.center.y + self.guidedExcerciseCollectionView.contentOffset.y);
//    //CGPoint centerPoint = CGPointMake(scrollView.contentOffset.x,scrollView.contentOffset.y);
//    //NSIndexPath *centerCellIndexPath = [self.guidedExcerciseCollectionView indexPathForItemAtPoint:centerPoint];
//    CGPoint point = self.guidedExcerciseCollectionView.contentOffset;
//    point.x +=(([self.guidedExcerciseCollectionView getWidth]/2)+100);
//    
//    CGRect rect = CGRectMake(self.guidedExcerciseCollectionView.center.x+(([self.guidedExcerciseCollectionView getWidth]/3)/2), 0,(self.guidedExcerciseCollectionView.contentSize.width/3),[self.guidedExcerciseCollectionView getHeight]);
//    if (self.lastContentOffset > scrollView.contentOffset.x) {
//            //right
//        rect = CGRectMake(self.guidedExcerciseCollectionView.center.x+(([self.guidedExcerciseCollectionView getWidth]/3)/2), 0,(self.guidedExcerciseCollectionView.contentSize.width/3),[self.guidedExcerciseCollectionView getHeight]);
//    }  else if (self.lastContentOffset < scrollView.contentOffset.x) {
//        //left
//        rect = CGRectMake(self.guidedExcerciseCollectionView.center.x+(([self.guidedExcerciseCollectionView getWidth]/3)/2), 0,(self.guidedExcerciseCollectionView.frame.size.width/3),[self.guidedExcerciseCollectionView getHeight]);
//    }
//    self.lastContentOffset = scrollView.contentOffset.x;
//    
//    NSIndexPath *centerCellIndexPath = [self.guidedExcerciseCollectionView indexPathForItemAtPoint:(CGRectContainsPoint(rect, point))? point:centerPoint];
//
//       if(centerCellIndexPath && self.selectedIndexPath != centerCellIndexPath.item) {
//           if(centerCellIndexPath.item != 0 && centerCellIndexPath.item != 4){
//               guidedExcerciseCellCollectionViewCell *selectedCell = (guidedExcerciseCellCollectionViewCell *)[self.guidedExcerciseCollectionView cellForItemAtIndexPath:   centerCellIndexPath];
//               [selectedCell setSelectedViewDetail:4];
//
//               guidedExcerciseCellCollectionViewCell *unSelectedcell = (guidedExcerciseCellCollectionViewCell *)[self.guidedExcerciseCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_selectedIndexPath inSection:0]];
//               [unSelectedcell setUnSelectedViewDetail:4];
//               _selectedIndexPath = centerCellIndexPath.item;
//               [self.guidedExcerciseCollectionView scrollToItemAtIndexPath:centerCellIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
//           }
//    }
}


@end
