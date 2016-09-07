//
//  RSSEntry.h
//  RSS Tutorial
//
//  Created by Ireneo Decano on 14/3/15.
//  Copyright (c) 2015 Ireneo Decano. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSSEntry : NSObject{
    NSString *_blogTitle;
    NSString *_articleTitle;
    NSString *_articleUrl;
    NSDate *_articleDate;
}

@property (copy) NSString *blogTitle;
@property (copy) NSString *articleTitle;
@property (copy) NSString *articleUrl;
@property (copy) NSDate *articleDate;

- (id)initWithBlogTitle:(NSString*)blogTitle articleTitle:(NSString*)articleTitle articleUrl:(NSString*)articleUrl articleDate:(NSDate*)articleDate;
@end
