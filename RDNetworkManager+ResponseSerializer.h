//
//  RDNetworkManager+ResponseSerializer.h
//  RiceDonate
//
//  Created by ozr on 16/7/4.
//  Copyright © 2016年 ricedonate. All rights reserved.
//

#import "RDNetworkManager.h"

@interface RDNetworkManager (ResponseSerializer)

- (AFHTTPResponseSerializer*) HTTPRequestResponseSerializer;
- (AFHTTPResponseSerializer*) HTTPUploadResponseSerializer;

- (void) setHTTPRequestResponseSerializer: (AFHTTPResponseSerializer*) serializer;
- (void) setHTTPUploadResponseSerializer: (AFHTTPResponseSerializer*) serializer;

@end
