//
//  StatsViewController.m
//  MentalSnapp
//

#import "StatsViewController.h"
#import "HACBarChart.h"
#import "RequestManager.h"

static const CGFloat barChartHeight = 160.0;
static const CGFloat lineChartHeight = 185.0;
static const CGFloat barChartCellHeight = 210.0;
static const CGFloat lineChartCellHeight = 185.0;

@interface StatsViewController (){
    NSArray *data;
}
@property (strong, nonatomic) StatsModel *stats;
@property (strong, nonatomic) HACBarChart *barChartView;
@property (strong, nonatomic) UILabel *barChartLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *noContentView;

@end

@implementation StatsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialiseBarView];
    [self getStatsAPIForMonth:[[NSDate date] month] andYear:[[NSDate date] year]];
}

- (void)viewWillAppear:(BOOL)animated {
    [self setNavigationBarButtonTitle:@"Mental Snapp"];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.barChartView draw];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.stats)
    {
        [self.noContentView setHidden:YES];
        [self.tableView setHidden:NO];
    }
    else
    {
        [self.noContentView setHidden:NO];
        [self.tableView setHidden:YES];
    }
    
    return (section == 0) ? 0 : 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = @"test";
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 0)
        return [self getBarChartView];
    else
        return [self getLineChartView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (section == 0) ? barChartCellHeight : lineChartCellHeight;
}

#pragma mark - Private methods

- (UIView *)getBarChartView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, barChartHeight)];
    
    [view addSubview:self.barChartView];
    [view addSubview:self.barChartLabel];
    [self updateBarChartInfo];
    return view;
}

- (UIView *)getLineChartView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, lineChartHeight)];
    UIView *lineChartView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, lineChartHeight)];
    lineChartView.backgroundColor = [UIColor appGreenColor];
    [view addSubview:lineChartView];
    return view;
}

- (void)initialiseBarView
{
    [self initBarChartView];
    [self initBarChartLabelView];
}

- (void)initBarChartView
{
    self.barChartView = [[HACBarChart alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, barChartHeight)];
    data = @[
             @{kHACPercentage:@86, kHACColor  : [Util getMoodColor:1], kHACCustomText : @"The Best\n86%"},
             @{kHACPercentage:@50,  kHACColor  : [Util getMoodColor:2], kHACCustomText : @"Very Good\n50%"},
             @{kHACPercentage:@75,  kHACColor  : [Util getMoodColor:3], kHACCustomText : @"Good\n75%"},
             @{kHACPercentage:@25,  kHACColor  : [Util getMoodColor:4], kHACCustomText : @"OK\n25%"},
             @{kHACPercentage:@40,  kHACColor  : [Util getMoodColor:5], kHACCustomText : @"Bad\n40%"},
             @{kHACPercentage:@30,  kHACColor  : [Util getMoodColor:6], kHACCustomText : @"Very Bad\n30%"},
             @{kHACPercentage:@10,  kHACColor  : [Util getMoodColor:7], kHACCustomText : @"The Worst\n10%"}
             ];
    
    // Assign data in bar chart
    self.barChartView.data = data;
    self.barChartView.vertical = YES;
    self.barChartView.showProgressLabel = YES;
    self.barChartView.showDataValue = YES;
    self.barChartView.showCustomText = YES;
    self.barChartView.numberDividersAxisY = 5;
    self.barChartView.dashedLineColor = [UIColor clearColor];
    self.barChartView.typeBar = HACBarType2;
}


- (void)initBarChartLabelView
{
    // Set bar chart Y axis label
    self.barChartLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, barChartHeight + 25, self.view.frame.size.width, 18)];
    [self.barChartLabel setFont:[UIFont fontWithName:@"Roboto" size:13]];
    self.barChartLabel.textAlignment = NSTextAlignmentCenter;
    [self.barChartLabel setText:@"December"];
    [self.barChartLabel setTextColor:[UIColor appUpdatesBlueColor]];
}

- (void)updateBarChartInfo
{
    //TODO: iterate response as per its keys
    data = @[
             @{kHACPercentage:@86, kHACColor  : [Util getMoodColor:1], kHACCustomText : @"The Best\n86%"},
             @{kHACPercentage:@50,  kHACColor  : [Util getMoodColor:2], kHACCustomText : @"Very Good\n50%"},
             @{kHACPercentage:@75,  kHACColor  : [Util getMoodColor:3], kHACCustomText : @"Good\n75%"},
             @{kHACPercentage:@25,  kHACColor  : [Util getMoodColor:4], kHACCustomText : @"OK\n25%"},
             @{kHACPercentage:@40,  kHACColor  : [Util getMoodColor:5], kHACCustomText : @"Bad\n40%"},
             @{kHACPercentage:@30,  kHACColor  : [Util getMoodColor:6], kHACCustomText : @"Very Bad\n30%"},
             @{kHACPercentage:@10,  kHACColor  : [Util getMoodColor:7], kHACCustomText : @"The Worst\n10%"}
             ];
    
    // Assign data in bar chart
    self.barChartView.data = data;
    self.barChartLabel.text = @"Dec.";
}

#pragma mark - API

- (void)getStatsAPIForMonth:(NSInteger)month andYear:(NSInteger)year
{
    [self showInProgress:YES];
    [[RequestManager alloc] getStatsForMonth:month andYear:year withCompletionBlock:^(BOOL success, id response) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(success)
            {
                if(response && [response isKindOfClass:[StatsModel class]])
                {
                    self.stats = response;
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
            [self showInProgress:NO];
        });
    }];
}

@end
