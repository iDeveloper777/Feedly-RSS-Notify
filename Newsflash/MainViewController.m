//
//  MainViewController.m
//  Newsflash
//
//  Created by Ireneo Decano on 15/3/15.
//  Copyright (c) 2015 Ireneo Decano. All rights reserved.
//

#import "MainViewController.h"
#import "SearchViewController.h"

#import "RSSEntry.h"
#import "ASIHTTPRequest.h"

#import "GDataXMLNode.h"
#import "GDataXMLElement-Extras.h"

#import "NSDate+InternetDateTime.h"
#import "NSArray+Extras.h"

#import "ProgressHUD.h"

@interface MainViewController (){
    NSArray *monthsArray;
    int currentYear;
    int currentMonth;
    int currentDay;
    
    int scrollContentWidth;
    int padding;
    
    NSMutableArray *buttonArray;
    NSMutableArray *labelArray;

    int refreshFlag;
}
@end

@implementation MainViewController
@synthesize allEntries = _allEntries;
@synthesize feeds = _feeds;
@synthesize queue = _queue;
@synthesize feedNames = _feedNames;
@synthesize nCurrentFeed = _nCurrentFeed;
@synthesize contentWebViewController = _contentWebViewController;

- (void) addRows{
    RSSEntry *entry1 = [[RSSEntry alloc] initWithBlogTitle:@"1"
                                              articleTitle:@"1"
                                                articleUrl:@"1"
                                               articleDate:[NSDate date]];
    RSSEntry *entry2 = [[RSSEntry alloc] initWithBlogTitle:@"2"
                                              articleTitle:@"2"
                                                articleUrl:@"2"
                                               articleDate:[NSDate date]];
    RSSEntry *entry3 = [[RSSEntry alloc] initWithBlogTitle:@"3"
                                              articleTitle:@"3"
                                                articleUrl:@"3"
                                               articleDate:[NSDate date]];
    
    [_allEntries insertObject:entry1 atIndex:0];
    [_allEntries insertObject:entry2 atIndex:0];
    [_allEntries insertObject:entry3 atIndex:0];
}

- (void) refresh{
    if (_nCurrentFeed == 0){
        for (NSString *feed in _feeds) {
            NSURL *url = [NSURL URLWithString:feed];
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
            [request setDelegate:self];
            [_queue addOperation:request];
        }
    }
    else{
        NSURL *url = [NSURL URLWithString:[_feeds objectAtIndex:_nCurrentFeed]];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        [request setDelegate:self];
        [_queue addOperation:request];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    self.RSSUITableView.rowHeight = 75;
    self.RSSUITableView.separatorStyle = NO;
//    self.RSSUITableView.showsVerticalScrollIndicator = NO;
    padding = 15;
//    self.RSSUITableView.layer.borderColor = [[UIColor redColor] CGColor];
//    self.RSSUITableView.layer.borderWidth = 1.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    self.contentWebViewController = nil;
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self showDate];
    
    refreshFlag = 0;
    self.nCurrentFeed = 0;
    self.title = @"Feeds";
    self.allEntries = [NSMutableArray array];
    //    [self addRows];
    
    [self setScrollView];
    [self showFeedDatas];
}

- (void) viewWillDisappear:(BOOL)animated{
    [ProgressHUD dismiss];
}

- (void) setScrollView{
    buttonArray = [[NSMutableArray alloc] init];
    labelArray =  [[NSMutableArray alloc] init];
    scrollContentWidth = self.categoryScrollView.bounds.size.width;
    int totalWidth = 0;
    int currentYPosition = 0;
    int buttonWidth = 0;
    NSString *strButtonTitle;
    
    self.feedNames = (NSMutableArray *)[[NSArray alloc] initWithObjects:@"Notifications", @"oDesk", @"Elance", nil];
    
    for (int i = 0; i < self.feedNames.count; i ++) {
        strButtonTitle = (NSString *)[self.feedNames objectAtIndex:i];
        buttonWidth = (int)[strButtonTitle length] * 12;
        currentYPosition = totalWidth + padding;

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(currentYPosition, 15, buttonWidth, 30)];
        label.text = strButtonTitle;
        label.font =[UIFont fontWithName:@"Helvetica" size:26.0];
        label.tag = i;
        
        if (i == self.nCurrentFeed)
            label.textColor = [UIColor darkGrayColor];
        else
            label.textColor = [UIColor lightGrayColor];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapLabelWithGesture:)];
        tapGesture.numberOfTapsRequired = 1;
        [label setUserInteractionEnabled:YES];
        [label addGestureRecognizer:tapGesture];
        [label sizeToFit];
        [self.categoryScrollView addSubview:label];
        [labelArray addObject:label];
        
        buttonWidth = label.bounds.size.width;
        totalWidth = totalWidth + padding + buttonWidth;
    }
    
    totalWidth = totalWidth + padding;

    [self.categoryScrollView setContentSize:CGSizeMake(totalWidth, self.categoryScrollView.bounds.size.height)];
}

