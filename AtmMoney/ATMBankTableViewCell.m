//
//  ATMBankTableViewCell.m
//  AtmMoney
//
//  Created by Dimitris C. on 7/4/15.
//  Copyright (c) 2015 Harris Spentzas. All rights reserved.
//

#import "ATMBankTableViewCell.h"

@interface ATMBankTableViewCell ()
@property (nonatomic,strong) UIImageView *bankLogoImageView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *visitorsLabel;
@end

@implementation ATMBankTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.bankLogoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"atm-placeholder"]];
        [self.contentView addSubview:self.bankLogoImageView];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.titleLabel];

        self.visitorsLabel = [[UILabel alloc] init];
        self.visitorsLabel.font = [UIFont systemFontOfSize:14];
        self.visitorsLabel.textColor = [UIColor blackColor];
        self.visitorsLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.visitorsLabel];

        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat padding = 5;
    
    [self.bankLogoImageView sizeToFit];
    self.bankLogoImageView.frame = CGRectMake(padding,
                                              floorf((CGRectGetHeight(self.contentView.frame) - CGRectGetHeight(self.bankLogoImageView.frame)) * 0.5),
                                              CGRectGetWidth(self.bankLogoImageView.frame),
                                              CGRectGetHeight(self.bankLogoImageView.frame));
    [self.titleLabel sizeToFit];
    self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.bankLogoImageView.frame) + padding, CGRectGetMinY(self.bankLogoImageView.frame), CGRectGetWidth(self.titleLabel.frame), CGRectGetHeight(self.titleLabel.frame));
    
    [self.visitorsLabel sizeToFit];
    self.visitorsLabel.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame) + padding, CGRectGetMinY(self.bankLogoImageView.frame), CGRectGetWidth(self.visitorsLabel.frame), CGRectGetHeight(self.visitorsLabel.frame));
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateWithBank:(Bank *)bank {
    self.titleLabel.text = bank.name;
    self.visitorsLabel.text = [NSString stringWithFormat:@"Visitors: %ld",(long)bank.visitors];
    switch (bank.bankState) {
        case EbankStateMoneyAndTwenties:
            self.backgroundColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:0.8];
            break;
        case EbankStateMoneyNoTwenties:
            self.backgroundColor = [UIColor colorWithRed:0.0 green:0.8 blue:0.0 alpha:0.8];
            break;
        case EBankStateNoMoney:
            self.backgroundColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.8];
            break;
        case EbankStateUknown:
            self.backgroundColor = [UIColor grayColor];
            break;
            
        default:
            self.backgroundColor = [UIColor clearColor];
            break;
    }
}

@end
