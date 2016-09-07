//
//  MainViewController.h
//  Newsflash
//
//  Created by Ireneo Decano on 15/3/15.
//  Copyright (c) 2015 Ireneo Decano. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICustomActionSheet.h"
#import "ASIHTTPRequest.h"
#import "ContentWebViewController.h"

@interface MainViewController : UIViewController <UIActionSheetDelegate, UITableViewDataSource, UITableViewDelegate, ASIHTTPRequestDelegate>
{
    NSMutableArray *_allEntries;
    
    NSOperationQueue *_queue;
    NSArray *_feeds;
    NSMutableArray *_feedNames;
    
    ContentWebViewController *_contentWebViewController;
}

@property (retain) NSMutableArray *allEntries;

@property (retain) NSOperationQueue *queue;
@property (retain) NSArray *feeds;
@property (retain) NSMutableArray *feedNames;
@property (assign) int nCurrentFeed;

@property (weak, nonatomic) IBOutlet UIScrollView *categoryScrollView;
@property (weak, nonatomic) IBOutlet UITableView *RSSUITableView;

@property (retain) ContentWebViewController *contentWebViewController;

@property (weak, nonatomic) IBOutlet UILabel *lblDate;

- (IBAction)pressAddListButton:(id)sender;
- (IBAction)pressMoreButton:(id)sender;
@end
