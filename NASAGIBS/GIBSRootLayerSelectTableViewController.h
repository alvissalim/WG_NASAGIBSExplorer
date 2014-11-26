//
//  TR1LayerSelectViewController.h
//  NASAGIBS
//
//  Created by MSaktiAlvissalim on 2014/11/14.
//  Copyright (c) 2014年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GIBSLayer.h"
#import "GIBSLayersTableViewController.h"
#import "GIBSTimeSliderViewController.h"

@interface GIBSRootLayerSelectTableViewController : UITableViewController <SelectionDelegate>
- (void) runGlobe;

@property GIBSLayer *base;
@property GIBSLayer *overlay;

@end
