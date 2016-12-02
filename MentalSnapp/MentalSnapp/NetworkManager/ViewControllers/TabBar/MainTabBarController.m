//
//  MainTabBar.m
//  MentalSnapp
//

#import "MainTabBarController.h"
#import "GuidedExcerciseViewController.h"

@interface MainTabBarController() {
    UIColor *normalColor;
    UIColor *selectionColor;
    NSMutableArray <UIView *> *subViews;
}

@property(strong, nonatomic) UIView *view1;
@property(strong, nonatomic) UIView *view2;
@property(strong, nonatomic) UIView *view3;
@property(strong, nonatomic) UIView *view4;
@property(strong, nonatomic) UIView *view5;
@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    selectionColor = [UIColor colorWithRed:233/255.f green:101/255.f blue:58/255.f alpha:1.f];
    normalColor = [UIColor colorWithRed:15/255.f green:175/255.f blue:199/255.f alpha:1.f];
    [self addViewInTabBar];
    [self addGuidedExcerciseTab];
    [self setTabBarItems];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    [_view1 setBackgroundColor:normalColor];
    [_view2 setBackgroundColor:normalColor];
    [_view3 setBackgroundColor:normalColor];
    [_view4 setBackgroundColor:normalColor];
    [_view5 setBackgroundColor:normalColor];
    
    [[subViews objectAtIndex:item.tag] setBackgroundColor:selectionColor];
}

- (void)addViewInTabBar {
    _view1 = [UIView new];
    _view2 = [UIView new];
    _view3 = [UIView new];
    _view4 = [UIView new];
    _view5 = [UIView new];
    
    [_view1 setBackgroundColor:selectionColor];
    [_view2 setBackgroundColor:normalColor];
    [_view3 setBackgroundColor:normalColor];
    [_view4 setBackgroundColor:normalColor];
    [_view5 setBackgroundColor:normalColor];
    
    [self.tabBar addSubview:_view1];
    [self.tabBar addSubview:_view2];
    [self.tabBar addSubview:_view3];
    [self.tabBar addSubview:_view4];
    [self.tabBar addSubview:_view5];
    
    CGFloat tabBarHeight = self.tabBar.frame.size.height;
    CGFloat itemWidth = self.view.frame.size.width / 5;
    [_view1 setFrame:CGRectMake(0, 0, itemWidth, tabBarHeight)];
    [_view2 setFrame:CGRectMake(_view1.frame.size.width+_view1.frame.origin.x, 0, itemWidth, tabBarHeight)];
    [_view3 setFrame:CGRectMake(_view2.frame.size.width+_view2.frame.origin.x, 0, itemWidth, tabBarHeight)];
    [_view4 setFrame:CGRectMake(_view3.frame.size.width+_view3.frame.origin.x, 0, itemWidth, tabBarHeight)];
    [_view5 setFrame:CGRectMake(_view4.frame.size.width+_view4.frame.origin.x, 0, itemWidth, tabBarHeight)];
    
    [self addVerticalLineToRightOfView:_view1];
    [self addVerticalLineToRightOfView:_view2];
    [self addVerticalLineToRightOfView:_view3];
    [self addVerticalLineToRightOfView:_view4];
    
    subViews = [NSMutableArray arrayWithObjects:_view1, _view2, _view3, _view4, _view5, nil];
}

- (void)addVerticalLineToRightOfView:(UIView *)view {
    UIView *whiteView = [UIView new];
    [whiteView setBackgroundColor:[UIColor whiteColor]];
    [view addSubview:whiteView];
    [whiteView setFrame:CGRectMake(view.frame.size.width - 1, 0, 1, view.frame.size.height)];
}

- (void)setTabBarItems {
    //TODO: [optimize] Clean Constants
     
    UITabBarItem *tabBarItem0 = [self.tabBar.items objectAtIndex:0];
    tabBarItem0.image =[[UIImage imageNamed:@"exercise"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem0.selectedImage = [[UIImage imageNamed:@"exercise_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem *tabBarItem1 = [self.tabBar.items objectAtIndex:1];
    tabBarItem1.image =[[UIImage imageNamed:@"video"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem1.selectedImage = [[UIImage imageNamed:@"video_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem *tabBarItem2 = [self.tabBar.items objectAtIndex:2];
    tabBarItem2.image =[[UIImage imageNamed:@"record_tab"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem2.selectedImage = [[UIImage imageNamed:@"record_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem *tabBarItem3 = [self.tabBar.items objectAtIndex:3];
    tabBarItem3.image =[[UIImage imageNamed:@"stats"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem3.selectedImage = [[UIImage imageNamed:@"stats_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem *tabBarItem4 = [self.tabBar.items objectAtIndex:4];
    tabBarItem4.image =[[UIImage imageNamed:@"more"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem4.selectedImage = [[UIImage imageNamed:@"more_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    tabBarItem0.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    tabBarItem1.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    tabBarItem2.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    tabBarItem3.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    tabBarItem4.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
}

//This is the method that will draw the underline

-(UIImage *) ChangeViewToImage : (UIView* ) viewForImage{
    
    UIGraphicsBeginImageContext(viewForImage.bounds.size);
    [viewForImage.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
  }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addGuidedExcerciseTab {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:KProfileStoryboard bundle:nil];
    GuidedExcerciseViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kGuidedExcerciseViewController];
    NSMutableArray *tabArray = [NSMutableArray arrayWithArray:self.viewControllers];
    [tabArray insertObject:[[UINavigationController alloc] initWithRootViewController:viewController] atIndex:0];
    [self setViewControllers:tabArray];
}

@end
