//
//  MapAnnotation.m
//  iOS7AnimatedOverlayExampleProject
//
//  Created by Gregoire on 1/8/14.
//  Copyright (c) 2014 jhurrayApps. All rights reserved.
//

#import "MapAnnotation.h"

@implementation MapAnnotation

@synthesize title = _title, subtitle, coordinate = _coordinate;

-(id) initWithTitle:(NSString *)title andCoordinate:(CLLocationCoordinate2D)coord{
    if(self = [super init]){
        _title = title;
        self.subtitle = @"subtitle";
        _coordinate = coord;
    }
    return self;
}

@end
