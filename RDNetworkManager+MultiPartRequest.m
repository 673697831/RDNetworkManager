//
//  RDNetworkManager+MultiPartRequest.m
//  RiceDonate
//
//  Created by ozr on 16/7/4.
//  Copyright © 2016年 ricedonate. All rights reserved.
//

#import "RDNetworkManager+MultiPartRequest.h"
#import "RDLocalPathHelper.h"
#import <Mantle.h>
#import <objc/runtime.h>
#import <objc/message.h>

@implementation RDNetworkManager (MultiPartRequest)

- (NSURLSessionTask*)uploadWithWithURL:(NSString*) URL
                                params:(NSDictionary*) params
                                 image:(UIImage *)image
                             imageName:(NSString *)imageName
                        compressFactor:(CGFloat)compressFactor
                         responseClass:(Class) aClass
                               success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                               failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSProgress *progress = [NSProgress progressWithTotalUnitCount:
                            1];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST"
                                                                                              URLString:URL
                                                                                             parameters:params
                                                                              constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                    
                                    {
                                        NSData *data=UIImageJPEGRepresentation(image, compressFactor);
                                        [formData appendPartWithFileData:data
                                                                    name:imageName
                                                                fileName:[NSString stringWithFormat:@"%@.png",imageName]
                                                                mimeType:@"image/png"];
                                    } error:nil];
    
    NSURLSessionUploadTask *uploadTask = [self.uploadManager uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error && failure) {
            NSLog(@"TTNetworkAdapter: FAILURE\nURL:%@ \nMETHOD:%@ \nPARAMS:\n%@ \nError: %@", URL,@"POST",params, error);
            failure(uploadTask, error);
        } else {
            NSLog(@"TTNetworkAdapter: SUCCESS\nURL:%@ \nMETHOD:%@ \nPARAMS:\n%@\nResponse:%@", URL,@"POST",params,responseObject);
            
            if (aClass && [aClass isSubclassOfClass:MTLModel.class] &&[aClass conformsToProtocol:@protocol(MTLJSONSerializing)])
            {
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
                    success(uploadTask, responseObject);
                    return;
                }
                
                if (!error) {
                    success(uploadTask, obj);
                } else {
                    failure(uploadTask, error);
                }
            }
            else {
                success(uploadTask, responseObject);
            }
            
        }
    }];
    
    [uploadTask resume];
    return uploadTask;
}

- (NSURLSessionTask *)uploadWithWithURL:(NSString *)URL
                                 params:(NSDictionary *)params
                                fileKey:(NSString *)fileKey
                               filePath:(NSString *)filePath
                               fileName:(NSString *)fileName
                                success:(void (^)(NSURLSessionDataTask *, id))success
                                failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    NSData *data =  [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:filePath]];
    NSProgress *progress = [NSProgress progressWithTotalUnitCount:
                            1];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST"
                                                                                              URLString:URL
                                                                                             parameters:params
                                                                              constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                    
                                    {
                                        [formData appendPartWithFileData:data
                                                                    name:fileKey
                                                                fileName:fileName
                                                                mimeType:[RDLocalPathHelper mimeTypeWithFilePath:filePath]];
                                    } error:nil];
    
    NSURLSessionUploadTask *uploadTask = [self.uploadManager uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error && failure) {
            NSLog(@"TTNetworkAdapter: FAILURE\nURL:%@ \nMETHOD:%@ \nPARAMS:\n%@ \nError: %@", URL,@"POST",params, error);
            failure(uploadTask, error);
        } else {
            NSLog(@"TTNetworkAdapter: SUCCESS\nURL:%@ \nMETHOD:%@ \nPARAMS:\n%@\nResponse:%@", URL,@"POST",params,responseObject);
            success(uploadTask ,responseObject);
        }
    }];
    
    [uploadTask resume];
    return uploadTask;
}

@end
