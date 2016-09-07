//
//  NSArray+Extras.h
//  RSS Tutorial
//
//  Created by Ireneo Decano on 14/3/15.
//  Copyright (c) 2015 Ireneo Decano. All rights reserved.
//

//
// Adapted from: http://blog.jayway.com/2009/03/28/adding-sorted-inserts-to-uimutablearray/
//
#import <Foundation/Foundation.h>

@interface NSArray (Extras)

typedef NSInteger (^compareBlock) (id a, id b);

-(NSUInteger)indexForInsertingObject:(id)anObject sortedUsingBlock:(compareBlock)compare;

@end
