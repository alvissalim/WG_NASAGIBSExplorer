//
//  TR1ViewController.m
//  NASAGIBS
//
//  Created by MSaktiAlvissalim on 2014/10/10.
//  Copyright (c) 2014年 Alvis. All rights reserved.
//

#import "TR1ViewController.h"
#import "WhirlyGlobeComponent.h"
#include "GIBSREmoteTile.h"
#import "QuakeParser.h"
#import "SettingViewController.h"
#import "GIBSCapabilityParser.h"

@interface TR1ViewController ()

@end

@implementation TR1ViewController{
    WhirlyGlobeViewController *theViewC;
    MaplyQuadImageTilesLayer *aerialLayer;
    MaplyQuadImageTilesLayer *scienceLayer;
    MaplyComponentObject *selectLabelObj;
   
    
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    theViewC = [[WhirlyGlobeViewController alloc] init];
    [self.view addSubview:theViewC.view];
    theViewC.view.frame = self.view.bounds;
    [self addChildViewController:theViewC];
    theViewC.delegate = self;
    
     NSMutableArray *tileSources = [NSMutableArray array];
    
    //SettingViewController viewController = [SettingViewController alloc];
    
    
    NSString *baseCacheDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *aerialTilesCacheDir = [NSString stringWithFormat:@"%@/myTiles5/",baseCacheDir];
    int maxZoom = 18;
    

    
    // OSM Data
    //GIBSREmoteTile *tileSource = [[GIBSREmoteTile alloc] initWithBaseURL:@"http://otile1.mqcdn.com/tiles/1.0.0/sat/" ext:@"png" minZoom:0 maxZoom:maxZoom];
    
    
    NSString *baseUrl = @"http://map1.vis.earthdata.nasa.gov/wmts-webmerc/";
    
    
    NSString *fullURL = [baseUrl stringByAppendingFormat:
                         @"%@/default/2014-10-01/%@/", [_selectedLayer name], [_selectedLayer compatibility]];
    
    NSString *fullURLOverlay = [baseUrl stringByAppendingFormat:
                         @"%@/default/2014-10-01/%@/", [_overlayLayer name], [_overlayLayer compatibility]];
    

    NSString *baseExt;
    
    if ([_selectedLayer.format isEqualToString:@"image/png"]) {
        baseExt = @"png";
    }
    else if ([_selectedLayer.format isEqualToString:@"image/jpeg"]){
        baseExt = @"jpg";
    }
    
    NSString *overlayExt;
    
    if ([_overlayLayer.format isEqualToString:@"image/png"]) {
        overlayExt = @"png";
    }
    else if ([_overlayLayer.format isEqualToString: @"image/jpeg"]){
        overlayExt = @"jpg";
    }
    
    MaplyRemoteTileInfo *tileSourceInfo = [[GIBSREmoteTile alloc] initWithBaseURL:fullURL ext:baseExt minZoom:1 maxZoom:maxZoom];
    

    MaplyRemoteTileInfo *tileSourceInfo2 = [[GIBSREmoteTile alloc] initWithBaseURL:@"http://map1.vis.earthdata.nasa.gov/wmts-webmerc/MODIS_Terra_CorrectedReflectance_TrueColor/default/2014-10-02/GoogleMapsCompatible_Level9/" ext:@"jpg" minZoom:1 maxZoom:maxZoom];
    
    
    MaplyRemoteTileInfo *tileSourceInfo3 = [[GIBSREmoteTile alloc] initWithBaseURL:@"http://map1.vis.earthdata.nasa.gov/wmts-webmerc/MODIS_Terra_CorrectedReflectance_TrueColor/default/2014-10-03/GoogleMapsCompatible_Level9/" ext:@"jpg" minZoom:1 maxZoom:maxZoom];
    
    
    MaplyRemoteTileInfo *tileSourceInfo4 = [[GIBSREmoteTile alloc] initWithBaseURL:@"http://map1.vis.earthdata.nasa.gov/wmts-webmerc/MODIS_Terra_CorrectedReflectance_TrueColor/default/2014-10-04/GoogleMapsCompatible_Level9/" ext:@"jpg" minZoom:1 maxZoom:maxZoom];
    
    
    MaplyMultiplexTileSource *tileSource = [[MaplyMultiplexTileSource alloc] initWithSources:@[tileSourceInfo]];
    
    
    MaplyRemoteTileInfo *scienceLayerSourceInfo = [[GIBSREmoteTile alloc] initWithBaseURL:fullURLOverlay ext:overlayExt minZoom:1 maxZoom:maxZoom];
    
    
    MaplyRemoteTileSource *scienceLayerSource = [[MaplyRemoteTileSource alloc] initWithInfo:scienceLayerSourceInfo];
    
    
    //tileSource.cacheDir = aerialTilesCacheDir;
    aerialLayer = [[MaplyQuadImageTilesLayer alloc] initWithCoordSystem:tileSource.coordSys tileSource:tileSource];
    
    aerialLayer.animationPeriod =8;
    aerialLayer.imageDepth = 1;
    
    
    scienceLayer = [[MaplyQuadImageTilesLayer alloc] initWithCoordSystem:scienceLayerSource.coordSys tileSource:scienceLayerSource];
    
    aerialLayer.flipY = YES;
    scienceLayer.flipY = YES;
    
    [theViewC addLayer:aerialLayer];
    [theViewC addLayer:scienceLayer];
    

    
    switch (_option){
        case EarthQuakeOption:
            [self fetchEarthquake];
            break;
        case StadiumOption:
            //[self fetchCapabilities];
            break;
    }
    
    
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
