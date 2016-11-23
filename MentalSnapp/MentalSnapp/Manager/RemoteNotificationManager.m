//
//  RemoteNotificationManager.m
//  Systango
//
//  Copyright © 2016 Systango. All rights reserved.
//

#import "RemoteNotificationManager.h"

typedef enum{
    NotificationActivityNone
} NotificationActivity;

@implementation RemoteNotificationManager

#pragma mark - Init method

-(id)init
{
    self = [super init];
    return self;
}

#pragma mark - Singleton method

+ (RemoteNotificationManager *)sharedInstance
{
    static RemoteNotificationManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark - Public method

- (void)showAlertAfterRemoteNotification:(NSDictionary*)userInfo
{
    [self resetNotificationTrayBlock:^
    {
        if([userInfo hasValueForKey:kAPSKey])
        {
            NSLog(@"%s", __FUNCTION__);
            NSDictionary *aps = [userInfo objectForKey:kAPSKey];
            [[SMobiLogger sharedInterface] info:[NSString stringWithFormat:@"%s", __FUNCTION__] withDescription:[NSString stringWithFormat:@"[APNS response %@]", aps]];
            
            NSString *notificationName = @"";
            NSDictionary *dict = nil;
            if ([aps hasValueForKey:@"activity"])
            {
                NSNumber *activity = [aps objectForKey:@"activity"];
                
                switch ([activity intValue]) {
                    case NotificationActivityNone:
                    {
//                        dict = [NSDictionary dictionaryWithObjectsAndKeys:activity, KeyCaller, partyId, KeyPartyId, nil];
                        break;
                    }
                    default:
                    {
                        [self showAlertMessage:aps];
                        break;
                    }
                }
                
                [Util postNotification:notificationName withDict:dict];
            }
        }
    }];
}

#pragma mark - Private methods

- (void)showAlertMessage:(NSDictionary *)aps
{
    NSString *alertMessage = nil;
    if ([aps hasValueForKey:@"alert"])
    {
        alertMessage = [aps objectForKey:@"alert"];
    }
    
    if (alertMessage && alertMessage.length)
    {
        if ([aps hasValueForKey:@"activity"])
        {
            [self showBannerWithTitle:@"" subtitle:alertMessage style:ALAlertBannerStyleSuccess position:ALAlertBannerPositionUnderNavBar withObject:aps];
        }
    }
}

- (ALAlertBanner *)showBannerWithTitle:(NSString *)title subtitle:(NSString *)subtitle style:(ALAlertBannerStyle)style position:(ALAlertBannerPosition)position withObject:(id)object
{
    ALAlertBanner *banner = [ALAlertBanner alertBannerForView:ApplicationDelegate.window style:style  position:position title:title subtitle:subtitle tappedBlock:^(ALAlertBanner *alertBanner) {
        NSLog(@"tapped!");
        [alertBanner hide];
    }];
    [banner show];
    
    return banner;
}

- (void)resetNotificationTrayBlock:(void (^)(void))block
{
    NSInteger badgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber;
    [[UIApplication sharedApplication] clearBadgeNumbers];
    
    if(badgeNumber > 0)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            
            [[UIApplication sharedApplication] updateBadgeNumbers:badgeNumber];
            block();
        });
    }
    else
    {
        block();
    }
}

@end
