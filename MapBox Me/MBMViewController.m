//
//  MBMViewController.m
//  MapBox Me
//
//  Created by Justin Miller on 3/29/12.
//  Copyright (c) 2012 MapBox / Development Seed. All rights reserved.
//

#import "MBMViewController.h"

#import "MapBox.h"

#define kNormalRegularSourceID @"justin.map-s2effxa8"
#define kRetinaRegularSourceID @"justin.map-kswgei2n"
#define kNormalTerrainSourceID @"justin.map-ngrqqx0w"
#define kRetinaTerrainSourceID @"justin.map-nq0f1vuc"

#define kTintColor [UIColor colorWithRed:0.120 green:0.550 blue:0.670 alpha:1.000]

@interface MBMViewController ()

@property (nonatomic, strong) IBOutlet RMMapView *mapView;
@property (nonatomic, strong) IBOutlet UISegmentedControl *segmentedControl;

@end

#pragma mark -

@implementation MBMViewController

@synthesize mapView;
@synthesize segmentedControl;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"MapBox Me";
    
    [self.segmentedControl addTarget:self action:@selector(toggleMode:) forControlEvents:UIControlEventValueChanged];
    [self.segmentedControl setSelectedSegmentIndex:0];
    
    [[UINavigationBar appearance] setTintColor:kTintColor];
    [[UISegmentedControl appearance] setTintColor:kTintColor];
    [[UIToolbar appearance] setTintColor:kTintColor];

    self.mapView.tileSource = [[RMMapBoxSource alloc] initWithMapID:(([[UIScreen mainScreen] scale] > 1.0) ? kRetinaRegularSourceID : kNormalRegularSourceID)];
    self.mapView.centerCoordinate = CLLocationCoordinate2DMake(0, 0);
    self.mapView.minZoom = 1;
    self.mapView.zoom = 2;
    
    self.navigationItem.rightBarButtonItem = [[RMUserTrackingBarButtonItem alloc] initWithMapView:self.mapView];

    self.navigationItem.rightBarButtonItem.tintColor = kTintColor;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    self.mapView.userTrackingMode = RMUserTrackingModeFollow;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait || [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad);
}

#pragma mark -

- (void)toggleMode:(UISegmentedControl *)sender
{
    BOOL isRetina  = ([[UIScreen mainScreen] scale] > 1.0);
    BOOL isTerrain = (sender.selectedSegmentIndex == 1);
    
    NSString *mapID;
    
    if (isRetina && isTerrain)
        mapID = kRetinaTerrainSourceID;
    else if (isRetina && ! isTerrain)
        mapID = kRetinaRegularSourceID;
    else if (! isRetina && isTerrain)
        mapID = kNormalTerrainSourceID;
    else if (! isRetina && ! isTerrain)
        mapID = kNormalRegularSourceID;
    
    self.mapView.tileSource = [[RMMapBoxSource alloc] initWithMapID:mapID];
}

@end