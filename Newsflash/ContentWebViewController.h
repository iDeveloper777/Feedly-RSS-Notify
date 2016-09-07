//
//  ContentWebViewController.h
//  RSS Tutorial
//
//  Created by Ireneo Decano on 14/3/15.
//  Copyright (c) 2015 Ireneo Decano. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RSSEntry;

@interface ContentWebViewController : UIViewController {
    UIWebView *_webView;
    RSSEntry *_entry;
}

@property (retain) IBOutlet UIWebView *webView;
@property (retain) RSSEntry *entry;

@end