//
//  SubmitBank.m
//  AtmMoney
//
//  Created by Dimitris C. on 7/5/15.
//  Copyright (c) 2015 Funkytaps. All rights reserved.
//

#import "SubmitBank.h"

#define SUBMIT_BANK_URL @"submitBank"


@implementation SubmitBank

- (void)submitBankWithBankID:(NSInteger)bankID andBankState:(EBankState)bankState withCompletion:(VoidBlock)completion andFailure:(VoidBlock)failure {
    
    [Eng postMethod:SUBMIT_BANK_URL
         parameters:@{@"buid": @(bankID),@"state":@(bankState)}
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"JSON: %@", responseObject);
                if ([responseObject objectForKey:@"error"]) {
                    if (failure != nil)
                        failure();
                    return;
                }
                
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
