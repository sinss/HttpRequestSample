//
//  BaseRequest.h
//  Pin-Here-Leo
//
//  Created by leo.chang on 1/2/15.
//  Copyright (c) 2015 Good-idea Consulgint Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kAppVersion @"app-Version"
#define kAppModel @"app-model"
#define kSysVersion @"app-Version"
#define kUserAccount @"app-User"

#define kGetMethod @"GET"
#define kPostMethod @"POST"
#define kPutMethod @"PUT"

#define appVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

typedef NS_ENUM(NSInteger, LCStatus) {
    LCStatusSSLAuthenticationError = -31,
};

typedef NS_ENUM(NSUInteger, LCRequestTag)
{
    LCRequestTagDefault,
};

typedef void (^completionBlock) (LCRequestTag tag, NSInteger statusCode, NSData *responseData);
typedef void (^falureBlock) (LCRequestTag tag, NSInteger statusCode, NSError *error);

@protocol LCRequestDelegate;
@interface LCBaseRequest : NSOperation
{
    LCRequestTag tag;
}

@property (nonatomic, getter=isExcuting) BOOL excuting;
@property (nonatomic, assign) BOOL userPostBody;
@property (nonatomic, strong) NSURLConnection *conn;
@property (nonatomic, strong) NSMutableURLRequest *request;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, assign) NSTimeInterval timeout;
@property (nonatomic, strong) NSString *method;

@property (nonatomic, copy) completionBlock completion;
@property (nonatomic, copy) falureBlock failure;

@property (nonatomic, weak) id<LCRequestDelegate>delegate;

@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, assign) NSInteger responseCode;

- (instancetype)initWithUrl:(NSURL*)url param:(NSDictionary*)dict timeout:(NSTimeInterval)timeout httpMethod:(NSString*)method userPostBody:(BOOL)usePostBody;

- (instancetype)initWithUrl:(NSURL*)url param:(NSDictionary*)dict timeout:(NSTimeInterval)timeout httpMethod:(NSString*)method userPostBody:(BOOL)usePostBody tag:(LCRequestTag)tag;


- (void)startInQueue:(NSOperationQueue*)queue;
- (void)finish;

@end

@protocol LCRequestDelegate <NSObject>

- (void)requestDidFinish:(LCBaseRequest*)request;
- (void)requestDidFail:(LCBaseRequest*)request;

@end