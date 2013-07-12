//
//  BRSync.m
//  soe_dev
//
//  Created by Shingo Hashimoto on 12/10/01.
//  Copyright (c) 2012年 Shingo Hashimoto. All rights reserved.
//

#import "BlockHtmlSync.h"

@implementation BlockHtmlSync

#pragma mark - Life Cycles
/// @name Life Cycles


/**
 初期化
 @param url URL
 */
-(id)initWithUrl:(NSURL*)url{
    self = [super init];
    if (self) {
        _param = [[NSMutableDictionary alloc] initWithCapacity:0];
        _url = [url retain];
    }
    return self;
}

-(void)dealloc{
    [_param release];
    [_connection release];
    [_async_data release];
    [_url release];
    
    Block_release(_successBlock);
    Block_release(_errorBlock);
    Block_release(_cancelBlock);
    [super dealloc];
}


#pragma mark - Other Methods
/// @name Other Methods

/**
 パラメータ追加
 @param value 値
 @param key キー
 */
-(void)addParam:(NSString*)value key:(NSString*)key{
    [_param setObject:value forKey:key];
}


/**
 GET通信
 */
-(void)getHTMLGetData{
    
    NSURL *urlWithGet = [NSURL URLWithString:
                         [NSString stringWithFormat:@"%@%@",
                          _url.absoluteString,
                          [self makeParamaterStringWithPrefix:@"?"]]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlWithGet];
    
    [_connection release];
    _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

/**
 POST通信
 */
-(void)getHTMLPostData{
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:_url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[[self makeParamaterStringWithPrefix:nil] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [_connection release];
    _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}


/**
 通信キャンセル
 */
-(void)cancelLoading{
    if (_connection) {
        [_connection cancel];
    }

    if (self.cancelBlock){
        self.cancelBlock();
    }
}


#pragma mark - NSURLConnection Delegate
/// @name NSURLConnection Delegate

/**
 非同期通信 ヘッダーが返ってきた
 @param connection connection
 @param response response
 */
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
	// データを初期化
    [_async_data release];
	_async_data = [[NSMutableData alloc] initWithData:0];
}

/**
 非同期通信 ダウンロード中
 @param connection connection
 @param data 受信データ
 */
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
	// データを追加する
	[_async_data appendData:data];
}

/**
 非同期通信 エラー
 @param connection connection
 @param error Error
 */
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    if (self.errorBlock) {
        self.errorBlock(error);
    }
    
}

/**
 非同期通信 ダウンロード完了
 @param _connection connection
 */
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    id result = _async_data;
    
    if (_resultType == BlockHtmlSyncResultTypeString) {
        int enc_arr[] = {
            NSUTF8StringEncoding,			// UTF-8
            NSShiftJISStringEncoding,		// Shift_JIS
            NSJapaneseEUCStringEncoding,	// EUC-JP
            NSISO2022JPStringEncoding,		// JIS
            NSUnicodeStringEncoding,		// Unicode
            NSASCIIStringEncoding			// ASCII
        };
        NSString *data_str = nil;
        int max = sizeof(enc_arr) / sizeof(enc_arr[0]);
        for (int i=0; i<max; i++) {
            data_str = [
                        [NSString alloc]
                        initWithData : _async_data
                        encoding : enc_arr[i]
                        ];
            if (data_str!=nil) {
                break;
            }
        }
        result = data_str;
    }
    
    if(self.successBlock){
        self.successBlock(result);
    }
}



#pragma mark - Other
/// @name Other

/**
 パラメーターをテキストに変換
 @param prefix prefix
 */
-(NSString*)makeParamaterStringWithPrefix:(NSString*)prefix{
    
    NSMutableArray *arrParam = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    for (NSString *key in _param){
        NSString *val = [self convertGetParamsToString:[_param objectForKey:key]];
        [arrParam addObject:[NSString stringWithFormat:@"%@=%@",key, val]];
    }
    
    if (prefix) {
        return [NSString stringWithFormat:@"%@%@",prefix, [arrParam componentsJoinedByString:@"&"]];
    }
    return [arrParam componentsJoinedByString:@"&"];
}



/**
 HTMLエンコードする
 @param string 元のテキスト
 */
-(NSString*)convertGetParamsToString:(NSString*)string{
    
    NSString *escapedUrlString = (NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                     NULL,
                                                                                     (CFStringRef)string,
                                                                                     NULL,
                                                                                     (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                     kCFStringEncodingUTF8 );
    
    [escapedUrlString autorelease];
    return [NSString stringWithFormat:@"%@",escapedUrlString];
}

@end
