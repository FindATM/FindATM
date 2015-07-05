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

    MKMapView *_mapView;

    CLLocationCoordinate2D location;
//    MKPointAnnotation *newAnnotation;
    NSMutableArray *newAnnotations;
    UIBarButtonItem *directionButton;

}

- (void)showAnnotations {
    newAnnotations = [[NSMutableArray alloc]init];
    [self.coords enumerateObjectsUsingBlock:^(Bank *obj, NSUInteger idx, BOOL *stop) {
        MKPointAnnotation * newAnnotation = [[MKPointAnnotation alloc] init];
        newAnnotation.title = obj.name;
        newAnnotation.coordinate = obj.location;
        [newAnnotations addObject:newAnnotation];
    }];
    [_mapView addAnnotations:newAnnotations];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0,0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-40)];
    
    _mapView.delegate = self;
    
    [self.view addSubview:_mapView];
    
    
    directionButton = [[UIBarButtonItem alloc]
              initWithTitle:@"Directions"
              style:UIBarButtonItemStyleBordered
              target:self
              action:@selector(directionsPressed)];
    self.navigationItem.rightBarButtonItem = directionButton;

    [self showAnnotations];
    // Do any additional setup after loading the view.
}

- (void)directionsPressed {

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:
(MKUserLocation *)userLocation
{
    mapView.centerCoordinate = userLocation.location.coordinate;
}
@end
