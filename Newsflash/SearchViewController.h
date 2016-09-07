//
//  SearchViewController.h
//  Newsflash
//
//  Created by Ireneo Decano on 15/3/15.
//  Copyright (c) 2015 Ireneo Decano. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSON.h"

@interface SearchViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *navigationUIView;


@property (weak, nonatomic) IBOutlet UILabel *lblComment;
@property (weak, nonatomic) IBOutlet UITableView *webView;

- (IBAction)pressBackButton:(id)sender;
- (IBAction)pressSearchButton:(id)sender;
- (IBAction)pressCancelButton:(id)sender;
@end
