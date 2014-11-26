//
//  SettingViewController.h
//  NASAGIBS
//
//  Created by MSaktiAlvissalim on 2014/10/11.
//  Copyright (c) 2014年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GIBSCapabilityParser.h"

typedef enum {EarthQuakeOption,StadiumOption} OptionType;

typedef enum {BaseLayerSelection,OverlayLayerSelection} SelectionType;

@class GIBSLayersTableViewController;
@class GIBSLayer;

@protocol SelectionDelegate <NSObject>
- (void)addItemViewController:(GIBSLayersTableViewController *)controller didFinishEnteringItem:(GIBSLayer *)item layerType:(SelectionType) type;
@end


@interface GIBSLayersTableViewController : UITableViewController

@property (nonatomic, weak) id <SelectionDelegate> delegate;

@property OptionType optionType;
@property SelectionType selection;

@property GIBSCapabilityParser *capabilitiesParser;

- (void)didReceiveNewData:(NSNotification *) notification;
- (void) runParser;
@end
