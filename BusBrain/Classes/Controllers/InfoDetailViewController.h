//
//  InfoDetailViewController.h
//  TrainBrain
//
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoDetailViewController : UIViewController<UIWebViewDelegate> {
  NSArray *infos;
  UIWebView *webView;
  NSString *selectedRow;
}

@property (nonatomic, strong) NSArray *infos;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSString *selectedRow;

- (void)loadInfo:(NSString *)endpoint;
-(void) loadHTML;

@end
