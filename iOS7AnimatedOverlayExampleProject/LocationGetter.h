//
//  LocationGetter.h
//  iOS7AnimatedOverlayExampleProject
//
//  Created by Jeff Hurray on 6/14/13.
//  Copyright (c) 2013 jhurrayApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@protocol LocationGetterDelegate <NSObject>

- (void) newLocation:(CLLocation *)location;

@end



@interface LocationGetter : NSObject <CLLocationManagerDelegate>

@property (nonatomic, retain) CLLocationManager *locationManager;
@property(nonatomic , retain) id delegate;

+(id) sharedInstance;

- (void)startUpdates;
-(double) getLatitude;
-(double) getLongitude;
-(CLLocationCoordinate2D) getCoord;


@end
