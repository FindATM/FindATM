//
//  MapViewController.m
//  AtmMoney
//
//  Created by squeezah on 7/4/15.
//  Copyright (c) 2015 Funkytaps. All rights reserved.
//

#import "MapViewController.h"
#import "Bank.h"
#import "DataHandler.h"

@interface MkCustomPointAnnotation : MKPointAnnotation

@property(nonatomic,strong)Bank *currentBank;

-(instancetype)initWithBank:(Bank *)bank;

@end

@implementation MkCustomPointAnnotation

-(instancetype)initWithBank:(Bank *)bank {

    self = [super init];
    if(self)  {
        self.title = [Bank getBankNameFromType:bank.bankType];
        self.subtitle = bank.address;
        self.coordinate = bank.location;
        self.currentBank = bank;
    }
    return self;
}

@end

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

        MKPointAnnotation * newAnnotation = [[MkCustomPointAnnotation alloc] initWithBank:obj];
        [newAnnotations addObject:newAnnotation];

    }];
    [_mapView addAnnotations:newAnnotations];
    
    MKMapRect zoomRect = MKMapRectNull;
    
    for (id <MKAnnotation> annotation in _mapView.annotations)
    {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.0, 0.0);
        zoomRect = MKMapRectUnion(zoomRect, pointRect);
    }
    [_mapView setVisibleMapRect:zoomRect animated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0,0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-40)];
    _mapView.showsUserLocation = YES;
    
    _mapView.delegate = self;
    
    [self.view addSubview:_mapView];

    [self showAnnotations];
    // Do any additional setup after loading the view.
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

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(MkCustomPointAnnotation *)annotation
{
    MKPinAnnotationView *annotationView;
    static NSString *reuseIdentifier = @"MapAnnotation";

    annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIdentifier];
    if(!annotationView) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        annotationView.canShowCallout = YES;
        
//        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[Bank getImageNameFromBankState:annotation.currentBank.bankState]]];
//        [imgView sizeToFit];
        
    }
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    MkCustomPointAnnotation *annotation = view.annotation;
    
//    CLLocationCoordinate2D coordinate = [annotation coordinate];
//    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil];
//    MKMapItem *mapitem = [[MKMapItem alloc] initWithPlacemark:placemark];
//    mapitem.name = annotation.title;
//    [mapitem openInMapsWithLaunchOptions:nil];
    
//    if(_delegate && [_delegate respondsToSelector:@selector(openBankDetailViewWithBank:)]) {
    
//        [self.navigationController popViewControllerAnimated:NO];
        [_delegate openBankDetailViewWithBank:annotation.currentBank];
//    }
}


@end
