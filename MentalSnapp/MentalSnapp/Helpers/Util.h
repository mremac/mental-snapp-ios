//
//  Util.h
//  Skeleton
//
//  Created by Systango on 31/05/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Util : NSObject

+ (void)postNotification:(NSString *)name withDict:(NSDictionary *)dict;
+ (void)saveCustomObject:(id)object toUserDefaultsForKey:(NSString *)key;
+ (id)fetchCustomObjectForKey:(NSString *)key;
+ (BOOL)isValidEmail:(NSString *)email;
+ (BOOL)validatePhone:(NSString *)phoneNumber;
+ (void)openCameraView:(id)target;

@end
