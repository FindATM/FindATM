//
//  Toolkit.h
//  AtmMoney
//
//  Created by Dimitris C. on 7/6/15.
//  Copyright (c) 2015 Funkytaps. All rights reserved.
//

#import <Foundation/Foundation.h>

#define Tk [Toolkit sharedInstance]

@interface Toolkit : NSObject

@property (nonatomic, strong, readonly) NSDateFormatter   *dateFormatter;
@property (nonatomic, strong, readonly) NSNumberFormatter *numberFormatter;


+ (Toolkit *)sharedInstance;

@end
