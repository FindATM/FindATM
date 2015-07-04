//
//  GetNearestBanks.m
//  AtmMoney
//
//  Created by Dimitris C. on 7/4/15.
//  Copyright (c) 2015 Funkytaps. All rights reserved.
//

#import "GetNearestBanks.h"
#import "Bank.h"

#define GET_NEAREST_BANKS_URL @"getNearestBanks"

@implementation GetNearestBanks

- (instancetype)init {
    self = [super init];
    if (self) {
        self.banksData = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)getNearestBanksWithLocation:(CLLocation *)location withCompletion:(VoidBlock)completion andFailure:(VoidBlock)failure {
   
    self.banksData = [[NSMutableArray alloc] init];
    
    [Eng postMethod:GET_NEAREST_BANKS_URL
         parameters:@{@"lng": @(location.coordinate.longitude), @"lat":@(location.coordinate.latitude)}
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                    NSLog(@"JSON: %@", responseObject);
                    if ([responseObject objectForKey:@"error"]) {
                        if (failure != nil)
                            failure();
                        return;
                    }
                    
                    NSArray *banks = [responseObject objectForKey:@"banks"];
                    
                    [banks enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
                        Bank *bank = [[Bank alloc] initWithDict:dict];
                        [self.banksData addObject:bank];
                    }];
                    
                    if (completion != nil)
                        completion();
                
            }
            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"Network Failure");
                    if (failure != nil) {
                        failure();
                    }
            }];
    
}

@end
