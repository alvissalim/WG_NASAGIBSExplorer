//
//  TR1LayerSelectViewController.h
//  NASAGIBS
//
//  Created by MSaktiAlvissalim on 2014/11/14.
//  Copyright (c) 2014年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TR1Layer.h"
#import "SettingViewController.h"


@interface TR1LayerSelectViewController : UITableViewController <SelectionDelegate>
- (void) runGlobe;

@property TR1Layer *base;
@property TR1Layer *overlay;

@end
