//
//  PlayerViewController.m
//  MentalSnapp
//
//  Created by Systango on 16/12/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "PlayerViewController.h"
#import "RecordPost.h"
#import <GoogleAnalytics/GAI.h>

@import AVFoundation;
@import AVKit;

@interface PlayerViewController ()

@end

@implementation PlayerViewController

- (void)viewWillAppear:(BOOL)animated{
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker set:kGAIScreenName value:@"Download-Videos"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationBarButtonTitle:self.recordPost.postName];
    [self setLeftMenuButtons:[NSArray arrayWithObject:[self backButton]]];
    [self setupPlayer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private methods

- (void)setupPlayer
{
    // grab a local URL to our video
    NSURL *videoURL = [NSURL URLWithString:self.recordPost.videoURL];
    // create an AVPlayer
    AVPlayer *player = [AVPlayer playerWithURL:videoURL];
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    [playerLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    // create a player view controller
    AVPlayerViewController *controller = [[AVPlayerViewController alloc]init];
    controller.player = player;
    [player play];
    
    // show the view controller
    [self addChildViewController:controller];
    [self.view addSubview:controller.view];
    CGRect frame = CGRectMake(0, -40, self.view.getWidth, self.view.getHeight);
    controller.view.frame = frame;
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
