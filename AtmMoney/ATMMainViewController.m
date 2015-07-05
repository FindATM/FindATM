//
//  ViewController.m
//  AtmMoney
//
//  Created by Harris Spentzas on 7/3/15.
//  Copyright (c) 2015 Funkytaps. All rights reserved.
//

#import "ATMMainViewController.h"
#import "DataHandler.h"
#import "AFHTTPRequestOperationManager.h"
#import "Bank.h"
#import "ATMBankTableViewCell.h"
#import "ATMDetailBankViewController.h"
#import "MapViewController.h"

@interface ATMMainViewController   ()
@property (nonatomic, strong) UIButton *mapButton;
@end

@implementation ATMMainViewController

static NSString *simpleTableIdentifier = @"bankItemIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedStringFromTable(@"mainviewcontroller.title", @"Localization", nil);
    
    //adding observer to being notify when location property is changed
    self.tableView.rowHeight = 80;
    [self.tableView registerClass:[ATMBankTableViewCell class] forCellReuseIdentifier:simpleTableIdentifier];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshTableView) forControlEvents:UIControlEventValueChanged];
    
    self.mapButton = [[UIButton alloc]init];
    [self.mapButton setTitle:@"Map" forState:UIControlStateNormal];
    [self.mapButton sizeToFit];
    [self.mapButton addTarget:self action:@selector(openMap) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.mapButton];
    
}

- (void)refreshTableView {
    
    [Data startUpdatingLocation];
    
}

- (void)openMap {
    if([Eng.getNearestBanks.banksData count] == 0) return;
    
    MapViewController *map = [[MapViewController alloc]init];
    [self.navigationController pushViewController:map animated:YES];
    map.coords = Eng.getNearestBanks.banksData;
    [map showAnnotations];
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    [self.refreshControl beginRefreshing];
    [self refreshTableView];
     
    [Data addObserver:self forKeyPath:CURRENT_LOCATION_KEY options:NSKeyValueObservingOptionNew context:nil];
    
    self.mapButton.frame = CGRectMake(0, 0, CGRectGetWidth(self.mapButton.frame), CGRectGetHeight(self.mapButton.frame));
}

- (void)viewDidDisappear:(BOOL)animated {

    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [Data removeObserver:self forKeyPath:CURRENT_LOCATION_KEY];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [Eng.getNearestBanks.banksData count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    ATMBankTableViewCell *cell = (ATMBankTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
    
    Bank *bank = [Eng.getNearestBanks.banksData objectAtIndex:indexPath.row];
    [cell updateWithBank:bank];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    ATMBankTableViewCell *cell = (ATMBankTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
//    cell.selected = NO;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Bank *bank = [Eng.getNearestBanks.banksData objectAtIndex:indexPath.row];

    // Hides the
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backButtonItem];
    
    ATMDetailBankViewController  *map = [[ATMDetailBankViewController alloc] init];
    map.currentBank = bank;
    [Eng.getNearestBanks getBankHistoryWithId:bank.buid withCompletion:^{
        [self.navigationController pushViewController:map animated:YES];
    } andFailure:^{
        
    }];

//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    NSDictionary *parameters = @{@"buid": @(bank.buid),@"state":@(bank.bankState)};
//    [manager POST:@"http://dimmdesign.com/clients/atmmoney/api/submitBank" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"JSON: %@", responseObject);
//        NSLog(@"Submit ok!");
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object  change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:CURRENT_LOCATION_KEY]) {
        // do some stuff
        [self getBanks];
        [Data stopUpdatingLocation];
    }

}

- (void)getBanks {
    
    CLLocation *location = Data.currentLocation;
    [[Engine sharedInstance].getNearestBanks getNearestBanksWithLocation:location withCompletion:^{
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    } andFailure:^{
        [self.refreshControl endRefreshing];
    }];
    
}
@end
