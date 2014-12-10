//
//  GIBSCapabilityParser.m
//  NASAGIBS
//
//  Created by MSaktiAlvissalim on 2014/10/11.
//  Copyright (c) 2014年 Alvis. All rights reserved.
//

#import "GIBSCapabilityParser.h"
#import "GIBSLayer.h"

@implementation GIBSCapabilityParser


{
    bool layerValid;
    bool identifierValid;
    bool tileSetValid;
    bool timeValid;
    bool styleValid;
    bool formatValid;
    bool metadaValid;
    
    NSString *layerIdentifier;
    NSString *layerTileset;
    NSString *layerTimeRange;
    NSString *layerFormat;
    NSString *metaDataUrl;
    NSDateFormatter *dateFormatter;
    
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
    dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd"];
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
        metadaValid = false;
        
        layerIdentifier = nil;
        layerTileset = nil;
        layerTimeRange = nil;
        layerFormat = nil;
        metaDataUrl = nil;
        
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
    else if ([elementName isEqualToString:@"ows:Metadata"]){
        metadaValid = true;
        metaDataUrl = [attributeDict objectForKey:@"xlink:href"];
    }
}


-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    //NSLog(@"Element : %@",elementName);
    if([elementName isEqualToString:@"Layer"]){
        if (layerValid && layerIdentifier && layerTileset && layerFormat){
            NSLog(@"Identifier = %@, ;tileSet = %@; timerange = %@", layerIdentifier,layerTileset, layerTimeRange);
            GIBSLayer *newLayer = [GIBSLayer alloc];
            newLayer.name = layerIdentifier;
            newLayer.compatibility = layerTileset;
            newLayer.format = layerFormat;
            
            if (layerTimeRange == NULL){
                layerTimeRange =  @"2002-06-01/2011-10-04/P1D"; // Some layer don't have time information (static)
            }
            
            newLayer.timeRange = layerTimeRange;
            
            NSArray *dates = [layerTimeRange componentsSeparatedByString:@"/"];
            // Parse dates
            
            if (metadaValid){
                newLayer.metaDataUrl = metaDataUrl;
            }
            else{
                newLayer.metaDataUrl = nil;
            }
            
            newLayer.startDate = [dateFormatter dateFromString:[dates objectAtIndex:0]];
            newLayer.endDate = [dateFormatter dateFromString:[dates objectAtIndex:1]];
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
