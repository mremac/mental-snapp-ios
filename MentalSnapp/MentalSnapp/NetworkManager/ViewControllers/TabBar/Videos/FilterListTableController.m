//
//  FilterListTableController.m
//  MentalSnapp
//
//  Created by Systango on 13/12/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "FilterListTableController.h"
#import "VideosViewController.h"
#import "RequestManager.h"
#import "Paginate.h"

@implementation FilterListTableController
@synthesize delegate=_delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"";
    self.filterListPaginate = [[Paginate alloc] initWithPageNumber:[NSNumber numberWithInt:1] withMoreRecords:YES andPerPageLimit:1000];
    [self getFilterList];
    
    __unsafe_unretained FilterListTableController *weakSelf = self;
    
    // setup infinite scrolling
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf insertRowAtBottom];
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.filterListPaginate.pageResults.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    if((self.filterListPaginate.pageResults.count +1) > indexPath.row)
    {
        if(indexPath.row == 0)
        {
            cell.textLabel.text = @"None";
            
            if(self.filterListPaginate.details && self.filterListPaginate.details.length)
            {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            else
            {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
        }
        else
        {
            FilterModel *filter = [self.filterListPaginate.pageResults objectAtIndex:(indexPath.row - 1)];
            cell.textLabel.text = filter.filterName;
            
            if([self.filterListPaginate.details isEqualToString:filter.filterId])
            {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            else
            {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if([self.delegate respondsToSelector:@selector(selectedFilter:)])
    {
        if((self.filterListPaginate.pageResults.count +1) > indexPath.row)
        {
            FilterModel *filter = nil;
            if(indexPath.row != 0)
            {
                filter = [self.filterListPaginate.pageResults objectAtIndex:(indexPath.row - 1)];
            }
            
            [self.delegate selectedFilter:filter];
        }
    }
}

#pragma mark - Private methods

- (void)insertRowAtBottom
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.filterListPaginate.pageResults count]) {
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
    if (self.filterListPaginate.hasMoreRecords) {
        [self.tableView.infiniteScrollingView startAnimating];
        [self getFilterList];
    }else {
        [self.tableView.infiniteScrollingView stopAnimating];
    }
}

- (void)showInProgress:(BOOL)state {
    if(state) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [JTProgressHUD show];
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [JTProgressHUD hide];
        });
    }
}

- (void)getFilterList
{
    [self showInProgress:YES];
    
    [[RequestManager alloc] getFilterListWithPagination:self.filterListPaginate withCompletionBlock:^(BOOL success, id response)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             [self.tableView.infiniteScrollingView stopAnimating];
         });
         
         if(success)
         {
             [self.filterListPaginate updatePaginationWith:response];
//             NSMutableArray *array = [[NSMutableArray alloc] initWithArray:self.filterListPaginate.pageResults];
//             FilterModel *filter = [FilterModel new];
//             filter.filterName = @"Freeform";
//             filter.filterId = @"0";
//             filter.filterType = @"";
//             [array insertObject:filter atIndex:0];
//             self.filterListPaginate.pageResults = array;
             if([self.filterListPaginate.pageResults count] > 0)
             {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self.tableView reloadData];
                 });
             }
         }
         
         [self showInProgress:NO];
     }];
}

#pragma mark - Public methods

- (void)reloadData
{
    [self.tableView reloadData];
}




@end
