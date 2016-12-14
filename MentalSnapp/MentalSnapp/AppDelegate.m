//
//  AppDelegate.m
//  Skeleton
//
//  Created by Systango on 25/05/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "AppDelegate.h"
#import "Flurry.h"
#import <AWSCore/AWSCore.h>

@interface AppDelegate ()
@property (nonatomic) BOOL isNetworkAvailable;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    AppSettings *appSettings = [[AppSettingsManager sharedInstance] fetchSettings];
    
    if(appSettings.EnableCoreData)
    {
        // Setup CoreData with MagicalRecord
        [MagicalRecord setupCoreDataStackWithStoreNamed:@"Skeleton"];
    }
    
    if(appSettings.EnableFlurry)
    {
        //init Flurry
        [Flurry startSession:@"YVV32ZQDD6V64NP45PVY"];
    }
    
    [self setupNetworkMonitoring];
    
    [self setUpAmazonS3];

    if ([UserDefaults boolForKey:kIsUserLoggedIn]) {
        [[UserManager sharedManager] setValueInLoggedInUserObjectFromUserDefault];
        MainTabBarController *tabBarController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MainTabController"];
        ApplicationDelegate.window.rootViewController = tabBarController;
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if([UserDefaults boolForKey:kIsUserLoggedIn]){
        [[UserManager sharedManager] setValueInLoggedInUserObjectFromUserDefault];
    }
    
    [[SMobiLogger sharedInterface] startMobiLogger];
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    
    AppSettings *appSettings = [[AppSettingsManager sharedInstance] appSettings];
    if(appSettings.EnableCoreData)
    {
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:nil];
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{    
    return YES;   
}

#pragma mark - Private Methods

- (void)setUpAmazonS3
{
    // Initialize the Amazon Cognito credentials provider
    
    AWSCognitoCredentialsProvider *credentialsProvider = [[AWSCognitoCredentialsProvider alloc]
                                                          initWithRegionType:AWSRegionEUWest1
                                                          identityPoolId:@"eu-west-1:3361fea2-28fb-4b73-b82e-3f50f8c25bed"];
    
    AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionEUWest1 credentialsProvider:credentialsProvider];
    
    [AWSServiceManager defaultServiceManager].defaultServiceConfiguration = configuration;
}

#pragma mark - 

#pragma mark - AFNetworking methods
    
-(void)setupNetworkMonitoring {
    self.isNetworkAvailable = YES;
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
            self.isNetworkAvailable = YES;
            // Save response in MobiLogger
            [[SMobiLogger sharedInterface] info:@"Network:" withDescription:@"ON"];
            break;
            
            case AFNetworkReachabilityStatusNotReachable:
            default:
            self.isNetworkAvailable = NO;
            // Save response in MobiLogger
            [[SMobiLogger sharedInterface] info:@"Network:" withDescription:@"OFF"];
            break;
        }
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}
    
- (BOOL)hasNetworkAvailable {

    [[SMobiLogger sharedInterface] info:[NSString stringWithFormat:@"%s", __FUNCTION__] withDescription:[NSString stringWithFormat:@"Info: isNetworkAvailable: %@", self.isNetworkAvailable?@"ON":@"OFF"]];
        if (!self.isNetworkAvailable) {
            dispatch_async(dispatch_get_main_queue(), ^{
                 [Banner showNetworkFailureBanner];
           });
        }
        return self.isNetworkAvailable;
}
    
@end
