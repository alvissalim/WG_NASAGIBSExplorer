//
//  QuakeParser.h
//  NASAGIBS
//
//  Created by MSaktiAlvissalim on 2014/10/11.
//  Copyright (c) 2014年 Alvis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WhirlyGlobeComponent.h"

@interface QuakeParser : NSObject <NSXMLParserDelegate>

@property NSMutableArray *markers;

- (id) initWithXMLData:(NSData *) data;

@end
