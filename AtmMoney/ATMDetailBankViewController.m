//
//  ATMDetailBankViewController.m
//  AtmMoney
//
//  Created by Dimitris C. on 7/5/15.
//  Copyright (c) 2015 Funkytaps. All rights reserved.
//

#import "ATMDetailBankViewController.h"
#import "BankHistory.h"
#import "DataHandler.h"
#import "DateTools.h"
#import <MapKit/MapKit.h>
#import "ATMPlainCustomButton.h"


@interface ATMDetailBankViewController ()

@property (nonatomic, strong) Bank *bankData;

@property (weak, nonatomic) IBOutlet UIImageView *bankLogoImageView;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankAddressLabel;

@property (weak, nonatomic) IBOutlet UIView *hasMoneyContainerView;
@property (weak, nonatomic) IBOutlet UILabel *hasMoneyLabel;
@property (weak, nonatomic) IBOutlet UISwitch *hasMoneySwitch;

@property (weak, nonatomic) IBOutlet UIView *hasTwentiesView;
@property (weak, nonatomic) IBOutlet UILabel *hasTwentiesLabel;
@property (weak, nonatomic) IBOutlet UISwitch *hasTwentiesSwitch;

@property (weak, nonatomic) IBOutlet UILabel *latestActivityLabel;
@property (weak, nonatomic) IBOutlet UITableView *latestActivityTableView;
@property (weak, nonatomic) IBOutlet ATMPlainCustomButton *submitButton;

@property (weak, nonatomic) IBOutlet UILabel *noActivityLabel;

@end

static NSString *activityCellItemIdentifier = @"activityCellItemIdentifier";

@implementation ATMDetailBankViewController

- (instancetype)initWithBank:(Bank *)bank {
    self = [super init];
    if (self) {
        self.bankData = bank;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedStringFromTable(@"atmdetailviewcontroller.title", @"Localization", nil);
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.noActivityLabel.hidden = (Eng.getNearestBanks.bankHistoryData.count > 0);
    
    self.submitButton.normalBackgroundColor = [UIColor colorWithRed:0.47 green:0.83 blue:0.95 alpha:1];
    self.submitButton.selectedBackgroundColor = [UIColor colorWithRed:0.2892 green:0.5278 blue:0.6047 alpha:1.0];
    [self.submitButton addTarget:self action:@selector(submitButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    // Activity Table View init
    self.latestActivityTableView.delegate = self;
    self.latestActivityTableView.dataSource = self;
    self.latestActivityTableView.tableFooterView = [[UIView alloc] init];

    [self.latestActivityTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:activityCellItemIdentifier];

    //
    self.hasMoneyLabel.text = NSLocalizedStringFromTable(@"detail.view.hasmoney", @"Localization", @"");
    self.hasTwentiesLabel.text = NSLocalizedStringFromTable(@"detail.view.hastwenties", @"Localization", @"");
    
    self.bankNameLabel.text = [Bank getBankNameFromType:self.bankData.bankType];
    self.bankLogoImageView.image = [Bank getBankLogoFromBankType:self.bankData.bankType];
    
    [self.hasMoneySwitch addTarget:self action:@selector(hasMoneySwitchValueChanged) forControlEvents:UIControlEventValueChanged];
    
    [self updateViewWithState:self.bankData.bankType];
       
    UIBarButtonItem *directionButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"detail.directions", @"Localization", nil)
                                                                        style:UIBarButtonItemStyleBordered
                                                                       target:self
                                                                       action:@selector(directionsPressed)];
    self.navigationItem.rightBarButtonItem = directionButton;
    
}

- (void)directionsPressed {

        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:self.bankData.location addressDictionary:nil];
        MKMapItem *mapitem = [[MKMapItem alloc] initWithPlacemark:placemark];
        mapitem.name = self.bankData.name;
        [mapitem openInMapsWithLaunchOptions:nil];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Submit Button -
- (void)submitButtonPressed {
    EBankState state;
    [SVProgressHUD show];
    
    if(!self.hasMoneySwitch.isOn)
        state = EBankStateNoMoney;
    else if (self.hasTwentiesSwitch.isOn)
        state = EbankStateMoneyAndTwenties;
    else
        state = EbankStateMoneyNoTwenties;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(svProgressHUDWillDissapear)
                                                 name:SVProgressHUDWillDisappearNotification
                                               object:nil];
    
    [Eng.submitBank submitBankWithBankID:self.bankData.buid
                            andBankState:state
                          withCompletion:^{
                              [SVProgressHUD showSuccessWithStatus:@"Information submitted\nThank You!"];
                          }
                              andFailure:^{
                                  [SVProgressHUD showErrorWithStatus:@"Network Failure"];
                              }];
}

