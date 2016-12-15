//
//  VideosViewController.m
//  MentalSnapp
//
//  Created by Systango on 13/12/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "VideosViewController.h"
#import "VideoTableViewCell.h"
#import "FilterListTableController.h"
#import "RecordPost.h"
#import "RequestManager.h"
#import "Paginate.h"

@interface VideosViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *noContentView;
@property (weak, nonatomic) IBOutlet UIView *topHeaderView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIButton *filterButton;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelSearchButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchButtonLeadingContraint;
@property (strong, nonatomic) Paginate *recordPostsPaginate;
@property (strong, nonatomic) Paginate *searchPaginate;
@property (strong, nonatomic) Paginate *filterPaginate;
@property (strong, nonatomic) FilterModel *selectedFilter;
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
    
    [self.topHeaderView layoutIfNeeded];
    [self changeSearchMode];
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

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self didSearchBegin];
    return YES;
}

#pragma mark - IBActions

- (IBAction)filterButtonTapped:(id)sender
{
    [self didFilterButtonTapped:sender];
}

- (IBAction)searchButtonTapped:(id)sender
{
    [self didSearchButtonTapped];
}

- (IBAction)cancelSearchButtonTapped:(UIButton *)sender
{
    [self didCancelSearch];
}

#pragma mark - Private methods

- (void)didFilterButtonTapped:(id)sender
{
    [self didCancelSearch];
    [self popover:sender];
}

- (void)didSearchBegin
{
    if(self.searchButton.isSelected && self.searchTextField.text.trim.length > 0)
    {
        [self getRecordPosts];
    }
    else if(self.searchButton.isSelected)
    {
        [self didCancelSearch];
    }
}

- (void)didSearchButtonTapped
{
    if(self.searchButton.isSelected)
        return;
    
    self.searchButton.selected = YES;
    
    [self animateSearch];
}

- (void)didCancelSearch
{
    self.searchButton.selected = NO;
    [self animateSearch];
    [self.tableView reloadData];
}

- (void)changeSearchMode
{
    if(self.searchButton.isSelected)
    {
        self.searchButtonLeadingContraint.constant = 0;
        self.searchTextField.hidden = NO;
        self.searchTextField.alpha = 1;
        [self.searchTextField becomeFirstResponder];
        self.cancelSearchButton.hidden = NO;
        self.tableView.alpha = 0.5;
    }
    else
    {
        CGFloat xpos = [self.filterButton getXPos];
        CGFloat width = [self.searchButton getWidth];
        self.searchButtonLeadingContraint.constant = xpos - width;
        self.searchTextField.hidden = YES;
        self.searchTextField.alpha = 0;
        [self.searchTextField resignFirstResponder];
        self.searchTextField.text = kEmptyString;
        self.cancelSearchButton.hidden = YES;
        self.tableView.alpha = 1;
    }
    [self.topHeaderView layoutIfNeeded];
}

- (void)animateSearch
{
    [UIView animateWithDuration:0.3 animations:^{
        [self changeSearchMode];
    }];
}

- (void)insertRowAtTop
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self getRecordPosts];
    });
}

- (void)insertRowAtBottom
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([[self getCurrentPaginate].pageResults count]) {
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
    if ([self getCurrentPaginate].hasMoreRecords) {
        [self.tableView.infiniteScrollingView startAnimating];
        [self fetchRecordPosts];
    }else {
        [self.tableView.infiniteScrollingView stopAnimating];
    }
}

-(void)getRecordPosts
{
    [self initRecordPostsPaginate];
    [self fetchRecordPosts];
}

- (void)initRecordPostsPaginate
{
    if(self.searchButton.isSelected)
    {
        self.searchPaginate = [[Paginate alloc] initWithPageNumber:[NSNumber numberWithInt:1] withMoreRecords:YES andPerPageLimit:10];
        self.searchPaginate.details = self.searchTextField.text.trim;
        if(self.selectedFilter)
        {
            self.searchPaginate.hashTagText = self.selectedFilter.filterId;
        }
    }
    else if(self.filterButton.selected)
    {
        self.filterPaginate = [[Paginate alloc] initWithPageNumber:[NSNumber numberWithInt:1] withMoreRecords:YES andPerPageLimit:10];
        self.filterPaginate.details = self.selectedFilter.filterId;
    }
    else
    {
        self.recordPostsPaginate = [[Paginate alloc] initWithPageNumber:[NSNumber numberWithInt:1] withMoreRecords:YES andPerPageLimit:10];
    }
}

