//
//  TR1ViewController.m
//  NASAGIBS
//
//  Created by MSaktiAlvissalim on 2014/10/10.
//  Copyright (c) 2014年 Alvis. All rights reserved.
//

#import "GIBSGlobeViewController.h"
#import "WhirlyGlobeComponent.h"
#include "GIBSRemoteTile.h"
#import "QuakeParser.h"
#import "GIBSLayersTableViewController.h"
#import "GIBSCapabilityParser.h"

@interface GIBSGlobeViewController ()

@end

@implementation GIBSGlobeViewController{
    WhirlyGlobeViewController *theViewC;
    MaplyQuadImageTilesLayer *aerialLayer;
    MaplyQuadImageTilesLayer *scienceLayer;
    MaplyComponentObject *selectLabelObj;
    NSDate *startDate, *endDate, *selectedDate;
    NSDate *beginningDate;
    UISlider *slider;
    UILabel *selectedDateLabel;
    NSDateFormatter *formatter;
    NSString *overlayExt;
        NSString *baseExt;
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    CLLocation* location;
}

- (void) globeViewController:(WhirlyGlobeViewController *)viewC didSelect:(NSObject *)selectedObj atLoc:(MaplyCoordinate)coord onScreen:(CGPoint)screenPt{
    if (selectLabelObj){
        [theViewC removeObject:selectLabelObj];
        selectLabelObj = nil;
    }
    
    if ([selectedObj isKindOfClass:[MaplyScreenMarker class]]){
        MaplyScreenMarker *marker = (MaplyScreenMarker *) selectedObj;
        NSString *title = (NSString *) marker.userObject;
        
        MaplyScreenLabel *label = [[MaplyScreenLabel alloc] init];
        label.loc = coord;
        label.text = title;
        selectLabelObj = [theViewC addScreenLabels:@[label] desc:@{kMaplyFont: [UIFont systemFontOfSize:12.]}];
    }
}

- (IBAction)sliderReleased:(UISlider *)sender {
    NSLog(@"slider value = %f", sender.value);
    NSString *baseUrl = @"http://map1.vis.earthdata.nasa.gov/wmts-webmerc/";
    
    NSString *fullURL = [baseUrl stringByAppendingFormat:
                         @"%@/default/%@/%@/", [_selectedLayer name], selectedDateLabel.text,[_selectedLayer compatibility]];
    
    NSString *fullURLOverlay = [baseUrl stringByAppendingFormat:
                                @"%@/default/%@/%@/", [_overlayLayer name], selectedDateLabel.text,[_overlayLayer compatibility]];
    MaplyRemoteTileInfo *overlayLayerSourceInfo = [[GIBSRemoteTile alloc] initWithBaseURL:fullURLOverlay ext:overlayExt minZoom:0 maxZoom:20];
    
    MaplyRemoteTileSource *overlayLayerSource = [[MaplyRemoteTileSource alloc] initWithInfo:overlayLayerSourceInfo];
    
    MaplyRemoteTileInfo *baseLayerSourceInfo = [[GIBSRemoteTile alloc] initWithBaseURL:fullURL ext:baseExt minZoom:1 maxZoom:18];
    
    MaplyRemoteTileSource *baseLayerSource = [[MaplyRemoteTileSource alloc] initWithInfo:baseLayerSourceInfo];
    
    aerialLayer.tileSource = baseLayerSource;
    scienceLayer.tileSource = overlayLayerSource;
    
}

- (IBAction)sliderValueChanged:(id)sender
{
    // Create and initialize date component instance
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    
    [dateComponents setDay:slider.value];
    
    // Retrieve date with increased days count
    selectedDate = [[NSCalendar currentCalendar]
                             dateByAddingComponents:dateComponents
                             toDate:beginningDate options:0];
    
    selectedDateLabel.text =[formatter stringFromDate:selectedDate];
}

- (void) gotoCurrentLocation{
    [theViewC animateToPosition:MaplyCoordinateMakeWithDegrees(location.coordinate.longitude,location.coordinate.latitude) time:2.0];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    location = [locations lastObject];
}