- (void)didTapLabelWithGesture:(UITapGestureRecognizer *)tapGesture {
    self.nCurrentFeed = (int)tapGesture.view.tag;
    
    UILabel *currentLabel = (UILabel *) tapGesture.view;
    
    currentLabel.textColor = [UIColor darkGrayColor];

    for (int i = 0; i < labelArray.count; i++){
        if (i != currentLabel.tag){
            UILabel *label = [labelArray objectAtIndex:i];
            label.textColor = [UIColor lightGrayColor];
        }
    }
    
    refreshFlag = 0;
    [self showFeedDatas];
}

- (void) showFeedDatas{
    self.queue = [[NSOperationQueue alloc] init];
    //        self.feeds = [NSArray arrayWithObjects:@"http://feeds.feedburner.com/RayWenderlich",
    //                      @"http://feeds.feedburner.com/vmwstudios",
    //                      @"http://idtypealittlefaster.blogspot.com/feeds/posts/default",
    //                      @"http://www.71squared.com/feed/",
    //                      @"http://cocoawithlove.com/feeds/posts/default",
    //                      @"http://feeds2.feedburner.com/brandontreb",
    //                      @"http://feeds.feedburner.com/CoryWilesBlog",
    //                      @"http://geekanddad.wordpress.com/feed/",
    //                      @"http://iphonedevelopment.blogspot.com/feeds/posts/default",
    //                      @"http://karnakgames.com/wp/feed/",
    //                      @"http://kwigbo.com/rss",
    //                      @"http://shawnsbits.com/feed/",
    //                      @"http://pocketcyclone.com/feed/",
    //                      @"http://www.alexcurylo.com/blog/feed/",
    //                      @"http://feeds.feedburner.com/maniacdev",
    //                      @"http://feeds.feedburner.com/macindie",
    //                      nil];
    self.feeds = [NSArray arrayWithObjects:@"", @"https://www.odesk.com/find-work-home/rss?securityToken=8a196fbba86675282d79e14a5e77c2bbde50aae82aed3eb8bfe4cd92c14667de~7789355", @"https://www.elance.com/r/rss/jobs/cat-it-programming/sct-mobile-applications-11033", nil];
    [self refresh];
    
    [ProgressHUD show:@"Loading..."];

}

- (void) showDate{
    monthsArray = @[@"January", @"Febrary", @"March", @"April", @"May", @"June", @"July", @"August", @"September", @"October", @"November", @"December"];
    
    NSDate *date = [NSDate date];
    
    //Get Current Year
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSString *currentYearString = [NSString stringWithFormat:@"%@", [formatter stringFromDate:date]];
    currentYear = (int)[currentYearString integerValue];
    
    //Get Current Month
    [formatter setDateFormat:@"MM"];
    NSString *currentMonthString = [NSString stringWithFormat:@"%ld", (long)[[formatter stringFromDate:date]integerValue]];
    currentMonth = (int)[currentMonthString integerValue];
    
    //Get Current Date
    [formatter setDateFormat:@"dd"];
    NSString *currentDayString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    currentDay = (int)[currentDayString integerValue];
    
    self.lblDate.text = [NSString stringWithFormat:@"%@ %@, %@", [monthsArray objectAtIndex:currentMonth-1], currentDayString, currentYearString];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)pressAddListButton:(id)sender {
    SearchViewController *searchViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"searchView"];
    [self presentViewController:searchViewController animated:YES completion:nil];
}

- (IBAction)pressMoreButton:(id)sender {
    [self showMoreMenu];
}

