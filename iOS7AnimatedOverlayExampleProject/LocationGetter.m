//
//  LocationGetter.m
//  iOS7AnimatedOverlayExampleProject
//
//  Created by Jeff Hurray on 6/14/13.
//  Copyright (c) 2013 jhurrayApps. All rights reserved.
//


#import "LocationGetter.h"
#import <CoreLocation/CoreLocation.h>

@implementation LocationGetter

@synthesize locationManager, delegate;

BOOL didUpdate = NO;

static LocationGetter *sharedClient;
+(id)sharedInstance{
    
    if(sharedClient == nil){
        sharedClient = [[LocationGetter alloc] init];
    }
    return sharedClient;

}

-(double)getLongitude{
    return sharedClient.locationManager.location.coordinate.longitude;
}
-(double)getLatitude{
    return sharedClient.locationManager.location.coordinate.latitude;
}
-(CLLocationCoordinate2D) getCoord{
    return sharedClient.locationManager.location.coordinate;
}

- (void)startUpdates
{
    NSLog(@"Starting Location Updates");
    
    if (locationManager == nil)
        locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    
    // locationManager.distanceFilter = 1000;  // update is triggered after device travels this far (meters)
    
    // Alternatively you can use kCLLocationAccuracyHundredMeters or kCLLocationAccuracyHundredMeters, though higher accuracy takes longer to resolve
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your location could not be determined." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

// Delegate method from the CLLocationManagerDelegate protocol.
- (void)locationManager:(CLLocationManager *)manage didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if (didUpdate)
        return;
    
    didUpdate = YES;
    // Disable future updates to save power.
    [locationManager stopUpdatingLocation];
    
    // let our delegate know we're done
    [delegate newLocation:newLocation];
}
@end