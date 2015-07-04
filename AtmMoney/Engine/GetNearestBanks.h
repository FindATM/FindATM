//
//  GetNearestBanks.h
//  AtmMoney
//
//  Created by Dimitris C. on 7/4/15.
//  Copyright (c) 2015 Funkytaps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Engine.h"
#import <CoreLocation/CoreLocation.h>

typedef void (^VoidBlock)(void);

@interface GetNearestBanks : NSObject

@property (nonatomic, strong) NSMutableArray *banksData;

- (void)getNearestBanksWithLocation:(CLLocation *)location withCompletion:(VoidBlock)completion andFailure:(VoidBlock)failure;

@end
