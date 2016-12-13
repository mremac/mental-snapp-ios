//
//  VideosViewController.m
//  MentalSnapp
//
//  Created by Systango on 13/12/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "VideosViewController.h"
#import "VideoTableViewCell.h"
#import "RecordPost.h"

@interface VideosViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *recordPosts;
@end

@implementation VideosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarButtonTitle:@"Mental Snapp"];
    self.recordPosts = [NSMutableArray array];
    RecordPost *record = [[RecordPost alloc] initWithVideoName:@"test" andExcerciseType:@"Test" andCoverURL:@"https://www.google.co.in/imgres?imgurl=http%3A%2F%2Fwww.linuxnix.com%2Fwp-content%2Fuploads%2F2014%2F12%2Faws.png&imgrefurl=http%3A%2F%2Fwww.linuxnix.com%2Funderstanding-awsamazon-web-services-cloud-part%2F&docid=b3DY1C1iOa6iaM&tbnid=Ko7PBMPCZdxClM%3A&vet=1&w=300&h=300&safe=active&bih=533&biw=1150&q=aws%20image&ved=0ahUKEwjPnYvjkPHQAhVLOY8KHXdECc4QMwgcKAEwAQ&iact=mrc&uact=8" andPostDesciption:@"#start #happy #fun #enjoy #health #happy #fun #enjoy #health #happy #fun #enjoy #health #happy #fun #enjoy #health #happy #fun #enjoy #health #happy #fun #enjoy #health #happy #fun #enjoy #health #happy #fun #enjoy #health #happy #fun #enjoy #health #love #happy #fun #enjoy #health #happy #fun #enjoy #health #happy #fun #enjoy #health #happy #fun #enjoy #health #end" andVideoURL:@"" andUserId:@"1" andMoodId:@"1" andFeelingId:@"1" andWithExcercise:nil];
    [self.recordPosts addObject:record];
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

#pragma mark - TableView datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VideoTableViewCell *videoTableViewCell = [tableView dequeueReusableCellWithIdentifier:kVideoTableViewCellIdentifier];
    
    if (!videoTableViewCell)
    {
        videoTableViewCell = [[VideoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kVideoTableViewCellIdentifier];
    }
    
    if(self.recordPosts.count > indexPath.row)
    {
        [videoTableViewCell assignRecordPost:[self.recordPosts objectAtIndex:indexPath.row] playBlock:^(BOOL success, id response) {
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

#pragma mark - TableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 400;
}


#pragma mark - Private methods

#pragma mark - IBActions

- (IBAction)filterButtonTapped:(id)sender {
}
- (IBAction)searchButtonTapped:(id)sender {
}

@end
