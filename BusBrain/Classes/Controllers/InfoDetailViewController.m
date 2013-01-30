//
//  InfoDetailViewController.m
//  TrainBrain
//
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import "InfoDetailViewController.h"
#import "Info.h"
#import "BusBrainAppDelegate.h"

@implementation InfoDetailViewController

@synthesize infos, webView, selectedRow;

- (void) viewWillAppear:(BOOL)animated {
  BusBrainAppDelegate *app = (BusBrainAppDelegate *)[[UIApplication sharedApplication] delegate];
  [app saveAnalytics:@"InfoDetailView"];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadInfo:(NSString *)endpoint {
  if (![endpoint isEqualToString:@"hiawatha"] && ![endpoint isEqualToString:@"northstar"]) {
    NSLog(@"invalid data, caller should only ask for hiawatha or northstar");
    
  } else {
    
    NSString *url = [NSString stringWithFormat:@"/info/%@", endpoint];
    [Info infoDetailURLEndpoint:url parameters:nil block:^(NSArray *data) {
      self.infos = data;
      [self loadHTML];
    }];
    
  }
}

-(void) loadHTML {  
  
  if ([self.infos count] > 0) {
    Info *info = (Info *)[self.infos objectAtIndex:0];
    [self.webView loadHTMLString:info.detail baseURL:nil];
  }
  
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_app.png"]];
  self.navigationController.navigationBar.tintColor = [UIColor blackColor];
  self.infos = [[NSArray alloc] init];
  
  [self loadInfo:self.selectedRow];
  
  self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, 260)];
  self.webView.delegate = self;
  
  [self.webView setOpaque:NO];
  self.view = self.webView;
  
  if ([selectedRow isEqual: @"northstar"]) {
    self.title = @"Northstar Commuter Rail";
  } else if ([selectedRow isEqual: @"hiawatha"]) {
    self.title = @"Hiawatha Light Rail";
  }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
