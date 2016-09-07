//
//  SearchViewController.m
//  Newsflash
//
//  Created by Ireneo Decano on 15/3/15.
//  Copyright (c) 2015 Ireneo Decano. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setLayout];
    
    self.lblComment.textColor = [UIColor darkGrayColor];
    self.lblComment.font =[UIFont fontWithName:@"Helvetica Light" size:28.0];

}

- (void) setLayout{
    self.lblComment.textColor = [UIColor darkGrayColor];
    self.lblComment.font =[UIFont fontWithName:@"Helvetica Light" size:28.0];
    
    self.navigationUIView.layer.masksToBounds = NO;
//    self.navigationUIView.layer.cornerRadius = 5;
    self.navigationUIView.layer.shadowOffset = CGSizeMake(2, 3);
    self.navigationUIView.layer.shadowRadius = 2;
    self.navigationUIView.layer.shadowOpacity = 0.1;
    
    self.navigationUIView.layer.borderColor = [[UIColor lightTextColor] CGColor];
    self.navigationUIView.layer.borderWidth = 2;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)pressBackButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)pressSearchButton:(id)sender {
    self.lblComment.text = @"   Results for 'apple'";
    
//    NSString *apiURL = @"http://cloud.feedly.com/v3/stream/contents?streamId=feed%2Fhttp%3A%2F%2Fwww.readwriteweb.com%2Frss.xml&count=20";
//    NSURL *url = [NSURL URLWithString:apiURL];
//    NSLog(@"url : %@",url);
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    NSString *postString = [NSString stringWithFormat: @"username=%@&password=%@",email,password];
//    NSLog(@"postString : %@",postString);
//    NSData *postData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
//    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
//    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
//    [request setHTTPMethod:@"POST"];
//    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//    [request setHTTPBody:postData];
//    
//    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//    
//    if( theConnection )
//    {
//        webData= [NSMutableData data];
//    }
//    else
//    {
//        NSLog(@"theConnection is NULL");
//        
//    }

}

- (IBAction)pressCancelButton:(id)sender {
    
    self.lblComment.text = @"   Subscribed Sources";
}
@end