- (Paginate *)getCurrentPaginate
{
    return self.searchButton.isSelected ? self.searchPaginate : self.filterButton.isSelected ? self.filterPaginate : self.recordPostsPaginate;
}

#pragma mark - API Call

-(void)fetchRecordPosts
{
    [self showDefaultIndicatorProgress:YES];
    [self showInProgress:YES];
    [self getRecordPostsWithPaginateWithCompletionBlock:^(BOOL success, id response)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             [self.tableView.pullToRefreshView stopAnimating];
             [self.tableView.infiniteScrollingView stopAnimating];
         });
         
         if(success)
         {
             [[self getCurrentPaginate] updatePaginationWith:response];
             
             if([[self getCurrentPaginate].pageResults count] > 0)
             {
                 self.tableView.alpha = 1;
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

- (void)getRecordPostsWithPaginateWithCompletionBlock:(completionBlock)block
{
    if(self.searchButton.isSelected)
    {
        [[RequestManager alloc] getSearchRecordPostsWithPaginate:self.searchPaginate withCompletionBlock:^(BOOL success, id response)
         {
             block(success, response);
         }];
    }
    else if(self.filterButton.isSelected)
    {
        [[RequestManager alloc] getFilteredRecordPostsWithPaginate:self.filterPaginate withCompletionBlock:^(BOOL success, id response)
         {
             block(success, response);
         }];
    }
    else
    {
        [[RequestManager alloc] getRecordPostsWithPaginate:self.recordPostsPaginate withCompletionBlock:^(BOOL success, id response)
         {
             block(success, response);
         }];
    }
}

#pragma mark - Table View DataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([self getCurrentPaginate].pageResults.count > 0)
    {
        [self.noContentView setHidden:YES];
        [self.tableView setHidden:NO];
    }
    else
    {
        [self.noContentView setHidden:NO];
        [self.tableView setHidden:YES];
    }
    
    return [[self getCurrentPaginate].pageResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VideoTableViewCell *videoTableViewCell = [tableView dequeueReusableCellWithIdentifier:kVideoTableViewCellIdentifier];
    
    if (!videoTableViewCell)
    {
        videoTableViewCell = [[VideoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kVideoTableViewCellIdentifier];
    }
    
    videoTableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if([self getCurrentPaginate].pageResults.count > indexPath.row)
    {
        [videoTableViewCell assignRecordPost:[[self getCurrentPaginate].pageResults objectAtIndex:indexPath.row] playBlock:^(BOOL success, id response) {
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
    RecordPost *recordPost = [[self getCurrentPaginate].pageResults objectAtIndex:indexPath.row];
    if(recordPost){
        NSLog([NSString stringWithFormat:@"Cell tapped recordPost: %@", recordPost]);
//        self.subCategoryDetailViewController = [[UIStoryboard storyboardWithName:KProfileStoryboard bundle:nil] instantiateViewControllerWithIdentifier:kSubCategoryDetailViewController];
//        self.subCategoryDetailViewController.selectedExcercise = excercixe;
//        [self.excerciseParentViewController.navigationController pushViewController:self.subCategoryDetailViewController animated:YES];
    }
}

-(IBAction)popover:(id)sender
{
    //NSLog(@"popover retain count: %d",[popover retainCount]);
    
    SAFE_ARC_RELEASE(popover); popover=nil;
    
    //the controller we want to present as a popover
    FilterListTableController *controller = [[FilterListTableController alloc] initWithStyle:UITableViewStylePlain];
    controller.delegate = self;
    popover = [[FPPopoverKeyboardResponsiveController alloc] initWithViewController:controller];
    popover.tint = FPPopoverWhiteTint;
    popover.border = NO;
    
    popover.contentSize = CGSizeMake(200, 300);
    //sender is the UIButton view
    popover.arrowDirection = FPPopoverArrowDirectionAny;
    [popover presentPopoverFromView:sender];
    
}

-(void)selectedFilter:(FilterModel *)filter
{
    if(filter)
    {
        self.selectedFilter = [filter copy];
        self.filterButton.selected = YES;
        [self getRecordPosts];
    }
    else
    {
        self.selectedFilter = nil;
        self.filterButton.selected = NO;
        [self.tableView reloadData];
    }
    NSLog(filter.filterName);
    [popover dismissPopoverAnimated:YES];
}

@end
