//
//  MapViewController.m
//  iOS7AnimatedOverlayExampleProject
//
//  Created by Gregoire on 1/8/14.
//  Copyright (c) 2014 jhurrayApps. All rights reserved.
//

#import "MapViewController.h"
#import "MapAnnotation.h"
#import "AnimatedOverlay.h"

#define OVERLAYMETERS 600
#define OFFSET 5000

@interface MapViewController ()

@end

@implementation MapViewController

@synthesize mapView = _mapView, currentMapDist;

// ********** FOR ANIMATED OVERLAY ***********

//animated overlay to be passed around... static instance
static AnimatedOverlay *animatedOverlay;

-(void)addAnimatedOverlayToAnnotation:(id<MKAnnotation>)annotation{
    //get a frame around the annotation
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, OVERLAYMETERS, OVERLAYMETERS);
    CGRect rect = [_mapView  convertRegion:region toRectToView:_mapView];
    //set up the animated overlay
    if(!animatedOverlay){
        animatedOverlay = [[AnimatedOverlay alloc] initWithFrame:rect];
    }
    else{
        [animatedOverlay setFrame:rect];
    }
    //add to the map and start the animation
    [_mapView addSubview:animatedOverlay];
    if([annotation.title  isEqual: @"1"]){
        [animatedOverlay startAnimatingWithColor:[UIColor redColor] andFrame:rect];
    }
    else if ([annotation.title  isEqual: @"2"]){
        [animatedOverlay startAnimatingWithColor:[UIColor purpleColor] andFrame:rect];
    }
    else{// == @"3"
        [animatedOverlay startAnimatingWithColor:[UIColor greenColor] andFrame:rect];
    }
}

-(void)removeAnimatedOverlay{
    if(animatedOverlay){
        [animatedOverlay stopAnimating];
        [animatedOverlay removeFromSuperview];
    }
}

//****************** APP DELEGATE ********************



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _mapView = [[MKMapView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [_mapView setDelegate:self];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //location getter setup
    [[LocationGetter sharedInstance] startUpdates];
    
    //mapview setup
    currentMapDist = METERS_PER_MILE;
    [_mapView setShowsUserLocation:NO];
    [self.view addSubview:_mapView];
    
    //navbar setup
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DEVICEWIDTH, NAVBARHEIGHT)];
    title.backgroundColor = [UIColor clearColor];
    [title.layer setCornerRadius:15];
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor blueColor];
    title.text = @"Animated Overlay Example";
    [self.navigationItem setTitleView:title];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    [self.navigationController.navigationBar setTranslucent:YES];
    
    MKMapPoint annMapPoint = MKMapPointForCoordinate([[LocationGetter sharedInstance] getCoord]);
    MKPointAnnotation *annotation1 = [[MKPointAnnotation alloc] init];
    annotation1.title = @"1";
    [annotation1 setCoordinate:MKCoordinateForMapPoint(MKMapPointMake(annMapPoint.x, annMapPoint.y+OFFSET))];
    MKPointAnnotation *annotation2 = [[MKPointAnnotation alloc] init];
    annotation2.title = @"2";
    [annotation2 setCoordinate:MKCoordinateForMapPoint(MKMapPointMake(annMapPoint.x+OFFSET, annMapPoint.y-OFFSET))];
    MKPointAnnotation *annotation3 = [[MKPointAnnotation alloc] init];
    annotation3.title = @"3";
    [annotation3 setCoordinate:MKCoordinateForMapPoint(MKMapPointMake(annMapPoint.x-OFFSET, annMapPoint.y-OFFSET))];
    
    
    [_mapView addAnnotation:annotation1];
    [_mapView addAnnotation:annotation2];
    [_mapView addAnnotation:annotation3];
    [_mapView selectAnnotation:annotation1 animated:YES];
    // Do any additional setup after loading the view from its nib.
}

-(void) viewWillAppear:(BOOL)animated{
    
    [[LocationGetter sharedInstance] startUpdates];
    CLLocationCoordinate2D zoomLocation = [[LocationGetter sharedInstance] getCoord];
    MKCoordinateRegion mapRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, currentMapDist, currentMapDist);
    [_mapView setRegion:mapRegion animated:YES];
}

-(void) mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
    //removes the animated overlay
    [self removeAnimatedOverlay];
}

-(void) mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{

    for(id<MKAnnotation> n in _mapView.selectedAnnotations){
        [self addAnimatedOverlayToAnnotation:n];
    }
    
    MKMapRect mapRect = mapView.visibleMapRect;
    MKMapPoint eastPoint = MKMapPointMake(MKMapRectGetMinX(mapRect), MKMapRectGetMidY(mapRect));
    MKMapPoint westPoint = MKMapPointMake(MKMapRectGetMaxX(mapRect), MKMapRectGetMidY(mapRect));
    currentMapDist = MKMetersBetweenMapPoints(eastPoint, westPoint);
    NSLog(@"\nCurrent map distance is %f\n", currentMapDist);
}

-(void) mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view{
    
    [self removeAnimatedOverlay];
}

-(void) mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    
    [self addAnimatedOverlayToAnnotation:view.annotation];
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // If it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // Handle any custom annotations.
    if ([annotation isKindOfClass:[MKPointAnnotation class]])
    {
        // Try to dequeue an existing pin view first.
        MKPinAnnotationView *pinView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        if (!pinView)
        {
            // If an existing pin view was not available, create one.
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
            pinView.animatesDrop = YES;
            pinView.canShowCallout = NO;
            
            if([annotation.title  isEqual: @"1"]){
                pinView.pinColor = MKPinAnnotationColorRed;
            }
            else if ([annotation.title  isEqual: @"2"]){
                pinView.pinColor = MKPinAnnotationColorPurple;
            }
            else{// == @"3"
                pinView.pinColor = MKPinAnnotationColorGreen;
            }
        } else {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    return nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
