//
//  BaseRequest.m
//  Pin-Here-Leo
//
//  Created by leo.chang on 1/2/15.
//  Copyright (c) 2015 Good-idea Consulgint Inc. All rights reserved.
//

#import "LCBaseRequest.h"
#import <UIKit/UIKit.h>

@implementation LCBaseRequest

- (instancetype)initWithUrl:(NSURL *)url param:(NSDictionary *)dict timeout:(NSTimeInterval)timeout httpMethod:(NSString *)method userPostBody:(BOOL)usePostBody
{
    self = [self initWithUrl:url param:dict timeout:timeout httpMethod:method userPostBody:usePostBody tag:LCRequestTagDefault];
    if (self)
    {
        
    }
    return self;
    
}

- (instancetype)initWithUrl:(NSURL*)url param:(NSDictionary*)dict timeout:(NSTimeInterval)timeout httpMethod:(NSString *)method userPostBody:(BOOL)usePostBody tag:(LCRequestTag)t
{
    self = [super init];
    if (self)
    {
        tag = t;
        self.params = dict;
        self.userPostBody = usePostBody;
        self.timeout = timeout;
        self.method = method;
        if (!usePostBody)
        {
            self.url = [self convertParamWithUrl:url];
        }
        else
        {
            self.url = url;
        }
        [self createRequest];
    }
    return self;
}

- (void)startInQueue:(NSOperationQueue *)queue
{
    //開始執行
    _excuting = YES;
    _conn = [[NSURLConnection alloc] initWithRequest:self.request delegate:self startImmediately:YES];
    
    [_conn setDelegateQueue:queue];
}

- (void)start
{
    [super start];
    [self.conn start];
}

- (void)finish
{
    [_conn cancel];
    _delegate = nil;
    _completion = nil;
    _failure = nil;
}

- (void)dealloc
{
    NSLog(@"dealloc");
}

- (void)createRequest
{
    self.request = [NSMutableURLRequest requestWithURL:_url];
    
    [self.request setTimeoutInterval:_timeout];
    [self.request setHTTPMethod:_method];
    [self generateRequestHeader];
    //使用Post Body
    if (self.userPostBody)
    {
        NSString *param = [self generateParams];
        NSData *data = [param dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        [self.request setHTTPBody:data];
        [self.request setValue:[NSString stringWithFormat:@"%li",[data length]] forHTTPHeaderField:@"Content-Length"];
    }
}

- (void)generateRequestHeader
{
    UIDevice *device = [UIDevice currentDevice];
    [self.request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField: @"Content-Type"];
    [self.request addValue:appVersion forHTTPHeaderField:kAppVersion];
    [self.request addValue:device.model forHTTPHeaderField:kAppModel];
    [self.request addValue:device.systemVersion forHTTPHeaderField:kSysVersion];
}

- (NSString*)generateParams
{
    NSArray *allKeys = self.params.allKeys;
    NSMutableString *string = [NSMutableString string];
    for (NSString *key in allKeys)
    {
        [string appendFormat:@"%@=%@", key, self.params[key]];
        if (![key isEqualToString:[allKeys lastObject]])
        {
            [string appendFormat:@"&"];
        }
    }
    return string;
}

- (NSURL*)convertParamWithUrl:(NSURL*)url
{
    NSMutableString *newUrl = [NSMutableString stringWithString:url.absoluteString];
    if (self.params)
    {
        [newUrl appendFormat:@"?"];
        [newUrl appendString:[self generateParams]];
    }
    return [NSURL URLWithString:newUrl];
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    NSLog(@"challenge : %@", challenge);
    if ([challenge previousFailureCount] > 0)
    {
        // maybe failure
        self.failure(tag, self.responseCode, [NSError errorWithDomain:@"" code:LCStatusSSLAuthenticationError userInfo:@{NSLocalizedDescriptionKey:@"SSL authentication fail"}]);
        
        /*
         If request fail , notify!
         */
        if ([self.delegate respondsToSelector:@selector(requestDidFail:)])
        {
            [self.delegate requestDidFail:self];
        }
        _excuting = NO;
    }
    else
    {
        
        NSURLCredential *credential = [NSURLCredential credentialWithUser:@"username"
                                                                 password:@"password"
                                                              persistence:NSURLCredentialPersistenceForSession];
        [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.responseData = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    _excuting = NO;
    if (self.failure)
    {
        self.failure(tag, self.responseCode, error);
    }
    
    /*
     If request fail , notify!
     */
    if ([self.delegate respondsToSelector:@selector(requestDidFail:)])
    {
        [self.delegate requestDidFail:self];
    }
    
    [self finish];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    _excuting = NO;
    if (self.completion)
    {
        self.completion(tag, self.responseCode, self.responseData);
    }
    
    /*
     If request finish , notify!
     */
    if ([self.delegate respondsToSelector:@selector(requestDidFinish:)])
    {
        [self.delegate requestDidFinish:self];
    }
    
    [self finish];
}



@end
