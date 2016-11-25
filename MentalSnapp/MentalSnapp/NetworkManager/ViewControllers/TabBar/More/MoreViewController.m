//
//  MoreViewController.m
//  MentalSnapp
//

#import "MoreViewController.h"
#import "MoreTableViewCell.h"

@interface MoreViewController () <UITableViewDelegate, UITableViewDataSource> {
    NSArray *tableViewCellTitles;
}

@property(weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialSetup];
}

#pragma mark - Private methods

- (void)initialSetup {
    [self setNavigationBarButtonTitle:@"More"];
    
    tableViewCellTitles = @[@"Queued Exercises", @"Profile", @"Report an Issue"];
    [self.tableView reloadData];
}

#pragma mark - TableView methods
#pragma mark Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MoreTableViewCell *moreTableViewCell = [tableView dequeueReusableCellWithIdentifier:kMoreScreenTableViewCellIdentifier];
    if (!moreTableViewCell) {
        moreTableViewCell = [[MoreTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kMoreScreenTableViewCellIdentifier];
    }
    
    moreTableViewCell.headingLabel.text = tableViewCellTitles[indexPath.row];
    moreTableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return moreTableViewCell;
}

#pragma mark Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            [self performSegueWithIdentifier:kGoToQueuedExercisesScreen sender:self];
            break;
        case 1:
            
            break;
        case 2:
            [self performSegueWithIdentifier:kGoToReportIssueScreen sender:self];
            break;
            
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

@end
