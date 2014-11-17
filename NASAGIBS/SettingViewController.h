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

@class SettingViewController;
@class TR1Layer;

@protocol SelectionDelegate <NSObject>
- (void)addItemViewController:(SettingViewController *)controller didFinishEnteringItem:(TR1Layer *)item layerType:(SelectionType) type;
@end


@interface SettingViewController : UITableViewController

@property (nonatomic, weak) id <SelectionDelegate> delegate;

@property OptionType optionType;
@property SelectionType selection;


- (void)didReceiveNewData:(NSNotification *) notification;
@end
