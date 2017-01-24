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

@property (strong, nonatomic) Paginate *paginate;
@property (strong, nonatomic) Paginate *searchPaginate;

@property (strong, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) Feeling *selectedNewFeeling;
@property (strong, nonatomic) FeelingTableViewCell *selectedCell;
@property (assign, nonatomic) BOOL isSearchInProgress;

@end

@implementation FeelingListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Add a "textFieldDidChange" notification method to the text field control.
    [self.searchTextField addTarget:self
                  action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];
    
    [self setNavigationBarButtonTitle:@"Feelings"];
    self.navigationItem.hidesBackButton = YES;
    [self setRightMenuButtons:[NSArray arrayWithObjects:[self doneButton], nil]];
    
    UIColor *color = [UIColor colorWithRed:135.0/255.0 green:215.0/255.0 blue:226.0/255.0 alpha:1.0];
    self.searchTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Search" attributes:@{NSForegroundColorAttributeName:color}];

    if(self.selectedFeeling){
        self.selectedNewFeeling = self.selectedFeeling;
    }
    
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

#pragma mark - Private methods

- (UIBarButtonItem *)doneButton
{
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 52, 30)];
    leftButton.backgroundColor = [UIColor clearColor];
    [leftButton setImage:[UIImage imageNamed:@"doneButton"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(doneButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    return leftBarButton;
}

- (void)updatePaginateDetails {
    self.paginate = [[Paginate alloc] initWithPageNumber:[NSNumber numberWithInt:1] withMoreRecords:YES andPerPageLimit:100];
    self.paginate.pageResults = [NSArray new];
}

-(void)updateSearchDeatil:(NSString *)searchText {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"feelingName contains[cd] %@",searchText];
    //NSArray *array = [self.paginate.pageResults filteredArrayUsingPredicate:predicate];
    NSMutableArray *filteredArrayList = [NSMutableArray new];
    for (NSMutableDictionary *dictionary in self.paginate.pageResults) {
        NSArray *array = dictionary[@"sub_feelings"];
        array = [array filteredArrayUsingPredicate:predicate];
        if(array.count>0){
            NSMutableDictionary *dictionaryFiltered = [dictionary mutableCopy];
            [dictionaryFiltered setValue:array forKey:@"sub_feelings"];
            [filteredArrayList addObject:dictionaryFiltered];
        }
    }
    
    
    if(filteredArrayList.count > 0){
        self.searchPaginate = [[Paginate alloc] initWithPageNumber:[NSNumber numberWithInt:1] withMoreRecords:YES andPerPageLimit:100];
        self.searchPaginate.details = searchText;
        self.searchPaginate.pageResults = filteredArrayList;
        self.searchPaginate.pageNumber = [NSNumber numberWithInt:1];
        self.searchPaginate.hasMoreRecords = YES;
        [self.tableView reloadData];
    } else {
        [Banner showFailureBannerOnTopWithTitle:@"Not Found" subtitle:[NSString stringWithFormat:@"No feeling found with '%@'",searchText]];
    }
}

- (void)performSearch:(NSString *)searchText
{
    if(searchText.trim.length > 0)
    {
        [self hasSearchInProgress:YES];
        [self updateSearchDeatil:searchText];
    }
    else
    {
        [self hasSearchInProgress:NO];
    }
}

- (void)hasSearchInProgress:(BOOL)state
{
    self.isSearchInProgress = state;
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
    NSLog(@"performInfinteScroll");
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

#pragma mark - Table View DataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(self.isSearchInProgress)
    {
        return self.searchPaginate.pageResults.count;
    }
    return self.paginate.pageResults.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.isSearchInProgress)
    {
        NSDictionary *dictionary = [self.searchPaginate.pageResults objectAtIndex:section];
        NSArray *arraySearchofFeeling = dictionary[@"sub_feelings"];
        return arraySearchofFeeling.count;
    }
    NSDictionary *dictionary = [self.paginate.pageResults objectAtIndex:section];
    NSArray *arrayofFeeling = dictionary[@"sub_feelings"];
    return arrayofFeeling.count;
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
    [cell.feelingColorButton setBackgroundColor:[UIColor clearColor]];
    [cell.checkmarkImage setHidden:YES];
    Feeling *feeling;
    NSArray *arrayFeelings;
    if(self.isSearchInProgress) {
        NSDictionary *dictionary = [self.searchPaginate.pageResults objectAtIndex:indexPath.section];
        arrayFeelings = dictionary[@"sub_feelings"];
    } else {
        NSDictionary *dictionary = [self.paginate.pageResults objectAtIndex:indexPath.section];
        arrayFeelings = dictionary[@"sub_feelings"];
    }
    
    feeling = [arrayFeelings objectAtIndex:indexPath.row];
    
    if([self.selectedFeeling.feelingId isEqualToString:feeling.feelingId]){
        _selectedCell = cell;
//        [cell.bgView setBackgroundColor:[UIColor colorWithRed:252.0/255.0 green:232.0/255.0 blue:226.0/255.0 alpha:1.0]];
        [cell.checkmarkImage setHidden:NO];
    }
    [cell.feelingColorButton setBackgroundColor:[UIColor colorWithRed:[feeling.feelingRedColor floatValue]/255.0 green:[feeling.feelingGreenColor floatValue]/255.0 blue:[feeling.feelingBlueColor floatValue]/255.0 alpha:1.0]];
    [cell.nameLabel setText:feeling.feelingName];
    return cell;
}

#pragma mark - Table View Delegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    NSDictionary *dictionary;
    if(self.isSearchInProgress) {
        dictionary = [self.searchPaginate.pageResults objectAtIndex:section];
    } else {
        dictionary = [self.paginate.pageResults objectAtIndex:section];
    }
    CGFloat red = [dictionary[@"red"] floatValue];
    CGFloat green = [dictionary[@"green"] floatValue];
    CGFloat blue = [dictionary[@"blue"] floatValue];
    [view setBackgroundColor:[UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1.0f]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-20, 44)];
    NSString *stringName = dictionary[@"name"];
    [label setText:stringName.uppercaseString];
    [label setTextColor:[UIColor whiteColor]];
    [label setFont:[UIFont fontWithName:@"Roboto" size:16]];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextAlignment:NSTextAlignmentLeft];
    [view addSubview:label];
    return view;
}

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
    
    NSArray *arrayFeelings;
    if(self.isSearchInProgress) {
        NSDictionary *dictionary = [self.searchPaginate.pageResults objectAtIndex:indexPath.section];
        arrayFeelings = dictionary[@"sub_feelings"];
    } else {
        NSDictionary *dictionary = [self.paginate.pageResults objectAtIndex:indexPath.section];
        arrayFeelings = dictionary[@"sub_feelings"];
    }
    
    _selectedNewFeeling = [arrayFeelings objectAtIndex:indexPath.row];
    _selectedCell = [tableView cellForRowAtIndexPath:indexPath];
//   [_selectedCell.bgView setBackgroundColor:[UIColor colorWithRed:252.0/255.0 green:232.0/255.0 blue:226.0/255.0 alpha:1.0]];
     [_selectedCell.checkmarkImage setHidden:NO];
}

#pragma mark  - TextField Delegates

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self performSearch:textField.text.trim];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    [self hasSearchInProgress:NO];
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    [self performSearch:textField.text.trim];
}

#pragma mark - IBActions
- (IBAction)doneButtonAction:(id)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(didSelectFeeling:)]){
        [self.delegate didSelectFeeling:_selectedNewFeeling];
    }
    [self.navigationController popViewControllerAnimated:NO];
}

@end
