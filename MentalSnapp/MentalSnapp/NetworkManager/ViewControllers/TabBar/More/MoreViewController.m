//
//  MoreViewController.m
//  MentalSnapp
//

#import "MoreViewController.h"
#import "MoreTableViewCell.h"
#import "ProfileViewController.h"
#import "SupportScreenViewController.h"
#import "TermsViewController.h"

@interface MoreViewController () <UITableViewDelegate, UITableViewDataSource> {
    NSArray *tableViewCellTitles;
    NSArray *tableViewCellTitleImageNames;
    ProfileViewController *profileViewController;
    SupportScreenViewController *supportScreenViewController;
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
    [self setNavigationBarButtonTitle:@"Mental Snapp"];
    
    tableViewCellTitles = @[@"Queued exercises", @"Profile", @"Technical support", @"Terms and conditions", @"Privacy policy"];
    tableViewCellTitleImageNames = @[@"MoreQueuedExercise", @"MoreProfile", @"MoreIssue", @"MoreReport", @"MorePolicy"];
    [self.tableView reloadData];
}

#pragma mark - IBAction methods

- (IBAction)termsButtonTapped:(id)sender {
    [self performSegueWithIdentifier:@"ToTermsScreen" sender:self];
}

#pragma mark - TableView methods
#pragma mark Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MoreTableViewCell *moreTableViewCell = [tableView dequeueReusableCellWithIdentifier:kMoreScreenTableViewCellIdentifier];
    if (!moreTableViewCell) {
        moreTableViewCell = [[MoreTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kMoreScreenTableViewCellIdentifier];
    }
    
    moreTableViewCell.headingLabel.text = tableViewCellTitles[indexPath.row];
    [moreTableViewCell.headingIconButton setImage:[UIImage imageNamed:[tableViewCellTitleImageNames objectAtIndex:indexPath.row]] forState:UIControlStateNormal];
    moreTableViewCell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return moreTableViewCell;
}

#pragma mark Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            [self performSegueWithIdentifier:kGoToQueuedExercisesScreen sender:self];
            break;
            
        case 1: {
            UIStoryboard *profileStoryboard = [UIStoryboard storyboardWithName:KProfileStoryboard bundle:nil];
            profileViewController = [profileStoryboard instantiateViewControllerWithIdentifier:KProfileViewControllerIdentifier];
            [self.navigationController pushViewController:profileViewController animated:YES];
            break;
        }
        case 2: {
            UIStoryboard *profileStoryboard = [UIStoryboard storyboardWithName:KProfileStoryboard bundle:nil];
            supportScreenViewController = [profileStoryboard instantiateViewControllerWithIdentifier:KSupportScreenViewController];
            [self.navigationController pushViewController:supportScreenViewController animated:YES];
            break;
        }
        case 3: {
            [self performSegueWithIdentifier:@"ToTermsScreen" sender:self];
            break;
        }
        case 4: {
            [self performSegueWithIdentifier:@"ToPrivacyPolicyScreen" sender:self];
            break;
        }
            
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ToTermsScreen"]) {
        TermsViewController *termsViewController = segue.destinationViewController;
        termsViewController.contentType = TermsAndCondition;
    } else if ([segue.identifier isEqualToString:@"ToPrivacyPolicyScreen"]) {
        TermsViewController *termsViewController = segue.destinationViewController;
        termsViewController.contentType = PrivacyPolicy;
    }
}

@end
