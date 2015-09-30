//
//  ViewController.m
//  HttpRequestSample
//
//  Created by Leo on 2/10/15.
//  Copyright (c) 2015 Perfectidea Inc. All rights reserved.
//

#import "ViewController.h"
#import "LCRequestManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)go:(id)sender
{
    [[LCRequestManager defaultManager] fetchRequestWith:[NSURL URLWithString:@"<<url>>"] param:@{} httpMethod:kGetMethod usePostBody:NO completion:^(LCRequestTag tag, NSInteger statusCode, NSData *responseData){
        
        //do your job
        NSString *re = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSLog(@"result : %@", re);
        
    } falure:^(LCRequestTag tag, NSInteger statucCode, NSError *error){
    
        NSLog(@"fail : %@", error);
        //fail to make request
    }];
}

@end
