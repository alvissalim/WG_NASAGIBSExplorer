//
//  QuakeParser.m
//  NASAGIBS
//
//  Created by MSaktiAlvissalim on 2014/10/11.
//  Copyright (c) 2014年 Alvis. All rights reserved.
//

#import "QuakeParser.h"

@implementation QuakeParser

- (id) initWithXMLData:(NSData *) data
{
    self = [super init];
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

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    //NSLog(@"Element : %@",elementName);
}

@end
