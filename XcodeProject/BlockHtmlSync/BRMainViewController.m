//
//  BRMainViewController.m
//  BlockHtmlSync
//
//  Created by Shingo Hashimoto on 13/07/12.
//  Copyright (c) 2013年 Shingo Hashimoto. All rights reserved.
//

#import "BRMainViewController.h"
#import "BlockHtmlSync.h"

@interface BRMainViewController ()

@end

@implementation BRMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_resultField release];
    [_urlField release];
    [super dealloc];
}

- (IBAction)tapSend:(id)sender {
    
    self.resultField.text = @"";
    
    
    //  通信オブジェクトを初期化
    BlockHtmlSync *sync = [[[BlockHtmlSync alloc]
                     initWithUrl:[NSURL URLWithString:self.urlField.text]
                     ] autorelease];
    
    //  結果タイプを設定
    [sync setResultType:BRBlockHtmlSyncResultTypeString];
    
    //  onSuccess
    sync.successBlock = ^(id result){
        self.resultField.text = result;
    };
    
    //  onError
    sync.errorBlock = ^(NSError* error){
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@""
                                                         message:error.description
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles: nil] autorelease];
        [alert show];
    };
    
    //  onCancel
    sync.cancelBlock = ^(void){
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@""
                                                         message:@"canceled"
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles: nil] autorelease];
        [alert show];
    };
    
    //  パラメータを追加
    [sync addParam:@"test" key:@"mode"];
    
    //  doLoad
    [sync getHTMLGetData];
    //[sync getHTMLPostData];
    
    //  ifCancel
    [sync cancelBlock];
}

@end
