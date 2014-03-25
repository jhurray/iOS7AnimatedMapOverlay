//
//  AnimatedOverlay.h
//  SoapBox
//
//  Created by Gregoire on 12/1/13.
//  Copyright (c) 2013 Jeff. All rights reserved.
//
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>

@interface AnimatedOverlay : UIImageView

//for use if animating over an MKOverlay. Otherwise set to nil
@property (nonatomic,strong) MKCircle* circle;

//methods to control animations
-(void) startAnimatingWithColor:(UIColor *)color andFrame:(CGRect)frame;
-(void) stopAnimating;

@end
