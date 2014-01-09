//
//  MapViewController.h
//  iOS7AnimatedOverlayExampleProject
//
//  Created by Gregoire on 1/8/14.
//  Copyright (c) 2014 jhurrayApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "LocationGetter.h"

@interface MapViewController : UIViewController <MKMapViewDelegate>

@property (nonatomic, strong) MKMapView *mapView;
@property double currentMapDist;

-(void)addAnimatedOverlayToAnnotation:(id<MKAnnotation>)annotation;
-(void)removeAnimatedOverlay;

@end
