//
//  ViewController.m
//  HttpRequestSample
//
//  Created by Leo on 2/10/15.
//  Copyright (c) 2015 Perfectidea Inc. All rights reserved.
//

#import "ViewController.h"
#import "RequestManager.h"

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
    [[RequestManager defaultManager] requestWith:[NSURL URLWithString:@"<put your url here>"] param:@{} httpMethod:kGetMethod usePostBody:NO completion:^(PFRequestTag tag, NSData *responseData){
        
        //do your job
        
    } falure:^(PFRequestTag tag, NSError *error){
    
        //fail to make request
    }];
}

@end
