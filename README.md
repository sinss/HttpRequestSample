# HttpRequestSample
Less complex , easier to integrate

#Purpose

 -  If your wanna make a simple http request.
 -  Support block , make your code clearly

#How to use 

```objective-c
#import "LCRequestManager.h"

[[LCRequestManager defaultManager] requestWith:[NSURL URLWithString:@"<put your url here>"] param:@{} httpMethod:kGetMethod usePostBody:NO completion:^(PFRequestTag tag, NSData *responseData){
        
        //do your job
        
    } falure:^(PFRequestTag tag, NSError *error){
    
        //fail to make request
    }];
```
  - Put your parameters in params as a NSDictionary