- (void) toggleOverlay
{
    static BOOL overlayState = true;
    overlayState = !overlayState;
    if (overlayState){
        [theViewC addLayer:scienceLayer];
    }
    else{
        [theViewC removeLayer:scienceLayer];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    theViewC = [[WhirlyGlobeViewController alloc] init];
    [self.view addSubview:theViewC.view];
    theViewC.view.frame = self.view.bounds;
    [self addChildViewController:theViewC];
    theViewC.delegate = self;
    

    locationManager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy'-'MM'-'dd"];
    
    CGRect screenRect = [self.view frame];
    
    CGFloat screenWidth;
    CGFloat screenHeight;
    
    if (IS_PORTRAIT){
        screenWidth = screenRect.size.width;
        screenHeight = screenRect.size.height;
    }
    else{
        screenWidth = screenRect.size.height;
        screenHeight = screenRect.size.width;
    }
    // The above part doesn't work, don't know why
    

    slider = [[UISlider alloc] initWithFrame:CGRectMake(10,screenHeight - 50,screenWidth - 20,10)];
    
    slider.minimumValue = 0;
    slider.maximumValue = 30;
    slider.continuous = YES;
    slider.value = 30;
    
    UISwitch *overlaySwitchButton = [[UISwitch alloc] initWithFrame:CGRectMake(20,screenHeight - 120,20,20)];
    [overlaySwitchButton addTarget:self action:@selector(toggleOverlay) forControlEvents:UIControlEventValueChanged];
    [overlaySwitchButton setOn:true];
    
    [self.view addSubview:overlaySwitchButton];
    
    UIButton * goHomeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIImage *homeImage = [UIImage imageNamed:@"home.png"];
    [goHomeButton setImage:homeImage forState:UIControlStateNormal];
    [goHomeButton addTarget:self action:@selector(gotoCurrentLocation) forControlEvents:(UIControlEventTouchDown)];
    
    [goHomeButton setFrame:CGRectMake(screenWidth - 50, screenHeight - 130, 30, 30)];
    
    [self.view addSubview:goHomeButton];
    
    [slider addTarget:self action:@selector(sliderValueChanged:)forControlEvents:UIControlEventValueChanged];
    
    [slider addTarget:self action:@selector(sliderReleased:) forControlEvents:UIControlEventTouchUpInside];
    
    [slider setBackgroundColor:[UIColor clearColor]];
    
    [self.view addSubview:slider];
    
    CGRect rect = CGRectMake(10, 70, screenWidth - 20, 5);
    
    UIImageView * legendView = [[UIImageView alloc] initWithFrame:rect];
    
    [legendView setImage:[GIBSLegendBuilder getImage]];
    
    [self.view addSubview:legendView];
    
    UILabel *minValLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 80 ,100,20)];
    
    if ([[GIBSLegendBuilder getInfo] count] > 0){
    minValLabel.text = [[GIBSLegendBuilder getInfo] objectAtIndex:0];
    minValLabel.textColor = [UIColor orangeColor];
    
    [self.view addSubview:minValLabel];
    
    
    UILabel *maxValLabel = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth - 100, 80 ,100,20)];
    
    maxValLabel.textAlignment = NSTextAlignmentRight;
    maxValLabel.text = [[GIBSLegendBuilder getInfo] objectAtIndex:1];
    maxValLabel.textColor = [UIColor orangeColor];
    
    [self.view addSubview:maxValLabel];
    
    
    
    UILabel *unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth/2.0 - 20, 80 ,100,20)];
    
    
    unitLabel.text = [[GIBSLegendBuilder getInfo] objectAtIndex:2];
    unitLabel.textColor = [UIColor orangeColor];
    
    //[self.view addSubview:unitLabel];
    }
    
    // Determine common start date and end date
    
    if ([_selectedLayer.startDate compare:_overlayLayer.startDate] == NSOrderedAscending){
        startDate = _selectedLayer.startDate;
    }
    else{
        startDate = _overlayLayer.startDate;
    }
    
    if ([_selectedLayer.endDate compare:_overlayLayer.endDate] == NSOrderedDescending){
        endDate = _selectedLayer.endDate;
    }
    else{
        endDate = _overlayLayer.endDate;
    }
    
    
    // Create and initialize date component instance
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    
    [dateComponents setDay:-30];
    
    // Retrieve date with increased days count
    beginningDate = [[NSCalendar currentCalendar]
                       dateByAddingComponents:dateComponents
                       toDate:endDate options:0];
    
    

    
    UILabel *startDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,screenHeight - 30,100,20)];
    
    startDateLabel.text = [formatter stringFromDate:beginningDate];
    startDateLabel.textColor = [UIColor orangeColor];

    UILabel *endDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth - 100,screenHeight - 30,100,20)];
    
    endDateLabel.text = [formatter stringFromDate:endDate];
    endDateLabel.textColor = [UIColor orangeColor];

    selectedDate = endDate;
    
    selectedDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth/2. - 50, screenHeight - 80,100,20)];
    
    selectedDateLabel.text = [formatter stringFromDate:selectedDate];
    selectedDateLabel.textColor = [UIColor orangeColor];

    
    
    //[self.view addSubview:startDateLabel];
    //[self.view addSubview:endDateLabel];
    [self.view addSubview:selectedDateLabel];
    
    //GIBSTimeSliderViewController *sliderView = [[GIBSTimeSliderViewController alloc] init];
    
    //[self addChildViewController:sliderView];
    //[self.view addSubview:sliderView.view];
    //sliderView.view.frame = self.view.bounds;
    
    
     NSMutableArray *tileSources = [NSMutableArray array];
    
    //SettingViewController viewController = [SettingViewController alloc];
    
    
    NSString *baseCacheDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *aerialTilesCacheDir = [NSString stringWithFormat:@"%@/myTiles8/",baseCacheDir];
    int maxZoom = 18;
    

    
    // OSM Data
    //GIBSREmoteTile *tileSource = [[GIBSREmoteTile alloc] initWithBaseURL:@"http://otile1.mqcdn.com/tiles/1.0.0/sat/" ext:@"png" minZoom:0 maxZoom:maxZoom];
    
    
    NSString *baseUrl = @"http://map1.vis.earthdata.nasa.gov/wmts-webmerc/";
    
    NSString *fullURL = [baseUrl stringByAppendingFormat:
                         @"%@/default/%@/%@/", [_selectedLayer name], endDateLabel.text,[_selectedLayer compatibility]];
    
    NSString *fullURLOverlay = [baseUrl stringByAppendingFormat:
                         @"%@/default/%@/%@/", [_overlayLayer name], endDateLabel.text,[_overlayLayer compatibility]];
    

    

    
    if ([_selectedLayer.format isEqualToString:@"image/png"]) {
        baseExt = @"png";
    }
    else if ([_selectedLayer.format isEqualToString:@"image/jpeg"]){
        baseExt = @"jpg";
    }
    

    
    if ([_overlayLayer.format isEqualToString:@"image/png"]) {
        overlayExt = @"png";
    }
    else if ([_overlayLayer.format isEqualToString: @"image/jpeg"]){
        overlayExt = @"jpg";
    }
    
    MaplyRemoteTileInfo *tileSourceInfo = [[GIBSRemoteTile alloc] initWithBaseURL:fullURL ext:baseExt minZoom:1 maxZoom:maxZoom];
    

    MaplyRemoteTileInfo *tileSourceInfo2 = [[GIBSRemoteTile alloc] initWithBaseURL:@"http://map1.vis.earthdata.nasa.gov/wmts-webmerc/MODIS_Terra_CorrectedReflectance_TrueColor/default/2014-10-02/GoogleMapsCompatible_Level9/" ext:@"jpg" minZoom:1 maxZoom:maxZoom];
    
    
    MaplyRemoteTileInfo *tileSourceInfo3 = [[GIBSRemoteTile alloc] initWithBaseURL:@"http://map1.vis.earthdata.nasa.gov/wmts-webmerc/MODIS_Terra_CorrectedReflectance_TrueColor/default/2014-10-03/GoogleMapsCompatible_Level9/" ext:@"jpg" minZoom:1 maxZoom:maxZoom];
    
    
    MaplyRemoteTileInfo *tileSourceInfo4 = [[GIBSRemoteTile alloc] initWithBaseURL:@"http://map1.vis.earthdata.nasa.gov/wmts-webmerc/MODIS_Terra_CorrectedReflectance_TrueColor/default/2014-10-04/GoogleMapsCompatible_Level9/" ext:@"jpg" minZoom:1 maxZoom:maxZoom];
    
    
    MaplyMultiplexTileSource *tileSource = [[MaplyMultiplexTileSource alloc] initWithSources:@[tileSourceInfo]];
    
    
    MaplyRemoteTileInfo *scienceLayerSourceInfo = [[GIBSRemoteTile alloc] initWithBaseURL:fullURLOverlay ext:overlayExt minZoom:1 maxZoom:maxZoom];
    
    
    MaplyRemoteTileSource *scienceLayerSource = [[MaplyRemoteTileSource alloc] initWithInfo:scienceLayerSourceInfo];
    
    
    //tileSource.cacheDir = aerialTilesCacheDir;
    aerialLayer = [[MaplyQuadImageTilesLayer alloc] initWithCoordSystem:tileSource.coordSys tileSource:tileSource];
    
    scienceLayer = [[MaplyQuadImageTilesLayer alloc] initWithCoordSystem:scienceLayerSource.coordSys tileSource:scienceLayerSource];
    
    aerialLayer.flipY = YES;
    scienceLayer.flipY = YES;
    
    [theViewC addLayer:aerialLayer];
    [theViewC addLayer:scienceLayer];
    

    
    switch (_option){
        case EarthQuakeOption:
            //[self fetchEarthquake];
            break;
        case StadiumOption:
            //[self fetchCapabilities];
            break;
    }
    
    /*
    MaplyScreenMarker *marker = [[MaplyScreenMarker alloc] init];
    marker.loc = MaplyCoordinateMakeWithDegrees(-122.4166667, 37.783333);
    marker.image = [UIImage imageNamed:@"alcohol-shop-24@2x.png"];
    marker.size = CGSizeMake(40, 40);
    marker.layoutImportance = MAXFLOAT;
    
    MaplyCoordinate coords[4];
    coords[0] = MaplyCoordinateMakeWithDegrees(-122.416667, 37.783333);
    coords[1] = MaplyCoordinateMakeWithDegrees(-122.516667, 37.783333);
    coords[2] = MaplyCoordinateMakeWithDegrees(-122.516667, 37.883333);
    coords[3] = MaplyCoordinateMakeWithDegrees(-122.416667, 37.883333);
    
    MaplyVectorObject *sfOutline = [[MaplyVectorObject alloc] initWithAreal:coords numCoords:4 attributes:nil];
    [theViewC addVectors:@[sfOutline] desc:@{kMaplyColor: [UIColor redColor], kMaplyFilled : @YES}];
    
    [theViewC addScreenMarkers:@[marker] desc:nil mode:MaplyThreadAny];
    //[theViewC addLayer:aerialLayer];
    //[theViewC setHeight:0.1];
     */
    [theViewC animateToPosition:MaplyCoordinateMakeWithDegrees(-122.41667,37.7833) time:1.0];
	// Do any additional setup after loading the view, typically from a nib.
    

    
    

    
    

    //[self fetchCapabilities];
    
    }


