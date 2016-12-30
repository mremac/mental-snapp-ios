//
//  ExcerciseSubCategoryViewController.m
//  MentalSnapp
//
//  Created by Systango on 30/11/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "ExcerciseSubCategoryViewController.h"
#import "Paginate.h"
#import "RequestManager.h"
#import "SubCategoryTableViewCell.h"
#import "GuidedExcercise.h"
#import "PickerViewController.h"
#import "SubCategoryPageViewController.h"

@interface ExcerciseSubCategoryViewController () <PickerViewControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) Paginate *guidedExcercisePaginate;

@property (strong, nonatomic) IBOutlet UIView *topHeadingView;
@property (strong, nonatomic) IBOutlet UILabel *excerciseDetailLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *noContentView;
@property (strong, nonatomic) IBOutlet UIButton *calenderButton;
@property (strong, nonatomic) IBOutlet UIButton *recordButton;
@property (strong, nonatomic) PickerViewController *pickerViewController;
@property (strong, nonatomic) GuidedExcercise *selectedExcercise;
@property (strong, nonatomic) GuidedExcercise *calendarExcercise;

@end

@implementation ExcerciseSubCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    __unsafe_unretained ExcerciseSubCategoryViewController *weakSelf = self;
    // setup infinite scrolling
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf insertRowAtBottom];
    }];
    self.pickerViewController = [[UIStoryboard storyboardWithName:KProfileStoryboard bundle:nil] instantiateViewControllerWithIdentifier:kPickerViewController];
    self.pickerViewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self.pickerViewController setPickerType:dateTime];
    [self.pickerViewController setDateSelection:futureDateOnly];
    [self.pickerViewController setDelegate:self];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.excerciseDetailLabel setText:self.excercise.excerciseDescription.trim];
        [self.view layoutIfNeeded];
        [self getGuidedExcercise];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private methods

- (void)performInfinteScroll
{
    NSLog(@"performSearchResultsInfinteScroll");
    if (self.guidedExcercisePaginate.hasMoreRecords) {
        [self.tableView.infiniteScrollingView startAnimating];
        [self fetchGuidedExcercise];
        // [self performMyMusicTracksAPICall];
    }else {
        [self.tableView.infiniteScrollingView stopAnimating];
    }
}


- (void)insertRowAtBottom
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.guidedExcercisePaginate.pageResults count]) {
            [self.tableView.infiniteScrollingView startAnimating];
            [self performInfinteScroll];
        }else {
            [self.tableView.infiniteScrollingView stopAnimating];
        }
    });
}

- (void)initGuidedPaginate {
    self.guidedExcercisePaginate = [[Paginate alloc] initWithPageNumber:[NSNumber numberWithInt:1] withMoreRecords:YES andPerPageLimit:10];
    self.guidedExcercisePaginate.details = self.excercise.excerciseId;
}

#pragma mark - API Call
-(void)getGuidedExcercise {
    [self initGuidedPaginate];
    [self fetchGuidedExcercise];
}

-(void)fetchGuidedExcercise {
    [self showDefaultIndicatorProgress:YES];
    [[RequestManager alloc] getSubCategoryExcerciseWithPaginate:self.guidedExcercisePaginate withCompletionBlock:^(BOOL success, id response) {
        if(success){
            [self.guidedExcercisePaginate updatePaginationWith:response];
            if([self.guidedExcercisePaginate.pageResults count]>0){
                [self.tableView setHidden:NO];
                [self.noContentView setHidden:YES];
                [self.tableView reloadData];
            } else {
                [self.tableView setHidden:YES];
                [self.noContentView setHidden:NO];
            }
        }
        [self showDefaultIndicatorProgress:NO];
        [self showInProgress:NO];
    }];
}

- (void)editRecordWithDate:(NSDate *)date
{
    [self showInProgress:YES];
    ScheduleModel *schedule = [[ScheduleModel alloc] init];
    schedule.exercise = self.calendarExcercise;
    
    schedule.executeAt = [NSString stringWithFormat:@"%f", [date timeIntervalSince1970]];
    [[RequestManager alloc] createSchedule:schedule withCompletionBlock:^(BOOL success, id response) {
        if(success && [response isKindOfClass:[ScheduleModel class]])
        {
            ScheduleModel *scheduleModel = response;
            NSString *dateTimeValue = [Util displayDateWithTimeInterval:[scheduleModel.executeAt integerValue]];
            NSString *message = [NSString stringWithFormat:@"Exercise scheduled on %@.", dateTimeValue];
            [[ScheduleManager sharedInstance] modifyScheduledNotifications:scheduleModel];
            [Banner showSuccessBannerWithSubtitle:message];
            
        }
        [self showInProgress:NO];
    }];
}

#pragma mark - Table View DataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.guidedExcercisePaginate.pageResults.count>0){
        [self.noContentView setHidden:YES];
    }
    return [self.guidedExcercisePaginate.pageResults count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SubCategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSubCategoryExcerciseTableViewCell forIndexPath:indexPath];
    if (!cell)
    {
        cell = [[SubCategoryTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSubCategoryExcerciseTableViewCell];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    [cell setTag:indexPath.row];
    cell.calenderButton.tag = cell.recordButton.tag = indexPath.row;
    
    [cell.calenderButton addTarget:self action:@selector(subcategoryCalenderAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.recordButton addTarget:self action:@selector(subcategoryRecordAction:) forControlEvents:UIControlEventTouchUpInside];

    GuidedExcercise *excercixe  = [self.guidedExcercisePaginate.pageResults objectAtIndex:indexPath.row];
    if(excercixe)
        [cell setContentsFromExcercise:excercixe];
    
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
    
    if(self.guidedExcercisePaginate.pageResults.count > indexPath.row)
    {
        SubCategoryPageViewController *subCategoryPageViewController = [[UIStoryboard storyboardWithName:KProfileStoryboard bundle:nil] instantiateViewControllerWithIdentifier:kSubCategoryPageViewController];
        subCategoryPageViewController.exerciseList = self.guidedExcercisePaginate.pageResults;
        subCategoryPageViewController.currentIndex = indexPath.row;
        [self.excerciseParentViewController.navigationController pushViewController:subCategoryPageViewController animated:YES];
    }
}

#pragma mark - Date Picker view Delegate
- (void)didSelectDoneButton:(NSDate *)date {
    [self editRecordWithDate:date];
}

- (void)didSelectCancelButton {}

#pragma mark - Image picker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - IBActions

-(IBAction)subcategoryCalenderAction:(id)sender {
    _selectedExcercise  = [self.guidedExcercisePaginate.pageResults objectAtIndex:[sender tag]];
    self.calendarExcercise = [_selectedExcercise copy];
    [self.pickerViewController updatePickerDate:[NSDate date]];
    [[[ApplicationDelegate window] rootViewController] presentViewController:self.pickerViewController animated:YES completion:nil];
}

-(IBAction)subcategoryRecordAction:(id)sender {
    _selectedExcercise  = [self.guidedExcercisePaginate.pageResults objectAtIndex:[sender tag]];
    [Util openCameraForRecordExercise:_selectedExcercise];
}

-(IBAction)guidedExcerciseCalenderAction:(id)sender {
    self.calendarExcercise = [self.excercise copy];
    [self.pickerViewController updatePickerDate:[NSDate date]];
    [[[ApplicationDelegate window] rootViewController] presentViewController:self.pickerViewController animated:YES completion:nil];
}

-(IBAction)guidedExcerciseRecordAction:(id)sender {
    [Util openCameraForRecordExercise:self.excercise];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
