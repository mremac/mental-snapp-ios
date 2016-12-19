//
//  QueuedExercisesViewController.m
//  MentalSnapp
//

#import "QueuedExercisesViewController.h"
#import "QueuedExercisesTableViewCell.h"
#import "Paginate.h"
#import "RequestManager.h"
#import "PickerViewController.h"

@interface QueuedExercisesViewController ()<PickerViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *noContentView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) PickerViewController *pickerViewController;
@property (strong, nonatomic) Paginate *queuedExercisesPaginate;
@property (strong, nonatomic) ScheduleModel *selectedSchedule;
@end

@implementation QueuedExercisesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarButtonTitle:@"Queued Excercises"];
    [self setLeftMenuButtons:[NSArray arrayWithObject:[self backButton]]];
    
    self.pickerViewController = [[UIStoryboard storyboardWithName:KProfileStoryboard bundle:nil] instantiateViewControllerWithIdentifier:kPickerViewController];
    self.pickerViewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self.pickerViewController setPickerType:dateTime];
    [self.pickerViewController setDateSelection:futureDateOnly];
    [self.pickerViewController setDelegate:self];
    
    __unsafe_unretained QueuedExercisesViewController *weakSelf = self;
    // setup infinite scrolling
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf insertRowAtBottom];
    }];
    
    [self getQueuedExercises];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.tabBarController) {
        self.tabBarController.tabBar.hidden = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.tabBarController) {
        self.tabBarController.tabBar.hidden = NO;
    }
}

#pragma mark - Private methods

- (void)deleteRecordAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.queuedExercisesPaginate.pageResults.count > indexPath.row)
    {
        [self showInProgress:YES];
        ScheduleModel *schedule = [self.queuedExercisesPaginate.pageResults objectAtIndex:indexPath.row];
        [[RequestManager alloc] deleteSchedule:schedule withCompletionBlock:^(BOOL success, id response) {
            if(success)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSMutableArray *schedules = [NSMutableArray arrayWithArray:self.queuedExercisesPaginate.pageResults];
                    [schedules removeObjectAtIndex:indexPath.row];
                    self.queuedExercisesPaginate.pageResults = schedules;
                    
                    [self.tableView beginUpdates];
                    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                    [self.tableView endUpdates];
                });
            }
            else
            {
                [self.tableView reloadData];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showInProgress:NO];
            });
        }];
    }
}

- (void)editRecordWithDate:(NSDate *)date
{
    [self showInProgress:YES];
    self.selectedSchedule.executeAt = [NSString stringWithFormat:@"%f", [date timeIntervalSince1970]];
    [[RequestManager alloc] editSchedule:self.selectedSchedule withCompletionBlock:^(BOOL success, id response) {
        if(success)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSMutableArray *schedules = [NSMutableArray arrayWithArray:self.queuedExercisesPaginate.pageResults];
                
                NSUInteger index = [schedules indexOfObject:self.selectedSchedule];
                if(index != NSNotFound)
                {
                    ScheduleModel *schedule = [self.selectedSchedule copy];
                    [schedules replaceObjectAtIndex:index withObject:schedule];
                    self.queuedExercisesPaginate.pageResults = schedules;
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
                    [self.tableView beginUpdates];
                    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                    [self.tableView endUpdates];
                }
            });
        }
        
        self.selectedSchedule = nil;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showInProgress:NO];
        });
    }];
}

- (void)performInfinteScroll
{
    NSLog(@"performSearchResultsInfinteScroll");
    if (self.queuedExercisesPaginate.hasMoreRecords) {
        [self.tableView.infiniteScrollingView startAnimating];
        [self fetchSchedules];
    }else {
        [self.tableView.infiniteScrollingView stopAnimating];
    }
}

- (void)insertRowAtBottom
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.queuedExercisesPaginate.pageResults count]) {
            [self.tableView.infiniteScrollingView startAnimating];
            [self performInfinteScroll];
        }else {
            [self.tableView.infiniteScrollingView stopAnimating];
        }
    });
}

- (void)initGuidedPaginate {
    self.queuedExercisesPaginate = [[Paginate alloc] initWithPageNumber:[NSNumber numberWithInt:1] withMoreRecords:YES andPerPageLimit:1000];
}

#pragma mark - API Call
-(void)getQueuedExercises {
    [self initGuidedPaginate];
    [self fetchSchedules];
}

-(void)fetchSchedules {
    [self showInProgress:YES];
    [[RequestManager alloc] getScheduleListWithPagination:self.queuedExercisesPaginate withCompletionBlock:^(BOOL success, id response) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(success)
            {
                [self.queuedExercisesPaginate updatePaginationWith:response];
                if([self.queuedExercisesPaginate.pageResults count] > 0)
                {
                    [self.tableView setHidden:NO];
                    [self.noContentView setHidden:YES];
                    [self.tableView reloadData];
                }
                else
                {
                    [self.tableView setHidden:YES];
                    [self.noContentView setHidden:NO];
                }
            }
            [self.tableView.infiniteScrollingView stopAnimating];
            [self showInProgress:NO];
        });
    }];
}

#pragma mark - Table View DataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.queuedExercisesPaginate.pageResults.count > 0)
    {
        [self.noContentView setHidden:YES];
        [self.tableView setHidden:NO];
    }
    else
    {
        [self.noContentView setHidden:NO];
        [self.tableView setHidden:YES];
    }
    
    return [self.queuedExercisesPaginate.pageResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QueuedExercisesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kQueuedExercisesTableViewCellIdentifier forIndexPath:indexPath];
    if (!cell)
    {
        cell = [[QueuedExercisesTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kQueuedExercisesTableViewCellIdentifier];
    }
    if(self.queuedExercisesPaginate.pageResults.count > indexPath.row)
    {
        ScheduleModel *schedule  = [self.queuedExercisesPaginate.pageResults objectAtIndex:indexPath.row];
        if(schedule)
            [cell setContentsFromSchedule:schedule];
    }
    
    return cell;
}

#pragma mark - Table View Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(self.queuedExercisesPaginate.pageResults.count > indexPath.row)
    {
        self.selectedSchedule = [self.queuedExercisesPaginate.pageResults objectAtIndex:indexPath.row];
        if(self.selectedSchedule)
        {
            [self.pickerViewController setDateSelection:futureDateOnly];
            [[[ApplicationDelegate window] rootViewController] presentViewController:self.pickerViewController animated:YES completion:nil];
        }
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self deleteRecordAtIndexPath:indexPath];
    }
}

#pragma mark - Date Picker view Delegate
- (void)didSelectDoneButton:(NSDate *)date {
    [self editRecordWithDate:date];
}

- (void)didSelectCancelButton
{
    self.selectedSchedule = nil;
}

@end
