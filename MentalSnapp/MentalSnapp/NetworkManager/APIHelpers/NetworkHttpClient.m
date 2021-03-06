//
//  NetworkHttpClient.m
//  Skeleton
//
//  Created by Systango on 24/08/15.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "NetworkHttpClient.h"
#import "Request.h"

@implementation NetworkHttpClient

+ (NetworkHttpClient *)sharedInstance {
    static NetworkHttpClient *_networkHttpClient = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _networkHttpClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:[NetworkHttpClient baseUrl]]];
    });

    if (_networkHttpClient && [UserDefaults boolForKey:kIsUserLoggedIn]) {
        [_networkHttpClient.requestSerializer setValue:[UserManager sharedManager].authorizationToken forHTTPHeaderField:@"Authorization"];
    }
    [_networkHttpClient.requestSerializer setTimeoutInterval:60];

    return _networkHttpClient;
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    
    AppSettings *appSettings = [[AppSettingsManager sharedInstance] fetchSettings];
    self.urlPathSubstring = [appSettings URLPathSubstring];
    return self;
}

#pragma mark - BASE URL

+ (NSString *)baseUrl
{
    AppSettings *appSettings = [[AppSettingsManager sharedInstance] appSettings];
    
    NSString *secureConnection = appSettings.EnableSecureConnection ? kSecureProtocol : kInsecureProtocol;
    
    if ([appSettings.NetworkMode isEqualToString:kLiveEnviroment]) // for live machine
    {
        return [NSString stringWithFormat:@"%@%@", secureConnection, appSettings.ProductionURL];
    }
    else if([appSettings.NetworkMode isEqualToString:kStagingEnviroment]) // for staging env
    {
        return [NSString stringWithFormat:@"%@%@", secureConnection, appSettings.StagingURL];
    }
    else // for local env
    {
        return [NSString stringWithFormat:@"%@%@", secureConnection, appSettings.LocalURL];
    }
}

#pragma mark - API calls

- (void)getAPICallWithUrl:(NSString *)url parameters:(NSDictionary *)parameters successBlock:(successBlock)success failureBlock:(failureBlock)failure {
    
    [self GET:url parameters:parameters progress:^(NSProgress *downloadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id  responseObject) {
        success(task, responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(task, error);
    }];
}

- (void)patchAPICallWithUrl:(NSString *)url parameters:(NSDictionary *)parameters successBlock:(successBlock)success failureBlock:(failureBlock)failure {
    
    [self PATCH:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(task, responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(task, error);
     }];
}


- (void)postAPICallWithUrl:(NSString *)url parameters:(NSDictionary *)parameters successBlock:(successBlock)success failureBlock:(failureBlock)failure {
    
    [self POST:url parameters:parameters progress:^(NSProgress *uploadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        success(task, responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(task, error);
    }];
}

- (void)putAPICallWithUrl:(NSString *)url parameters:(NSDictionary *)parameters successBlock:(successBlock)success failureBlock:(failureBlock)failure {
    
    [self PUT:url parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        success(task, responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(task, error);
    }];
}

- (void)deleteAPICallWithUrl:(NSString *)url parameters:(NSDictionary *)parameters successBlock:(successBlock)success failureBlock:(failureBlock)failure {
    
    [self DELETE:url parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        success(task, responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(task, error);
    }];
}

- (void)multipartApiCallWithUrl:(NSString *)url parameters:(NSDictionary *)parameters data:(NSData *)data name:(NSString *)dataFileName fileName:(NSString *)fileName mimeType:(NSString *)mimeType successBlock:(successBlock)success failureBlock:(failureBlock)failure {
    
    [self POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:dataFileName fileName:fileName mimeType:mimeType];
    } progress:^(NSProgress *uploadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        success(task, responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(task, error);
    }];
}

- (void)multipartObjectApiCallWithUrl:(NSString *)url parameters:(NSDictionary *)parameters withObject:(Request *)object successBlock:(successBlock)success failureBlock:(failureBlock)failure {
    [self.requestSerializer setTimeoutInterval:240];
    [self POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {\
        if(object.fileData)
        {
            [formData appendPartWithFileData:object.fileData name:object.dataFilename fileName:object.fileName mimeType:object.mimeType];
        }
        if(object.imageData)
        {
            [formData appendPartWithFileData:object.imageData name:object.dataImageName fileName:object.imageName mimeType:object.imageMimeType];
        }
        
    } progress:^(NSProgress *uploadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        success(task, responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(task, error);
    }];
}


@end
