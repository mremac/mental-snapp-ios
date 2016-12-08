//
//  FeelingListViewController.m
//  MentalSnapp
//
//  Created by Systango on 09/12/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "FeelingListViewController.h"
#import "Paginate.h"
#import "FeelingTableViewCell.h"
#import "RequestManager.h"

@interface FeelingListViewController ()
{
    BOOL isSearchInProgress;
}
@property (strong, nonatomic) Paginate *paginate;
@property (strong, nonatomic) Paginate *searchPaginate;

@property (strong, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) Feeling *selectedNewFeeling;
@property (strong, nonatomic) FeelingTableViewCell *selectedCell;
@end

@implementation FeelingListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationBarButtonTitle:@"Feelings"];
    [self setLeftMenuButtons:[NSArray arrayWithObjects:[self backButton], nil]];
    [self setRightMenuButtons:[NSArray arrayWithObjects:[self doneButton], nil]];
    [self searchInProgress:NO];
    UIColor *color = [UIColor colorWithRed:135.0/255.0 green:215.0/255.0 blue:226.0/255.0 alpha:1.0];
    self.searchTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"search" attributes:@{NSForegroundColorAttributeName:color}];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [self getFeelings];
    __unsafe_unretained FeelingListViewController *weakSelf = self;
    // setup infinite scrolling
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf insertRowAtBottom];
    }];
    
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
- (UIBarButtonItem *)doneButton {
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 4, 30, 30)];
    [leftButton setImage:[UIImage imageNamed:@"doneFeeling"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(doneButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    return leftBarButton;
}

- (void)updatePaginateDetails {
    self.paginate = [[Paginate alloc] initWithPageNumber:[NSNumber numberWithInt:1] withMoreRecords:YES andPerPageLimit:50];
    self.paginate.pageResults = [NSArray new];
}

-(void)updateSearchDeatil:(NSString *)searchText {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"feelingName contains[cd] %@",searchText];
    NSArray *array = [self.paginate.pageResults filteredArrayUsingPredicate:predicate];
    if(array.count>0){
        self.searchPaginate = [[Paginate alloc] initWithPageNumber:[NSNumber numberWithInt:1] withMoreRecords:YES andPerPageLimit:50];
        self.searchPaginate.details = searchText;
        self.searchPaginate.pageResults = array;
        self.searchPaginate.pageNumber = [NSNumber numberWithInt:1];
        self.searchPaginate.hasMoreRecords = YES;
        [self.tableView reloadData];
    } else {
        [Banner showFailureBannerOnTopWithTitle:@"Not Found" subtitle:[NSString stringWithFormat:@"No feeling found with '%@'",searchText]];
    }
}

- (void)performSearch:(NSString *)searchText {
    [self getSearchResultsFor:searchText];
}

- (void)getSearchResultsFor:(NSString *)searchText
{
    [self updateSearchDeatil:searchText];
}

- (void)searchInProgress:(BOOL)state
{
    isSearchInProgress = state;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadSectionIndexTitles];
        [self.tableView reloadData];
    });
}

- (void)insertRowAtBottom
{
    dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.paginate.pageResults count]) {
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
        if (self.paginate.hasMoreRecords) {
            [self.tableView.infiniteScrollingView startAnimating];
            [self fetchFeelings];
        }else {
            [self.tableView.infiniteScrollingView stopAnimating];
        }
}

#pragma mark - API Call
-(void)getFeelings {
    [self updatePaginateDetails];
    [self fetchFeelings];
}

-(void)fetchFeelings {
    [self showInProgress:YES];
    [[RequestManager alloc] getFeelingWithPaginate:self.paginate withCompletionBlock:^(BOOL success, id response) {
        if(success){
            [self.paginate updatePaginationWith:response];
            if([self.paginate.pageResults count]>0){
                [self.tableView reloadData];
            }
        }
        [self showInProgress:NO];
    }];
}



#pragma mark - KeyBoard Show/Hide Delegate

- (void)keyboardWillShow:(NSNotification *)note {
    [self searchInProgress:YES];
}

- (void)keyboardWillHide:(NSNotification *)note {
    [self searchInProgress:NO];
}

#pragma mark - Table View DataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(isSearchInProgress){
        return self.searchPaginate.pageResults.count;
    }
    return self.paginate.pageResults.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeelingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFeelingTableViewCell forIndexPath:indexPath];
    if (!cell)
    {
        cell = [[FeelingTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kFeelingTableViewCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell.bgView setBackgroundColor:[UIColor whiteColor]];
    [cell.checkmarkImage setHidden:YES];
    Feeling *feeling;
    if(isSearchInProgress){
        feeling = [[self.searchPaginate pageResults] objectAtIndex:indexPath.row];
    } else {
        feeling = [[self.paginate pageResults] objectAtIndex:indexPath.row];
    }
    
    if([self.selectedFeeling.feelingId isEqualToString:feeling.feelingId]){
        _selectedCell = cell;
        [cell.bgView setBackgroundColor:[UIColor colorWithRed:252.0/255.0 green:232.0/255.0 blue:226.0/255.0 alpha:1.0]];
        [cell.checkmarkImage setHidden:NO];
    }

    [cell.nameLabel setText:feeling.feelingName];
    return cell;
}

#pragma mark - Table View Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(_selectedCell){
        [_selectedCell.bgView setBackgroundColor:[UIColor whiteColor]];
         [_selectedCell.checkmarkImage setHidden:YES];
    }
    
    if(isSearchInProgress){
        _selectedNewFeeling = [[self.searchPaginate pageResults] objectAtIndex:indexPath.row];
    } else {
        _selectedNewFeeling = [[self.paginate pageResults] objectAtIndex:indexPath.row];
    }
    _selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    [_selectedCell.bgView setBackgroundColor:[UIColor colorWithRed:252.0/255.0 green:232.0/255.0 blue:226.0/255.0 alpha:1.0]];
     [_selectedCell.checkmarkImage setHidden:NO];
}

#pragma mark  - TextField Delegates

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    //[self toolBarCancelButtonAction:nil];
    [self searchInProgress:YES];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return YES;
}  // return NO to not change text

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self searchInProgress:NO];
    [self performSearch:textField.text];
    return YES;
}

#pragma mark - IBActions
- (IBAction)doneButtonAction:(id)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(didSelectFeeling:)]){
        [self.delegate didSelectFeeling:_selectedNewFeeling];
    }
    [self.navigationController popViewControllerAnimated:NO];
}

@end
