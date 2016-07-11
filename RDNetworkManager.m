//
//  RDNetworkManager.m
//  RiceDonate
//
//  Created by ozr on 16/7/4.
//  Copyright © 2016年 ricedonate. All rights reserved.
//

#import "RDNetworkManager.h"
#import <AFNetworking.h>
#import <Mantle.h>
#import <objc/message.h>
#import <objc/runtime.h>

#define RDNetworkAdapterDebug 1

@implementation RDNetworkManager

#pragma mark - init

- (instancetype)init
{
    if (self = [super init]) {
        
        NSURLSessionConfiguration *uploadSessionConfiguration =
        [NSURLSessionConfiguration defaultSessionConfiguration];
        uploadSessionConfiguration.timeoutIntervalForRequest = 30;
        uploadSessionConfiguration.HTTPMaximumConnectionsPerHost = 1;
        uploadSessionConfiguration.URLCache = nil;
        
        _uploadManager = [[AFURLSessionManager alloc]
                              initWithSessionConfiguration:uploadSessionConfiguration];
        
        NSURLSessionConfiguration *requestSessionConfiguration =
        [NSURLSessionConfiguration defaultSessionConfiguration];
        requestSessionConfiguration.timeoutIntervalForRequest = 10;
        requestSessionConfiguration.HTTPMaximumConnectionsPerHost = 5;
        requestSessionConfiguration.URLCache = nil;
        _requestManager = [[AFHTTPSessionManager alloc]
                               initWithSessionConfiguration:requestSessionConfiguration];
        _thirdpartManager = [[AFHTTPSessionManager alloc]
                             initWithSessionConfiguration:requestSessionConfiguration];
        _thirdpartManager.responseSerializer = [AFJSONResponseSerializer serializer];
        
    }
    return self;
}

#pragma mark -

- (NSURLSessionTask *)HTTPRequestWithURL:(NSString *)URL
                                  method:(NSString *)method
                                  params:(NSDictionary *)params
                           responseClass:(__unsafe_unretained Class)aClass
                                 success:(void (^)(NSURLSessionDataTask *task,
                                                   id responseObject))success
                                 failure:(void (^)(NSURLSessionDataTask *task,
                                                   NSError *error))failure {
    return [self
            HTTPRequestWithRequestManager:self.requestManager
                                      URL:URL
                                   method:method
                                   params:params
            success:^(NSURLSessionDataTask *task, id responseObject) {
                if (aClass && [aClass isSubclassOfClass:MTLModel.class] &&
                    [aClass
                     conformsToProtocol:@protocol(MTLJSONSerializing)]) {
                        NSError *error;
                        id obj;
                        if ([responseObject isKindOfClass:[NSDictionary class]]) {
                            obj = [MTLJSONAdapter modelOfClass:aClass
                                            fromJSONDictionary:responseObject
                                                         error:&error];
                        } else if ([responseObject
                                    isKindOfClass:[NSArray class]]) {
                            obj = [MTLJSONAdapter modelsOfClass:aClass
                                                  fromJSONArray:responseObject
                                                          error:&error];
                        } else {
                            success(task, responseObject);
                            return;
                        }
                        
                        if (!error) {
                            success(task, obj);
                        } else {
                            failure(task, error);
                        }
                    } else {
                        success(task, responseObject);
                    }
            }
            failure:failure];
}

- (NSURLSessionTask *)HTTPRequestWithRequestManager:(AFHTTPSessionManager *)manager
                                                URL:(NSString *)URL
                                             method:(NSString *)method
                                             params:(NSDictionary *)params
                                            success:(void (^)(NSURLSessionDataTask *task,
                                                              id responseObject))success
                                            failure:(void (^)(NSURLSessionDataTask *task,
                                                   NSError *error))failure {
#if RDNetworkAdapterDebug
    NSLog(@"RDNetworkAdapter: START\nURL:%@ \nMETHOD:%@ \nPARAMS:\n%@ \n", URL,
          method, params);
#endif
    
    if ([manager.responseSerializer
         isKindOfClass:[AFJSONResponseSerializer class]]) {
        [(AFJSONResponseSerializer *)manager.responseSerializer
         setRemovesKeysWithNullValues:YES];
    }
    
    id s = ^(NSURLSessionDataTask *task, id responseObject) {
#if RDNetworkAdapterDebug
        NSLog(@"RDNetworkAdapter: SUCCESS\nURL:%@ \nMETHOD:%@ "
              @"\nPARAMS:\n%@\nResponse:%@",
              URL, method, params, responseObject);
#endif
        
        if (success)
            success(task, responseObject);
    };
    
    id f = ^(NSURLSessionDataTask *task, NSError *error) {
#if RDNetworkAdapterDebug
        NSLog(@"RDNetworkAdapter: FAILURE\nURL:%@ \nMETHOD:%@ \nPARAMS:\n%@ "
              @"\nError: %@",
              URL, method, params, error);
#endif
        if (failure)
            failure(task, error);
    };
    
    SEL selector = NSSelectorFromString(
                                        @"dataTaskWithHTTPMethod:URLString:parameters:success:failure:");
    id (*response)(id, SEL, id, id, id, id, id) =
    (id (*)(id, SEL, id, id, id, id, id))objc_msgSend;
    NSURLSessionTask *task =
    response(manager, selector, method, URL, params, s, f);
    [task resume];
    
    return task;
}

- (NSURLSessionTask *) ThirdpartHTTPRequestWithURL:(NSString*) URL
                                            method:(NSString*) method
                                            params:(NSDictionary*) params
                                           success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                           failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    return [self
            HTTPRequestWithRequestManager:self.thirdpartManager
            URL:URL
            method:method
            params:params
            success:success
            failure:failure];
}

+ (RDNetworkManager *)sharedInstance
{
    static RDNetworkManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [RDNetworkManager new];
    });
    return sharedInstance;
}

@end
