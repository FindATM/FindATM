//
//  Engine.h
//  AtmMoney
//
//  Created by Dimitris C. on 7/4/15.
//  Copyright (c) 2015 Funkytaps. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

#import "GetNearestBanks.h"
#import "SubmitBank.h"

#ifdef DEBUG
//    #define BASE_URL            @"https://www.dimmdesign.com/clients/atmmoney-dev/api"
    #define BASE_URL            @"https://www.dimmdesign.com/clients/atmmoney/api"
#else
    #define BASE_URL            @"https://www.dimmdesign.com/clients/atmmoney/api"
#endif

#define Eng [Engine sharedInstance]


typedef enum : NSUInteger {
    EErrorCodeNoEntries = 0
} EErrorCode;

@interface Engine : AFHTTPRequestOperationManager

@property (nonatomic, strong, readonly) GetNearestBanks *getNearestBanks;
@property (nonatomic, strong, readonly) SubmitBank *submitBank;

+ (Engine *)sharedInstance;

- (void)getMethod:(NSString *)path parameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)postMethod:(NSString *)path parameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
