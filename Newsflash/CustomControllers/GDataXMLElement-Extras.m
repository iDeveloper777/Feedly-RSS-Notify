//
//  GDataXMLElement-Extras.m
//  RSS Tutorial
//
//  Created by Ireneo Decano on 14/3/15.
//  Copyright (c) 2015 Ireneo Decano. All rights reserved.
//

#import "GDataXMLElement-Extras.h"

@implementation GDataXMLElement (Extras)

- (GDataXMLElement *)elementForChild:(NSString *)childName {
    NSArray *children = [self elementsForName:childName];
    if (children.count > 0) {
        GDataXMLElement *childElement = (GDataXMLElement *) [children objectAtIndex:0];
        return childElement;
    } else return nil;
}

- (NSString *)valueForChild:(NSString *)childName {
    return [[self elementForChild:childName] stringValue];
}

@end
