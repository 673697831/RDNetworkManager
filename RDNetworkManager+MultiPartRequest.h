//
//  RDNetworkManager+MultiPartRequest.h
//  RiceDonate
//
//  Created by ozr on 16/7/4.
//  Copyright © 2016年 ricedonate. All rights reserved.
//

#import "RDNetworkManager.h"

@interface RDNetworkManager (MultiPartRequest)

/**
 *  上传图片
 *
 *  @param URL       url
 *  @param params    额外参数
 *  @param image     图片
 *  @param imageName 图片的参数名字
 *  @param success   成功回调
 *  @param failure   失败回调
 *
 *  @return task
 */
- (NSURLSessionTask*)uploadWithWithURL:(NSString*) URL
                                params:(NSDictionary*) params
                                 image:(UIImage *)image
                             imageName:(NSString *)imageName
                        compressFactor:(CGFloat)compressFactor
                         responseClass:(Class) aClass
                               success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                               failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

/**
 *  上传文件
 *
 *  @param URL      url
 *  @param params   额外参数
 *  @param fileKey  文件的参数名字
 *  @param filePath 文件路径
 *  @param filePath 文件名
 *  @param success  成功回调
 *  @param failure  失败回调
 *
 *  @return task
 */
- (NSURLSessionTask*)uploadWithWithURL:(NSString*) URL
                                params:(NSDictionary*) params
                               fileKey:(NSString*)fileKey
                              filePath:(NSString *)filePath
                              fileName:(NSString *)fileName
                               success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                               failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;



@end
