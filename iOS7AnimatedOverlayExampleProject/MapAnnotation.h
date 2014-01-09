//
//  MapAnnotation.h
//  iOS7AnimatedOverlayExampleProject
//
//  Created by Gregoire on 1/8/14.
//  Copyright (c) 2014 jhurrayApps. All rights reserved.
//
#import <MapKit/MapKit.h>
#import <Foundation/Foundation.h>

@interface MapAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readwrite, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

-(id) initWithTitle:(NSString *)title andCoordinate:(CLLocationCoordinate2D) coord;

@end
