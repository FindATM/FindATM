//
//  MapViewController.m
//  AtmMoney
//
//  Created by squeezah on 7/4/15.
//  Copyright (c) 2015 Funkytaps. All rights reserved.
//

#import "MapViewController.h"
#import "Bank.h"

@interface MapViewController ()

@end

@implementation MapViewController {

    MKMapView *mapView;
    UIToolbar *toolBar;

    CLLocationCoordinate2D location;
    MKPointAnnotation *newAnnotation;
    NSMutableArray *newAnnotations;

}

- (void)showAnnotations {
    newAnnotations = [[NSMutableArray alloc]init];
    
    [self.coords enumerateObjectsUsingBlock:^(Bank *obj, NSUInteger idx, BOOL *stop) {
        newAnnotation = [[MKPointAnnotation alloc] init];
        newAnnotation.title = obj.name;
        newAnnotation.coordinate = obj.location;
        [newAnnotations addObject:newAnnotation];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0,40, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-40)];
    
    mapView.delegate = self;

    
    [self.view addSubview:mapView];
    
    toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view.frame)-40, CGRectGetWidth(self.view.frame), 40)];
    [self.view addSubview:toolBar];
    
    UIBarButtonItem *zoomButton =
    [[UIBarButtonItem alloc]
     initWithTitle: @"Zoom"
     style:UIBarButtonItemStylePlain
     target: self
     action:@selector(zoomIn:)];
    
    NSArray *buttons = [[NSArray alloc]
                        initWithObjects:zoomButton, nil];
    
    toolBar.items = buttons;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)zoomIn: (id)sender
{
    MKUserLocation *userLocation = mapView.userLocation;
    MKCoordinateRegion region =
    MKCoordinateRegionMakeWithDistance (
                                        userLocation.location.coordinate, 50, 50);
    [mapView setRegion:region animated:NO];
}


- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:
(MKUserLocation *)userLocation
{
    mapView.centerCoordinate = userLocation.location.coordinate;
}
@end
