//
//  RDNetworkManager+ResponseSerializer.m
//  RiceDonate
//
//  Created by ozr on 16/7/4.
//  Copyright © 2016年 ricedonate. All rights reserved.
//

#import "RDNetworkManager+ResponseSerializer.h"

@implementation RDNetworkManager (ResponseSerializer)

- (AFHTTPResponseSerializer *)HTTPRequestResponseSerializer {
    return self.requestManager.responseSerializer;
}

- (AFHTTPResponseSerializer *)HTTPUploadResponseSerializer {
    return self.uploadManager.responseSerializer;
}

- (void)setHTTPRequestResponseSerializer:
(AFHTTPResponseSerializer *)serializer {
    self.requestManager.responseSerializer = serializer;
}

- (void)setHTTPUploadResponseSerializer:(AFHTTPResponseSerializer *)serializer {
    self.uploadManager.responseSerializer = serializer;
}

@end
