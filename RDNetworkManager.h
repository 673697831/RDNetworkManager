//
//  RDNetworkManager.h
//  RiceDonate
//
//  Created by ozr on 16/7/4.
//  Copyright © 2016年 ricedonate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

@interface RDNetworkManager : NSObject

@property (nonatomic, strong) AFURLSessionManager*  uploadManager;
@property (nonatomic, strong) AFHTTPSessionManager* requestManager;
@property (nonatomic, strong) AFHTTPSessionManager* thirdpartManager;

+ (RDNetworkManager *) sharedInstance;

/**
 *  主项目用的公用接口 标注化请求 主要GET和POST不带文件和图片
 *
 *  @param URL     url
 *  @param method  POST 或 GET
 *  @param params  参数
 *  @param aClass  自定义返回类型
 *  @param success success
 *  @param failure failure
 *
 *  @return task
 */
- (NSURLSessionTask *) HTTPRequestWithURL:(NSString*) URL
                                   method:(NSString*) method
                                   params:(NSDictionary*) params
                            responseClass:(__unsafe_unretained Class)aClass
                                  success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                  failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

/**
 *  向第三方服务器请求
 *
 *  @param URL     URL
 *  @param method  method
 *  @param params  params
 *  @param success success
 *  @param failure failure
 *
 *  @return task
 */
- (NSURLSessionTask *) ThirdpartHTTPRequestWithURL:(NSString*) URL
                                            method:(NSString*) method
                                            params:(NSDictionary*) params
                                           success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                           failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;


@end
