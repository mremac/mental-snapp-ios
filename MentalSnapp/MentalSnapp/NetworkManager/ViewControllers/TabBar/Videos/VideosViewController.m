//
//  VideosViewController.m
//  MentalSnapp
//
//  Created by Systango on 13/12/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "VideosViewController.h"
#import "VideoTableViewCell.h"
#import "RecordPost.h"
#import "RequestManager.h"
#import "Paginate.h"

@interface VideosViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *noContentView;
@property (strong, nonatomic) Paginate *recordPostsPaginate;
@end

@implementation VideosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarButtonTitle:@"Mental Snapp"];
    
    __unsafe_unretained VideosViewController *weakSelf = self;
    
    // setup pull to refresh
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf insertRowAtTop];
    }];
    
    // setup infinite scrolling
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf insertRowAtBottom];
    }];
    
    [self getRecordPosts];
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

#pragma mark - IBActions

- (IBAction)filterButtonTapped:(id)sender {
}
- (IBAction)searchButtonTapped:(id)sender {
}


#pragma mark - Private methods

- (void)insertRowAtTop
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self getRecordPosts];
    });
}

- (void)insertRowAtBottom
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.recordPostsPaginate.pageResults count]) {
            [self.tableView.infiniteScrollingView startAnimating];
            [self performInfinteScroll];
        }else {
            [self.tableView.infiniteScrollingView stopAnimating];
        }
    });
}

- (void)performInfinteScroll
{
    NSLog(@"performSearchResultsInfinteScroll");
    if (self.recordPostsPaginate.hasMoreRecords) {
        [self.tableView.infiniteScrollingView startAnimating];
        [self fetchRecordPosts];
    }else {
        [self.tableView.infiniteScrollingView stopAnimating];
    }
}

- (void)initRecordPostsPaginate
{
    self.recordPostsPaginate = [[Paginate alloc] initWithPageNumber:[NSNumber numberWithInt:1] withMoreRecords:YES andPerPageLimit:10];
//    self.recordPostsPaginate.details = self.excercise.excerciseId; TODO: check
}

#pragma mark - API Call

-(void)getRecordPosts
{
    [self initRecordPostsPaginate];
    [self fetchRecordPosts];
}

-(void)fetchRecordPosts
{
    [self showDefaultIndicatorProgress:YES];
    
    [[RequestManager alloc] getRecordPostsWithPaginate:self.recordPostsPaginate withCompletionBlock:^(BOOL success, id response)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.pullToRefreshView stopAnimating];
            [self.tableView.infiniteScrollingView stopAnimating];
        });
        
        if(success)
        {
            [self.recordPostsPaginate updatePaginationWith:response];
            
            if([self.recordPostsPaginate.pageResults count] > 0)
            {
                [self.tableView setHidden:NO];
                [self.noContentView setHidden:YES];
                [self.tableView reloadData];
            } else
            {
                [self.tableView setHidden:YES];
                [self.noContentView setHidden:NO];
            }
        }
        
        [self showDefaultIndicatorProgress:NO];
        [self showInProgress:NO];
    }];
}

#pragma mark - Table View DataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.recordPostsPaginate.pageResults.count>0){
        [self.noContentView setHidden:YES];
    }
    return [self.recordPostsPaginate.pageResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VideoTableViewCell *videoTableViewCell = [tableView dequeueReusableCellWithIdentifier:kVideoTableViewCellIdentifier];
    
    if (!videoTableViewCell)
    {
        videoTableViewCell = [[VideoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kVideoTableViewCellIdentifier];
    }
    
    videoTableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(self.recordPostsPaginate.pageResults.count > indexPath.row)
    {
        [videoTableViewCell assignRecordPost:[self.recordPostsPaginate.pageResults objectAtIndex:indexPath.row] playBlock:^(BOOL success, id response) {
            if([response isKindOfClass:[RecordPost class]])
            {
                RecordPost *recordPost = response;
                NSLog([NSString stringWithFormat:@"Play recordPost: %@", recordPost]);
            }
        } downloadBlock:^(BOOL success, id response) {
            if([response isKindOfClass:[RecordPost class]])
            {
                RecordPost *recordPost = response;
                NSLog([NSString stringWithFormat:@"Download recordPost: %@", recordPost]);
            }
        }];
    }
    
    return videoTableViewCell;
}

#pragma mark - Table View Delegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 400;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RecordPost *recordPost = [self.recordPostsPaginate.pageResults objectAtIndex:indexPath.row];
    if(recordPost){
        NSLog([NSString stringWithFormat:@"Cell tapped recordPost: %@", recordPost]);
//        self.subCategoryDetailViewController = [[UIStoryboard storyboardWithName:KProfileStoryboard bundle:nil] instantiateViewControllerWithIdentifier:kSubCategoryDetailViewController];
//        self.subCategoryDetailViewController.selectedExcercise = excercixe;
//        [self.excerciseParentViewController.navigationController pushViewController:self.subCategoryDetailViewController animated:YES];
    }
}

@end