- (void)svProgressHUDWillDissapear {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self updateBankHistory];
}

- (void)updateBankHistory {
    [Eng.getNearestBanks getBankHistoryWithId:self.bankData.buid
                               withCompletion:^{
                                   self.noActivityLabel.hidden = (Eng.getNearestBanks.bankHistoryData.count > 0);
                                   [self.latestActivityTableView reloadData];
                               }
                                   andFailure:^{
                                       [SVProgressHUD showErrorWithStatus:@"Network Failure"];
                                   }];

}

- (void)updateViewWithState:(EBankType)state {

    self.bankAddressLabel.text = self.bankData.address;
    switch (self.bankData.bankState) {
        case EbankStateUknown:
        case EbankStateMoneyAndTwenties:
            [self.hasMoneySwitch setOn:YES animated:YES];
            [self enableTwentiesView];
            [self.hasTwentiesSwitch setOn:YES animated:YES];
            break;

        case EbankStateMoneyNoTwenties:
            [self.hasMoneySwitch setOn:YES animated:YES];
            [self enableTwentiesView];
            [self.hasTwentiesSwitch setOn:NO animated:YES];
            break;

        case EBankStateNoMoney:
            [self.hasMoneySwitch setOn:NO animated:YES];
            [self disableTwentiesView];
            [self.hasTwentiesSwitch setOn:NO animated:YES];
            break;
            
        default:
            [self.hasMoneySwitch setOn:YES animated:YES];
            [self enableTwentiesView];
            [self.hasTwentiesSwitch setOn:YES animated:YES];
            break;
    }
    
}

#pragma mark - Has Money & Has Twenties methods -

- (void)hasMoneySwitchValueChanged {
 
    if (self.hasMoneySwitch.isOn)
        [self enableTwentiesView];
    else
        [self disableTwentiesView];
    
}

- (void)enableTwentiesView {
    
    self.hasTwentiesView.userInteractionEnabled = YES;
    [self.hasTwentiesSwitch addTarget:self action:@selector(hasTwentiesSwitchValueChanged) forControlEvents:UIControlEventValueChanged];

    [UIView animateWithDuration:0.35 animations:^{
        self.hasTwentiesView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)disableTwentiesView {
    
    self.hasTwentiesView.userInteractionEnabled = NO;
    [self.hasTwentiesSwitch setOn:NO animated:YES];
    [self.hasTwentiesSwitch removeTarget:self action:@selector(hasTwentiesSwitchValueChanged) forControlEvents:UIControlEventValueChanged];
    [UIView animateWithDuration:0.35 animations:^{
        self.hasTwentiesView.alpha = 0.3f;
    } completion:^(BOOL finished) {
        
    }];
}


- (void)hasTwentiesSwitchValueChanged {
    
}

#pragma mark - Table View Methods -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return Eng.getNearestBanks.bankHistoryData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:activityCellItemIdentifier forIndexPath:indexPath];
    cell.backgroundColor = (indexPath.row % 2 == 0) ? [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.0] : [UIColor whiteColor];
    BankHistory *history = [Eng.getNearestBanks.bankHistoryData objectAtIndex:indexPath.row];
    
    NSString *dateString = [history.time timeAgoSinceNow];
    
    NSString *bankStateString   = [Bank getReadableStateFromBankState:history.bankState];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    
    NSMutableAttributedString *dateAttString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\t",dateString]
                                                                        attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]}];

    NSAttributedString *bankStateAttString = [[NSAttributedString alloc] initWithString:bankStateString
                                                                             attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:13],
                                                                                          NSForegroundColorAttributeName: [Bank getTextColorFromBankState:history.bankState]}];
    [dateAttString appendAttributedString:bankStateAttString];
    
    cell.textLabel.attributedText = dateAttString;
    [cell layoutIfNeeded];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// from: http://stackoverflow.com/questions/25770119/ios-8-uitableview-separator-inset-0-not-working
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