////Image processing----
- (void) showMoreMenu
{
//    NSLog(@"Import!!!");
    UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Mute for:" otherButtonTitles:@"One hour",@"Two hours", @"Four hours", @"Four hours", @"Eight hours", @"Twelve hours", @"Turn off Muting (2 hours left)", nil];

    [actionSheet showInView:self.view];
    
}

#pragma mark ActionSheet

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0)
        [self importFromCamera];
    else if(buttonIndex==1)
        [self importFromPhotoLibrary];
}

-(IBAction)importFromCamera
{

}

-(IBAction)importFromPhotoLibrary
{

}

#pragma ASIHTTPRequest

- (void) requestFinished:(ASIHTTPRequest *)request{
    //    RSSEntry *entry = [[RSSEntry alloc] initWithBlogTitle:request.url.absoluteString
    //                                              articleTitle:request.url.absoluteString
    //                                                articleUrl:request.url.absoluteString
    //                                               articleDate:[NSDate date]];
    //    int insertIdx = 0;
    //    [_allEntries insertObject:entry atIndex:insertIdx];
    //    [self.RSSUITableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:insertIdx inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
    if (refreshFlag == 0){
        [_allEntries removeAllObjects];
        [self.RSSUITableView reloadData];
    }
    
    [_queue addOperationWithBlock:^{
        
        NSError *error;
        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:[request responseData]
                                                               options:0 error:&error];
        if (doc == nil) {
            NSLog(@"Failed to parse %@", request.url);
        } else {
            
            NSMutableArray *entries = [NSMutableArray array];
            [self parseFeed:doc.rootElement entries:entries];
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                for (RSSEntry *entry in entries) {
                    
                    //                    int insertIdx = 0;
                    int insertIdx = (int)[_allEntries indexForInsertingObject:entry sortedUsingBlock:^(id a, id b) {
                        RSSEntry *entry1 = (RSSEntry *) a;
                        RSSEntry *entry2 = (RSSEntry *) b;
                        return [entry1.articleDate compare:entry2.articleDate];
                    }];
                    
                    [_allEntries insertObject:entry atIndex:insertIdx];
                    [self.RSSUITableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:insertIdx inSection:0]]  withRowAnimation:UITableViewRowAnimationRight];
                    
                }
                
            }];
            
        }        
    }];
    
    refreshFlag = 1;
    [ProgressHUD dismiss];
}

- (void) requestFailed:(ASIHTTPRequest *)request{
    NSError *error = [request error];
    NSLog(@"Error: %@", error);
    
    [ProgressHUD dismiss];
}

- (void)parseFeed:(GDataXMLElement *)rootElement entries:(NSMutableArray *)entries {
    if ([rootElement.name compare:@"rss"] == NSOrderedSame) {
        [self parseRss:rootElement entries:entries];
    } else if ([rootElement.name compare:@"feed"] == NSOrderedSame) {
        [self parseAtom:rootElement entries:entries];
    } else {
        NSLog(@"Unsupported root element: %@", rootElement.name);
    }
}


- (void)parseRss:(GDataXMLElement *)rootElement entries:(NSMutableArray *)entries {
    
    NSArray *channels = [rootElement elementsForName:@"channel"];
    for (GDataXMLElement *channel in channels) {
        
        NSString *blogTitle = [channel valueForChild:@"title"];
        
        NSArray *items = [channel elementsForName:@"item"];
        for (GDataXMLElement *item in items) {
            
            NSString *articleTitle = [item valueForChild:@"title"];
            NSString *articleUrl = [item valueForChild:@"link"];
            NSString *articleDateString = [item valueForChild:@"pubDate"];
            //            NSDate *articleDate = nil;
            NSDate *articleDate = [NSDate dateFromInternetDateTimeString:articleDateString formatHint:DateFormatHintRFC822];
            
            RSSEntry *entry = [[RSSEntry alloc] initWithBlogTitle:blogTitle
                                                     articleTitle:articleTitle
                                                       articleUrl:articleUrl
                                                      articleDate:articleDate];
            [entries addObject:entry];
            
        }
    }
    
}

