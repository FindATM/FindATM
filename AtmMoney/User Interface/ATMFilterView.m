//
//  ATMFilterView.m
//  ATMMoney
//
//  Created by Abzorba Games on 07/07/2015.
//  Copyright (c) 2015 Funkytaps. All rights reserved.
//

#import "ATMFilterView.h"
#import "Bank.h"
#import "ATMPlainCustomButton.h"

#define TOTAL_BANKS 6

@interface BankButton : ATMPlainCustomButton
@property (nonatomic, assign) EBankType bankType;
@end

@interface ATMFilterView ()
@property (nonatomic, strong, readwrite) NSMutableArray *selectedBanks;

@property (nonatomic, strong) NSMutableArray *bankViewsArray;
@property (nonatomic, strong) UIView *bankViewsContainer;

@property (nonatomic, strong) UILabel   *distanceTitleLabel;
@property (nonatomic, strong) UILabel   *selectedDistanceLabel;
@property (nonatomic, strong) UISlider  *distanceSlider;

@property (nonatomic, strong) UIView *blackBackground;

@end

@implementation ATMFilterView

- (instancetype)initWithFrame:(CGRect)frame andSelectedBanks:(NSMutableArray *)selectedBanks {
    self = [super initWithFrame:frame];
    if (self) {
        self.selectedBanks = selectedBanks;
        
        self.blackBackground = [[UIView alloc] initWithFrame:frame];
        self.blackBackground.backgroundColor = [UIColor blackColor];
        self.blackBackground.alpha = 0.7;
        [self addSubview:self.blackBackground];
        
        self.bankViewsContainer = [[UIView alloc] initWithFrame:frame];
        [self addSubview:self.bankViewsContainer];
        
        self.bankViewsArray = [NSMutableArray arrayWithCapacity:TOTAL_BANKS];
        
        for (NSInteger i = 0; i < TOTAL_BANKS; i++) {
            BankButton *bankButton = [BankButton buttonWithType:UIButtonTypeCustom];
            [bankButton addTarget:self action:@selector(bankButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            bankButton.normalBackgroundColor    = [UIColor blackColor];
            bankButton.selectedBackgroundColor  = [UIColor darkGrayColor];
            [self.bankViewsContainer addSubview:bankButton];
        }
        
    }
    return self;
}

- (void)bankButtonTapped:(BankButton *)button {
    
    
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    
    
}

@end


@implementation BankButton

- (void)setSelected:(BOOL)selected {
    [super setSelected:self];
    self.backgroundColor = (selected) ? self.selectedBackgroundColor : self.normalBackgroundColor;
}

@end
