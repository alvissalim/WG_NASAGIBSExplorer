//
//  GIBSCapabilityParser.m
//  NASAGIBS
//
//  Created by MSaktiAlvissalim on 2014/10/11.
//  Copyright (c) 2014年 Alvis. All rights reserved.
//

#import "GIBSCapabilityParser.h"
#import "TR1Layer.h"

@implementation GIBSCapabilityParser


{
    bool layerValid;
    bool identifierValid;
    bool tileSetValid;
    bool timeValid;
    bool styleValid;
    bool formatValid;
    
    NSString *layerIdentifier;
    NSString *layerTileset;
    NSString *layerTimeRange;
    NSString *layerFormat;
    
}

- (id) initWithXMLData:(NSData *) data
{
    self = [super init];
    
    _layerList = [[NSMutableArray alloc] initWithCapacity:10];
    
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:data];
    xmlParser.delegate = self;
    [xmlParser parse];
    
    
   
    return self;
}

-(void) parserDidStartDocument:(NSXMLParser *)parser
{
    
}

-(void) parserDidEndDocument:(NSXMLParser *)parser{
    
}



-(void) parser:(NSXMLParser *) parser foundCharacters:(NSString *)string
{
    if (identifierValid){
        layerIdentifier = string;
    }
    else if (tileSetValid){
        layerTileset = string;
    }
    else if (timeValid){
        layerTimeRange = string;
    }
    else if (formatValid){
        layerFormat = string;
    }
}


-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"Layer"]){
        layerValid = true;
        identifierValid = false;
        tileSetValid = false;
        timeValid = false;
        formatValid = false;
        
        layerIdentifier = nil;
        layerTileset = nil;
        layerTimeRange = nil;
        layerFormat = nil;
        
    }
    else if ([elementName isEqualToString:@"ows:Title"]  &&  styleValid == false){
        identifierValid = true;
    }
    else if ([elementName isEqualToString:@"TileMatrixSet"]){
        tileSetValid = true;
    }
    else if ([elementName isEqualToString:@"Style"]){
        styleValid = true;
    }
    
    else if ([elementName isEqualToString:@"Value"]){
        timeValid = true;
    }
    
    else if ([elementName isEqualToString:@"Format"]){
        formatValid = true;
    }
    
}


-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    //NSLog(@"Element : %@",elementName);
    if([elementName isEqualToString:@"Layer"]){
        if (layerValid && layerIdentifier && layerTimeRange && layerTileset && layerFormat){
            NSLog(@"Identifier = %@, ;tileSet = %@; timerange = %@", layerIdentifier,layerTileset, layerTimeRange);
            TR1Layer *newLayer = [TR1Layer alloc];
            newLayer.name = layerIdentifier;
            newLayer.timeRange = layerTimeRange;
            newLayer.compatibility = layerTileset;
            newLayer.format = layerFormat;
            [_layerList addObject:newLayer];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"layerAdd" object:self];
        }
        layerValid = false;
    }
    else if ([elementName isEqualToString:@"ows:Title"]){
        identifierValid = false;
    }
    else if ([elementName isEqualToString:@"Style"]){
        styleValid = false;
    }
    else if ([elementName isEqualToString:@"Value"]){
        timeValid = false;
    }
    else if ([elementName isEqualToString:@"TileMatrixSet"]){
        tileSetValid = false;
    }
    else if ([elementName isEqualToString:@"Format"]){
        formatValid = false;
    }
}


@end