- (void)fetchEarthquake{
    NSString *urlStr = @"http://map1.vis.earthdata.nasa.gov/wmts-webmerc/wmts.cgi?SERVICE=WMTS&request=GetCapabilities";
    NSURLRequest *urlReq = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    [NSURLConnection sendAsynchronousRequest:urlReq queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        //NSLog(@"response: %@", response);
        //NSError *jsonError = nil;
        //NSString *feedsStr = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        //NSLog(@"feed = %@",feedsStr);
        
        //[theViewC addScreenMarkers:stadiums desc:nil];
        //QuakeParser *quakeParser = [[QuakeParser alloc] initWithXMLData:data];
        //GIBSCapabilityParser *quakeParser = [[GIBSCapabilityParser alloc] initWithXMLData:data];
        
        
        //[theViewC addScreenMarkers:quakeParser.markers desc:nil];

    }];

}


- (void)fetchCapabilities{
    NSString *urlStr = @"https://raw.githubusercontent.com/cageyjames/GeoJSON-Ballparks/master/ballparks.geojson";
    NSURLRequest *urlReq = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
                            
    [NSURLConnection sendAsynchronousRequest:urlReq queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSLog(@"response: %@", response);
        NSError *jsonError = nil;
        id obj = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        if ([obj isKindOfClass:[NSDictionary class]]){
            NSDictionary *capabilitiesDict = obj;
            NSLog(@"Return : %@",capabilitiesDict);
        }
        
        NSMutableArray *stadiums = [NSMutableArray array];
        MaplyVectorObject *stadiumVec = [MaplyVectorObject VectorObjectFromGeoJSON:data];
        for(MaplyVectorObject *stadium in [stadiumVec splitVectors]){
            MaplyScreenMarker *stadiumMarker = [[MaplyScreenMarker alloc] init];
            stadiumMarker.userObject = stadium.attributes[@"Ballpark"];
            stadiumMarker.loc = [stadium center];
            stadiumMarker.image = [UIImage imageNamed:@"baseball-24@2x.png"];
            stadiumMarker.size = CGSizeMake(20,20);
            stadiumMarker.layoutImportance = MAXFLOAT;
            [stadiums addObject:stadiumMarker];
        }
        
        [theViewC addScreenMarkers:stadiums desc:nil];
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
