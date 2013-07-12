//
//  BlockHtmlSync.h
//  soe_dev
//
//  Created by Shingo Hashimoto on 12/10/01.
//  Copyright (c) 2012年 Shingo Hashimoto. All rights reserved.
//

#import <Foundation/Foundation.h>

enum BlockHtmlSyncResultType {
    BlockHtmlSyncResultTypeData = 0,
    BlockHtmlSyncResultTypeString = 1
    };

/**
 通信実行
 */
@interface BlockHtmlSync : NSObject{
    NSURL *_url;
    int _resultType;
    
    NSMutableData *_async_data;
    NSURLConnection *_connection;
    
    int data_type;
    NSMutableDictionary *_param;
}
/// @name Properties

@property (nonatomic, readwrite) int resultType;
@property (nonatomic, copy) void (^successBlock)(id);
@property (nonatomic, copy) void (^errorBlock)(id);
@property (nonatomic, copy) void (^cancelBlock)(void);


/// @name Public Methods

-(id)initWithUrl:(NSURL*)url;

-(void)addParam:(NSString*)value key:(NSString*)key;
-(void)getHTMLGetData;
-(void)getHTMLPostData;
-(void)cancelLoading;

@end
