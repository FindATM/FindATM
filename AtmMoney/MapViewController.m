//
//  MapViewController.m
//  AtmMoney
//
//  Created by squeezah on 7/4/15.
//  Copyright (c) 2015 Funkytaps. All rights reserved.
//

#import "MapViewController.h"
#import "Bank.h"
#import "LocationHandler.h"
#import "ATMDetailBankViewController.h"

@interface MKCustomPointAnnotation : MKPointAnnotation

@property(nonatomic,strong)Bank *currentBank;

-(instancetype)initWithBank:(Bank *)bank;

@end

@implementation MKCustomPointAnnotation

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
@property (nonatomic, strong)  MKMapView *mapView;
@end

@implementation MapViewController {

    NSMutableArray *newAnnotations;

}

- (void)viewDidLoad {
        // Do any additional setup after loading the view.
    [super viewDidLoad];
     self.navigationItem.title = NSLocalizedStringFromTable(@"mapviewcontroller.title", @"Localization", nil);
    
    self.mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0,0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    
    [self.view addSubview:self.mapView];

    [self showAnnotations];

}

- (void)showAnnotations {
    
    newAnnotations = [[NSMutableArray alloc] init];
    [self.coords enumerateObjectsUsingBlock:^(Bank *obj, NSUInteger idx, BOOL *stop) {
        
        MKPointAnnotation * newAnnotation = [[MKCustomPointAnnotation alloc] initWithBank:obj];
        [newAnnotations addObject:newAnnotation];
        
    }];
    [self.mapView addAnnotations:newAnnotations];
    
    MKMapRect zoomRect = MKMapRectNull;
    
    for (id <MKAnnotation> annotation in self.mapView.annotations)
    {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.0, 0.0);
        zoomRect = MKMapRectUnion(zoomRect, pointRect);
    }
    [self.mapView setVisibleMapRect:zoomRect animated:YES];
    
}


- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake([Location getLatitude], [Location getLongitude]);
    [mapView setCenterCoordinate:location animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(MKCustomPointAnnotation *)annotation
{
    
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        ((MKUserLocation *)annotation).title = @"My Current Location";
        return nil;  //return nil to use default blue dot view
    }
    
    MKPinAnnotationView *annotationView;
    static NSString *reuseIdentifier = @"MapAnnotation";

    annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIdentifier];
    if(!annotationView) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];       
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        annotationView.canShowCallout = YES;
//        annotationView.image = [UIImage imageNamed:@"someImage.png"];

        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[Bank getImageNameFromBankState:annotation.currentBank.bankState]]];
        annotationView.leftCalloutAccessoryView = imgView;
        
    }
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    MKCustomPointAnnotation *annotation = view.annotation;
    
    [SVProgressHUD show];
    [Eng.getNearestBanks getBankHistoryWithId:annotation.currentBank.buid
                               withCompletion:^{
                                   
                                   [SVProgressHUD dismiss];
                                   UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
                                   [self.navigationItem setBackBarButtonItem:backButtonItem];
                                   
                                   ATMDetailBankViewController *atmDetailViewController = [[ATMDetailBankViewController alloc] initWithBank:annotation.currentBank];
                                   [self.navigationController pushViewController:atmDetailViewController animated:YES];
                                   
                                }
                                   andFailure:^{
                                       [SVProgressHUD showErrorWithStatus:@"Network Failure"];
                                       
                                   }];
    

    
}


@end
