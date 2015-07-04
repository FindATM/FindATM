//
//  ATMBankTableViewCell.m
//  AtmMoney
//
//  Created by Dimitris C. on 7/4/15.
//  Copyright (c) 2015 Harris Spentzas. All rights reserved.
//

#import "ATMBankTableViewCell.h"
#import "DataHandler.h"

@interface ATMBankTableViewCell ()
@property (nonatomic,strong) UIImageView *bankLogoImageView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *addressLabel;
@property (nonatomic,strong) UILabel *visitorsLabel;
@property (nonatomic,strong) UIImageView *disclosureImageView;
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
        self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.titleLabel];

        
        self.addressLabel = [[UILabel alloc] init];
        self.addressLabel.font = [UIFont systemFontOfSize:14];
        self.addressLabel.textColor = [UIColor blackColor];
        self.addressLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.addressLabel];
        
        self.visitorsLabel = [[UILabel alloc] init];
        self.visitorsLabel.font = [UIFont systemFontOfSize:14];
        self.visitorsLabel.textColor = [UIColor blackColor];
        self.visitorsLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.visitorsLabel];

        self.disclosureImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell-disclosure-icon"]];
        [self.disclosureImageView sizeToFit];
        [self.contentView addSubview:self.disclosureImageView];

    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat padding = 5;
    
    self.disclosureImageView.frame = CGRectMake(CGRectGetWidth(self.contentView.frame) - CGRectGetWidth(self.disclosureImageView.frame) - padding * 2,
                                                floorf((CGRectGetHeight(self.contentView.frame) - CGRectGetHeight(self.disclosureImageView.frame)) * 0.5),
                                                CGRectGetWidth(self.disclosureImageView.frame),
                                                CGRectGetHeight(self.disclosureImageView.frame));
    
    [self.bankLogoImageView sizeToFit];
    self.bankLogoImageView.frame = CGRectMake(padding,
                                              padding * 2,//floorf((CGRectGetHeight(self.contentView.frame) - CGRectGetHeight(self.bankLogoImageView.frame)) * 0.5),
                                              CGRectGetWidth(self.bankLogoImageView.frame),
                                              CGRectGetHeight(self.bankLogoImageView.frame));
    [self.titleLabel sizeToFit];
    self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.bankLogoImageView.frame) + padding,
                                       CGRectGetMinY(self.bankLogoImageView.frame),
                                       CGRectGetWidth(self.titleLabel.frame),
                                       CGRectGetHeight(self.titleLabel.frame));
    
    [self.addressLabel sizeToFit];
    self.addressLabel.frame = CGRectMake(CGRectGetMinX(self.titleLabel.frame),
                                         CGRectGetMaxY(self.titleLabel.frame),
                                         CGRectGetMinX(self.disclosureImageView.frame) - padding,
                                         CGRectGetHeight(self.addressLabel.frame));

    
    [self.visitorsLabel sizeToFit];
    self.visitorsLabel.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame) + padding,
                                          CGRectGetMinY(self.bankLogoImageView.frame),
                                          CGRectGetWidth(self.visitorsLabel.frame),
                                          CGRectGetHeight(self.visitorsLabel.frame));
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
//    self.titleLabel.text = @"";
//    self.addressLabel.text = @"";
}

- (void)updateWithBank:(Bank *)bank {
    self.titleLabel.text = [bank getBankNameFromType:bank.bankType];
    self.addressLabel.text = bank.name;
    CLLocation *location = [[CLLocation alloc] initWithLatitude:bank.latitude longitude:bank.longtitude];
    [Data getAddressFromLocation:location WithCompletion:^(NSString *message) {
        self.addressLabel.text = message;
    }];
    
    self.visitorsLabel.text = [NSString stringWithFormat:@"Visitors: %ld",(long)bank.visitors];
    switch (bank.bankState) {
        case EbankStateMoneyAndTwenties:
//            self.backgroundColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:0.8];
            break;
        case EbankStateMoneyNoTwenties:
//            self.backgroundColor = [UIColor colorWithRed:0.0 green:0.8 blue:0.0 alpha:0.8];
            break;
        case EBankStateNoMoney:
//            self.backgroundColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.8];
            break;
        case EbankStateUknown:
//            self.backgroundColor = [UIColor grayColor];
            break;
            
        default:
//            self.backgroundColor = [UIColor clearColor];
            break;
    }
    
    [self layoutIfNeeded];
    
}

@end
