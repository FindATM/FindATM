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
        self.titleLabel.
        [self.contentView addSubview:self.titleLabel];
        
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
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateWithBank:(Bank *)bank {
    self.titleLabel.text = bank.name;
}

@end
