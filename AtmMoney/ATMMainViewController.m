//
//  ViewController.m
//  AtmMoney
//
//  Created by Harris Spentzas on 7/3/15.
//  Copyright (c) 2015 Harris Spentzas. All rights reserved.
//

#import "ATMMainViewController.h"
#import "DataHandler.h"
#import "AFHTTPRequestOperationManager.h"
#import "Bank.h"
#import "ATMBankTableViewCell.h"
#import "MapViewController.h"

@interface ATMMainViewController   ()
@property (nonatomic, strong) NSMutableArray *banksData;
@property (nonatomic, strong) UIButton *mapButton;
@end

@implementation ATMMainViewController

static NSString *simpleTableIdentifier = @"bankItemIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"ATMs";
    // Do any additional setup after loading the view, typically from a nib.
    
    //adding observer to being notify when location property is changed
    self.tableView.rowHeight = 70;
    [self.tableView registerClass:[ATMBankTableViewCell class] forCellReuseIdentifier:simpleTableIdentifier];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    self.mapButton = [[UIButton alloc]init];
    [self.mapButton setTitle:@"Map" forState:UIControlStateNormal];
    [self.mapButton sizeToFit];
    [self.mapButton addTarget:self action:@selector(openMap) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.mapButton];
    
}

- (void)openMap {
    if([self.banksData count] ==0)return;
    
    MapViewController *map = [[MapViewController alloc]init];
    [self.navigationController pushViewController:map animated:YES];
    [map showAnnotations];
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    [Data addObserver:self forKeyPath:CURRENT_LOCATION_KEY options:NSKeyValueObservingOptionNew context:nil];
    self.mapButton.frame = CGRectMake(0, 0, CGRectGetWidth(self.mapButton.frame), CGRectGetHeight(self.mapButton.frame));
}

- (void)viewDidDisappear:(BOOL)animated {

    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [Data removeObserver:self forKeyPath:CURRENT_LOCATION_KEY];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.banksData count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    ATMBankTableViewCell *cell = (ATMBankTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];

    Bank *bank = [self.banksData objectAtIndex:indexPath.row];
    [cell updateWithBank:bank];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    Bank *bank = [self.banksData objectAtIndex:indexPath.row];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"buid": @(bank.buid),@"state":@(bank.bankState)};
    [manager POST:@"http://dimmdesign.com/clients/atmmoney/api/submitBank" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSLog(@"Submit ok!");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

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
    
    self.banksData = [[NSMutableArray alloc]init];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"lng": @([Data getLongitude]),@"lat":@([Data getLatitude])};
    [manager POST:@"http://dimmdesign.com/clients/atmmoney/api/getNearestBanks" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        [[responseObject objectForKey:@"banks"] enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
            Bank *bank = [[Bank alloc]initWithDict:dict];
            [self.banksData addObject:bank];
        }];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

@end