- (void)parseAtom:(GDataXMLElement *)rootElement entries:(NSMutableArray *)entries {
    
    NSString *blogTitle = [rootElement valueForChild:@"title"];
    
    NSArray *items = [rootElement elementsForName:@"entry"];
    for (GDataXMLElement *item in items) {
        
        NSString *articleTitle = [item valueForChild:@"title"];
        NSString *articleUrl = nil;
        NSArray *links = [item elementsForName:@"link"];
        for(GDataXMLElement *link in links) {
            NSString *rel = [[link attributeForName:@"rel"] stringValue];
            NSString *type = [[link attributeForName:@"type"] stringValue];
            if ([rel compare:@"alternate"] == NSOrderedSame &&
                [type compare:@"text/html"] == NSOrderedSame) {
                articleUrl = [[link attributeForName:@"href"] stringValue];
            }
        }
        
        NSString *articleDateString = [item valueForChild:@"updated"];
        //        NSDate *articleDate = nil;
        NSDate *articleDate = [NSDate dateFromInternetDateTimeString:articleDateString formatHint:DateFormatHintRFC3339];
        
        RSSEntry *entry = [[RSSEntry alloc] initWithBlogTitle:blogTitle
                                                 articleTitle:articleTitle
                                                   articleUrl:articleUrl
                                                  articleDate:articleDate];
        [entries addObject:entry];
        
    }
    
}

#pragma UITableView

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_allEntries count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    //--- delete all uiviews in cell-----
    NSArray *viewsToRemove = [cell.contentView subviews];
    for (UIView *v in viewsToRemove){
        [v removeFromSuperview];
    }
    //-----------------------------------
    
    RSSEntry *entry = [_allEntries objectAtIndex:indexPath.row];
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    NSString *articleDateString = [dateFormatter stringFromDate:entry.articleDate];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(72, 14 , self.categoryScrollView.bounds.size.width - 130, 20)];
    titleLabel.text = entry.articleTitle;
    titleLabel.font =[UIFont fontWithName:@"Helvetica Light" size:16.0];
    titleLabel.textColor = [UIColor darkGrayColor];
    
    [cell.contentView addSubview:titleLabel];
    
//    cell.textLabel.text = entry.articleTitle;
//    cell.textLabel.frame = CGRectMake(cell.textLabel.frame.origin.x, cell.textLabel.frame.origin.y, cell.textLabel.bounds.size.width - 100, cell.textLabel.bounds.size.height);
    
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(72, 36 , self.categoryScrollView.bounds.size.width - 130, 40)];
//    detailLabel.text = [NSString stringWithFormat:@"%@ - %@", articleDateString, entry.blogTitle];
    detailLabel.text = [NSString stringWithFormat:@"%@", entry.blogTitle];
    detailLabel.font =[UIFont fontWithName:@"Helvetica Light" size:13.0];
    detailLabel.textColor = [UIColor grayColor];
    detailLabel.numberOfLines = 0;
    detailLabel.lineBreakMode = UILineBreakModeWordWrap;
    
    [cell.contentView addSubview:detailLabel];

    
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", articleDateString, entry.blogTitle];
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    cell.selectionStyle = NO;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // Get Current  Hour
    [formatter setDateFormat:@"h"];
    NSString *currentHourString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:entry.articleDate]];
    
    // Get Current  Minutes
    [formatter setDateFormat:@"mm"];
    NSString *currentMinutesString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:entry.articleDate]];
    
    // Get Current  AM PM
    [formatter setDateFormat:@"a"];
    NSString *currentTimeAMPMString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:entry.articleDate]];
    if ([currentTimeAMPMString isEqualToString:@"AM"])
        currentTimeAMPMString = @"am";
    else
        currentTimeAMPMString = @"pm";

    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.categoryScrollView.bounds.size.width - 55, 22, 30, 20)];
    timeLabel.text = [NSString stringWithFormat:@"%@:%@ %@", currentHourString, currentMinutesString, currentTimeAMPMString];
    timeLabel.font =[UIFont fontWithName:@"Helvetica Light" size:12.0];
    timeLabel.textColor = [UIColor lightGrayColor];
    
    [timeLabel sizeToFit];
    [cell.contentView addSubview:timeLabel];
    cell.imageView.image = [UIImage imageNamed:@"img_Line.png"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (_contentWebViewController == nil) {
//        self.contentWebViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
//    }
    RSSEntry *entry = [_allEntries objectAtIndex:indexPath.row];
//    _contentWebViewController.entry = entry;
//    [self.navigationController pushViewController:_contentWebViewController animated:TRUE];
    
    
    ///Open Safari
    NSURL *url = [[NSURL alloc] initWithString:entry.articleUrl];
    [[UIApplication sharedApplication] openURL:url];
}

@end
