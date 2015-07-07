//
//  ATMFilterView.m
//  ATMMoney
//
//  Created by Abzorba Games on 07/07/2015.
//  Copyright (c) 2015 Funkytaps. All rights reserved.
//

#import "ATMFilterView.h"
#import "Bank.h"

@interface ATMFilterView ()
@property (nonatomic, strong) NSMutableArray *selectedBanks;
@end

@implementation ATMFilterView

- (instancetype)initWithFrame:(CGRect)frame andSelectedBanks:(NSMutableArray *)selectedBanks {
    self = [super initWithFrame:frame];
    if (self) {
        self.selectedBanks = selectedBanks;
    }
    return self;
}

@end
