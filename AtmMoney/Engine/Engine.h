//
//  Engine.h
//  AtmMoney
//
//  Created by Dimitris C. on 7/4/15.
//  Copyright (c) 2015 Harris Spentzas. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

#define BASE_URL            @"http://www.dimmdesign.com/clients/atmmoney"

@interface Engine : AFHTTPRequestOperationManager


+ (Engine *)sharedInstance;

- (void)getMethod:(NSString *)path parameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)postMethod:(NSString *)path parameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
