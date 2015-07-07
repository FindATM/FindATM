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

@interface BankButton : ATMPlainCustomButton
@property (nonatomic, assign) EBankType bankType;
@end

@interface ATMFilterView ()
@property (nonatomic, strong, readwrite) NSMutableArray *selectedBanks;

@property (nonatomic, strong) UIView *mainViewContainer;

@property (nonatomic, strong) NSMutableArray *bankViewsArray;
@property (nonatomic, strong) UILabel   *selectBanksLabel;
@property (nonatomic, strong) UIView    *bankViewsContainer;

@property (nonatomic, strong) UILabel   *distanceTitleLabel;
@property (nonatomic, strong) UILabel   *selectedDistanceLabel;
@property (nonatomic, strong) UISlider  *distanceSlider;

@property (nonatomic, strong) UIView *blackBackground;

@property (nonatomic, strong) ATMPlainCustomButton *doneButton;

@end

@implementation ATMFilterView

- (instancetype)initWithFrame:(CGRect)frame andSelectedBanks:(NSMutableArray *)selectedBanks {
    self = [super initWithFrame:frame];
    if (self) {
        self.selectedBanks = selectedBanks;
        
        self.blackBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        self.blackBackground.backgroundColor = [UIColor blackColor];
        self.blackBackground.alpha = 0.7;
        [self addSubview:self.blackBackground];
        
        self.mainViewContainer = [[UIView alloc] init];
        self.mainViewContainer.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.mainViewContainer];
        
        self.selectBanksLabel = [[UILabel alloc] init];
        self.selectBanksLabel.font = [UIFont boldSystemFontOfSize:13];
        self.selectBanksLabel.textColor = [UIColor blackColor];
        self.selectBanksLabel.text = @"Select Desired Banks";
        self.selectBanksLabel.textAlignment = NSTextAlignmentCenter;
        self.selectBanksLabel.backgroundColor = [UIColor clearColor];
        [self.mainViewContainer addSubview:self.selectBanksLabel];
        
        self.bankViewsContainer = [[UIView alloc] initWithFrame:frame];
        [self.mainViewContainer addSubview:self.bankViewsContainer];

        
        self.bankViewsArray = [NSMutableArray arrayWithCapacity:TOTAL_BANKS];

        NSInteger maxItemsPerColumn = TOTAL_BANKS * 0.5;
        CGFloat padding = 5;
        CGSize buttonSize = CGSizeMake(60, 60);
        NSInteger count = 0;
        
        for (NSInteger i = 0; i < TOTAL_BANKS; i++) {
            if (i == EBankTypeCitybank) continue;
            
            BankButton *bankButton = [BankButton buttonWithType:UIButtonTypeCustom];
            [bankButton addTarget:self action:@selector(bankButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            
            CGFloat row = count / maxItemsPerColumn;
            CGFloat col = count % maxItemsPerColumn;
            
            bankButton.frame = CGRectMake(floorf(col * (buttonSize.width + padding)),
                                          floorf(row * (buttonSize.height + padding)),
                                          buttonSize.width,
                                          buttonSize.height);
            bankButton.normalBackgroundColor    = [UIColor colorWithRed:0 green:0.52 blue:0.75 alpha:1];
            bankButton.selectedBackgroundColor  = [UIColor colorWithRed:0.47 green:0.83 blue:0.95 alpha:1];
            bankButton.selected = YES;
            
            [bankButton setImage:[Bank getBankLogoFromBankType:i] forState:UIControlStateNormal];
            bankButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
            
            [self.bankViewsContainer addSubview:bankButton];
            [self.bankViewsArray addObject:bankButton];
            
            count++;
        }
        
        
        self.distanceTitleLabel = [[UILabel alloc] init];
        self.distanceTitleLabel.font = [UIFont boldSystemFontOfSize:13];
        self.distanceTitleLabel.textColor = [UIColor blackColor];
        self.distanceTitleLabel.text = @"Select Max Distance";
        self.distanceTitleLabel.textAlignment = NSTextAlignmentCenter;
        self.distanceTitleLabel.backgroundColor = [UIColor clearColor];
        [self.mainViewContainer addSubview:self.distanceTitleLabel];

        self.distanceSlider = [[UISlider alloc] init];
        self.distanceSlider.minimumValue = 0.2; // 200 m
        self.distanceSlider.maximumValue = 20; // 200 km
        self.distanceSlider.value = 10;
        [self.distanceSlider addTarget:self action:@selector(sliderValueChanged) forControlEvents:UIControlEventValueChanged];
        [self.mainViewContainer addSubview:self.distanceSlider];
        
        // Default button size 44...
        self.doneButton = [[ATMPlainCustomButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), 44)];
        [self.doneButton addTarget:self action:@selector(doneButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        self.doneButton.normalBackgroundColor = [UIColor colorWithRed:0.47 green:0.83 blue:0.95 alpha:1];
        self.doneButton.selectedBackgroundColor = [UIColor colorWithRed:0.2892 green:0.5278 blue:0.6047 alpha:1.0];
        self.doneButton.backgroundColor = self.doneButton.normalBackgroundColor;
        self.doneButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [self.doneButton setTitle:@"DONE" forState:UIControlStateNormal];
        
        [self.mainViewContainer addSubview:self.doneButton];
        
    }
    return self;
}

- (void)bankButtonTapped:(BankButton *)button {
    
    if (!button.isSelected)
        button.selected = YES;
    else
        button.selected = NO;
}

- (void)sliderValueChanged {
    
    NSLog(@"%f", self.distanceSlider.value);
    
}

- (void)doneButtonPressed {
    // TODO:
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat padding = 10;
    
    [self.selectBanksLabel sizeToFit];
    self.selectBanksLabel.frame = CGRectMake(0, padding * 2, CGRectGetWidth(self.frame), CGRectGetHeight(self.selectBanksLabel.frame));
    
    BankButton *bankButton = [self.bankViewsArray objectAtIndex:0]; // get a button
    
    CGFloat bankViewsContainerHeight = (CGRectGetHeight(bankButton.frame) * 2) + padding *2;
    CGFloat bankViewsContainerWidth = (CGRectGetWidth(bankButton.frame) * 3) + padding *2;
    
    self.bankViewsContainer.frame = CGRectMake(floorf((CGRectGetWidth(self.frame) - bankViewsContainerWidth)  * 0.5),
                                               CGRectGetMaxY(self.selectBanksLabel.frame) + padding,
                                               bankViewsContainerWidth,
                                               bankViewsContainerHeight);
    
    [self.distanceTitleLabel sizeToFit];
    self.distanceTitleLabel.frame = CGRectMake(0, CGRectGetMaxY(self.bankViewsContainer.frame) + padding, CGRectGetWidth(self.frame), CGRectGetHeight(self.distanceTitleLabel.frame));
    
    [self.distanceSlider sizeToFit];
    CGRect rect = CGRectInset(self.frame, 20, 0);
    self.distanceSlider.frame = CGRectMake(floorf((CGRectGetWidth(self.frame) - CGRectGetWidth(rect)) * 0.5),
                                           CGRectGetMaxY(self.distanceTitleLabel.frame) + padding,
                                           CGRectGetWidth(rect),
                                           CGRectGetHeight(self.distanceSlider.frame));
    
    self.doneButton.frame = CGRectMake(0,
                                       CGRectGetMaxY(self.distanceSlider.frame) + padding * 2,
                                       CGRectGetWidth(self.doneButton.frame),
                                       CGRectGetHeight(self.doneButton.frame));
    
    
    CGFloat mainViewContainerHeight = CGRectGetMaxY(self.doneButton.frame);
    self.mainViewContainer.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), mainViewContainerHeight);
    
    
}

@end


@implementation BankButton

- (void)setHighlighted:(BOOL)highlighted {
//    [super setHighlighted:highlighted];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.backgroundColor = (selected) ? self.selectedBackgroundColor : self.normalBackgroundColor;
}

@end
