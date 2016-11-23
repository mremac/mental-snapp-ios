//
//  Request.m
//  Skeleton
//
//  Created by Systango on 14/08/15.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "Request.h"
#import "NetworkHttpClient.h"

@interface Request ()

@property (nonatomic, strong) NSMutableDictionary *parameters;

@end

@implementation Request

- (instancetype)initForDeviceRegistration {
    self = [super init];
    if (self) {
        
        NSString *deviceToken = kEmptyString;
        
        deviceToken = [UserDefaults valueForKey:keyDeviceToken];
        
        
        _parameters = [NSMutableDictionary new];
        _parameters[@"device_token"] = deviceToken ? deviceToken : kEmptyString;
        _parameters[@"device_info"] = @"deviceTestInfo:Iphone6";
        _parameters[@"device_type"] = @"iOS";
        
        self.urlPath = [Request getURLPath:@"kRegisterDeviceURL"];
    }
    return self;
}

- (NSString *)appendUrlForDeviceToken:(NSString *)urlString {
    
    NSString *editedUrlString = kEmptyString;
    NSString *deviceTokenString = [UserDefaults valueForKey:keyDeviceToken];
    
    if (deviceTokenString && deviceTokenString.length > 0) {
        editedUrlString = [NSString stringWithFormat:@"%@/%@",urlString, deviceTokenString];
    }
    
    return editedUrlString;
}

+ (NSString *)getURLPath:(NSString *)urlPath
{
    NetworkHttpClient *client = [NetworkHttpClient sharedInstance];
    return [NSString stringWithFormat:@"%@%@",client.urlPathSubstring, urlPath];
}

- (NSDictionary *)getParams {
    return _parameters;
}

@end
