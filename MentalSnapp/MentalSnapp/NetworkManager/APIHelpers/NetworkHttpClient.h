//
//  NetworkHttpClient.h
//  Skeleton
//
//  Created by Systango on 24/08/15.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "AFHTTPSessionManager.h"

typedef void(^successBlock)(NSURLSessionDataTask *task, id responseObject);
typedef void (^failureBlock)(NSURLSessionDataTask *task, NSError *error);

@interface NetworkHttpClient : AFHTTPSessionManager

@property(nonatomic, strong) NSString *urlPathSubstring;

+ (NetworkHttpClient *)sharedInstance;
- (void)getAPICallWithUrl:(NSString *)url parameters:(NSDictionary *)parameters successBlock:(successBlock)success failureBlock:(failureBlock)failure;
- (void)postAPICallWithUrl:(NSString *)url parameters:(NSDictionary *)parameters successBlock:(successBlock)success failureBlock:(failureBlock)failure;
- (void)putAPICallWithUrl:(NSString *)url parameters:(NSDictionary *)parameters successBlock:(successBlock)success failureBlock:(failureBlock)failure;
- (void)multipartApiCallWithUrl:(NSString *)url parameters:(NSDictionary *)parameters data:(NSData *)data name:(NSString *)dataFileName fileName:(NSString *)fileName mimeType:(NSString *)mimeType successBlock:(successBlock)success failureBlock:(failureBlock)failure;

@end
