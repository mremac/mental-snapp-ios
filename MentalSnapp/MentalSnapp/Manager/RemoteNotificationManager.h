//
//  RemoteNotificationManager.h
//  Systango
//
//  Copyright © 2016 Systango. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RemoteNotificationManager : NSObject

@property (nonatomic, strong) NSNumber *userConversationThreadId;
@property (nonatomic, strong) NSNumber *postActivityId;

+ (RemoteNotificationManager *)sharedInstance;

- (void)showAlertAfterRemoteNotification:(NSDictionary*)userInfo;

- (void)resetNotificationTrayBlock:(void (^)(void))block;

@end
