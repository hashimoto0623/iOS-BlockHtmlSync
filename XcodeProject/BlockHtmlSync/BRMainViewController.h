//
//  BRMainViewController.h
//  BlockHtmlSync
//
//  Created by Shingo Hashimoto on 13/07/12.
//  Copyright (c) 2013年 Shingo Hashimoto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BRMainViewController : UIViewController
@property (retain, nonatomic) IBOutlet UITextView *resultField;
@property (retain, nonatomic) IBOutlet UITextField *urlField;
- (IBAction)tapSend:(id)sender;

@end
