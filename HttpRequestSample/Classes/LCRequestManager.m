//
//  RequestManager.m
//  Pin-Here-Leo
//
//  Created by leo.chang on 1/2/15.
//  Copyright (c) 2015 Good-idea Consulgint Inc. All rights reserved.
//

#import "LCRequestManager.h"

@interface LCRequestManager()

@property (nonatomic, strong) NSOperationQueue *communicationQueue;

@end

@implementation LCRequestManager

+ (LCRequestManager*)defaultManager
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[LCRequestManager alloc] init];
    });
    
    return instance;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _communicationQueue = [[NSOperationQueue alloc] init];
        _communicationQueue.qualityOfService = NSQualityOfServiceUserInteractive;
    }
    return self;
}

#pragma mark Shared method
- (LCBaseRequest*)fetchRequestWithUrl:(NSURL*)url params:(NSDictionary *)param httpMethod:(NSString *)method usePostBody:(BOOL)userPostBody completion:(completionBlock)completion falure:(falureBlock)falure
{
    LCBaseRequest *request = [[LCBaseRequest alloc] initWithUrl:url param:param timeout:baseTimeout httpMethod:method userPostBody:userPostBody];
    [request setCompletion:completion];
    [request setFailure:falure];
    request.qualityOfService = NSQualityOfServiceBackground;
    [request startInQueue:self.communicationQueue];
    
    return request;
}

- (LCBaseRequest*)fetchRequestWith:(NSURL*)url param:(NSDictionary*)param httpMethod:(NSString *)method usePostBody:(BOOL)userPostBody completion:(completionBlock)completion falure:(falureBlock)falure
{
    return [self fetchRequestWithUrl:url params:param httpMethod:method usePostBody:userPostBody completion:completion falure:falure];
}

@end
