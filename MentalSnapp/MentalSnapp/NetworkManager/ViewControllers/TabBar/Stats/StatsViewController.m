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

@interface StatsViewController ()
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
    [self updateBarChartInfo];
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
    self.barChartView = [[HACBarChart alloc] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, barChartHeight)];
    
    // Assign data in bar chart
    
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
    self.barChartLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, barChartHeight + 15, self.view.frame.size.width, 18)];
    [self.barChartLabel setFont:[UIFont fontWithName:@"Roboto" size:13]];
    self.barChartLabel.textAlignment = NSTextAlignmentCenter;
    [self.barChartLabel setTextColor:[UIColor appUpdatesBlueColor]];
}

- (void)updateBarChartInfo
{
    NSMutableArray *statsData = [NSMutableArray array];
    if(self.stats.barChartMoodData.theBestMood)
        [statsData addObject:@{kHACPercentage:(self.stats.barChartMoodData.theBestMood), kHACColor  : [Util getMoodColor:1], kHACCustomText : [NSString stringWithFormat:@"The Best\n%@%%", (self.stats.barChartMoodData.theBestMood)]}];
    if(self.stats.barChartMoodData.veryGoodMood)
        [statsData addObject:@{kHACPercentage:(self.stats.barChartMoodData.veryGoodMood),  kHACColor  : [Util getMoodColor:2], kHACCustomText : [NSString stringWithFormat:@"Very Good\n%@%%", (self.stats.barChartMoodData.veryGoodMood)]}];
    if(self.stats.barChartMoodData.goodMood)
        [statsData addObject:@{kHACPercentage:(self.stats.barChartMoodData.goodMood),  kHACColor  : [Util getMoodColor:3], kHACCustomText : [NSString stringWithFormat:@"Good\n%@%%", (self.stats.barChartMoodData.goodMood)]}];
    if(self.stats.barChartMoodData.okMood)
        [statsData addObject:@{kHACPercentage:(self.stats.barChartMoodData.okMood),  kHACColor  : [Util getMoodColor:4], kHACCustomText : [NSString stringWithFormat:@"OK\n%@%%", (self.stats.barChartMoodData.okMood)]}];
    if(self.stats.barChartMoodData.badMood)
        [statsData addObject:@{kHACPercentage:(self.stats.barChartMoodData.badMood),  kHACColor  : [Util getMoodColor:5], kHACCustomText : [NSString stringWithFormat:@"Bad\n%@%%", (self.stats.barChartMoodData.badMood)]}];
    if(self.stats.barChartMoodData.veryBadMood)
        [statsData addObject:@{kHACPercentage:(self.stats.barChartMoodData.veryBadMood),  kHACColor  : [Util getMoodColor:6], kHACCustomText : [NSString stringWithFormat:@"Very Bad\n%@%%", (self.stats.barChartMoodData.veryBadMood)]}];
    if(self.stats.barChartMoodData.theWorstMood)
        [statsData addObject:@{kHACPercentage:(self.stats.barChartMoodData.theWorstMood),  kHACColor  : [Util getMoodColor:7], kHACCustomText : [NSString stringWithFormat:@"The Worst\n%@%%", (self.stats.barChartMoodData.theWorstMood)]}];
    
    self.barChartView.data = [NSArray arrayWithArray:statsData];
    [self.barChartView clearChart];
    [self.barChartView draw];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM yyyy"];
    self.barChartLabel.text = [formatter stringFromDate:self.stats.selectedDate ? self.stats.selectedDate : [NSDate date]];
    
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
                    self.stats.selectedDate = [NSDate dateWithYear:year month:month day:1];
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
