//
//  Toolkit.m
//  AtmMoney
//
//  Created by Dimitris C. on 7/6/15.
//  Copyright (c) 2015 Funkytaps. All rights reserved.
//

#import "Toolkit.h"


@interface Toolkit ()
@property (nonatomic, strong, readwrite) NSDateFormatter   *dateFormatter;
@property (nonatomic, strong, readwrite) NSNumberFormatter *numberFormatter;
@end

@implementation Toolkit

+ (Toolkit *)sharedInstance {
    static Toolkit *_sharedClient = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedClient = [[Toolkit alloc] init];
    });
    
    return _sharedClient;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.dateFormatter = [[NSDateFormatter alloc] init];
        self.dateFormatter.timeStyle = NSDateFormatterShortStyle;
        self.dateFormatter.dateStyle = NSDateFormatterShortStyle;
        
        [self.dateFormatter setDateFormat:@"dd/mm/yyyy HH:mm"];

        self.numberFormatter = [[NSNumberFormatter alloc] init];
    }
    return self;
}

@end
