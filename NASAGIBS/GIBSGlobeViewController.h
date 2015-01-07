//
//  TR1ViewController.h
//  NASAGIBS
//
//  Created by MSaktiAlvissalim on 2014/10/10.
//  Copyright (c) 2014年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WhirlyGlobeComponent.h"
#import "GIBSLayersTableViewController.h"
#import "GIBSLayer.h"
#import "GIBSTimeSliderViewController.h"
#import "GIBSLegendBuilder.h"
#import <CoreLocation/CoreLocation.h>

#define IS_PORTRAIT     UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])
#define IS_LANDSCAPE    UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])

@interface GIBSGlobeViewController : UIViewController <WhirlyGlobeViewControllerDelegate,CLLocationManagerDelegate>

@property OptionType option;


@property GIBSLayer *selectedLayer;
@property GIBSLayer *overlayLayer;
@property UIImage *legendImage;

@end
