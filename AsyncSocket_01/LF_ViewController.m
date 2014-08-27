//
//  LF_ViewController.m
//  AsyncSocket_01
//
//  Created by Yoshihiro Natsui on 8/15/14.
//  Copyright (c) 2014 Yoshihiro Natsui. All rights reserved.
//

#import "LF_ViewController.h"


@interface LF_ViewController ()

@end

@implementation LF_ViewController{
    
    GCDAsyncSocket *asyncSocket;
    IBOutlet UITextField *tfMsg;
    IBOutlet UITextField *tfIp;
    NSString *hostIp;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

}


-(IBAction)sendBtnPushed:(id)sender{
    
    //TextFieldの文字列保持用
    NSString *tfText = tfMsg.text;
    NSLog(@"入力文字列:%@",tfText);
    //文字入力が無い場合には何もしない
    if (tfText.length == 0) {
        NSLog(@"入力文字がありません");
        return;
    }
    
    if (tfIp.text.length == 0) {
        NSLog(@"IPが未入力です");
        return;
    }
    
    asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError *error = nil;
    hostIp = tfIp.text;
    uint16_t port = 20000;
    //認証失敗
    if (![asyncSocket connectToHost:hostIp onPort:port withTimeout:5 error:&error]) {
        NSLog(@"Unable to connect to due to invalid configuration: %@",error);
    }
    //認証成功
    else{
        NSLog(@"接続中！");
        NSLog(@"Connecting to \"%@\" on port %hu", hostIp, port);
        
    }
    
    NSData *data = [tfText dataUsingEncoding:NSUTF8StringEncoding];
    [asyncSocket writeData:data withTimeout:5 tag:0];

    
}

-(void)dealloc{
    [asyncSocket setDelegate:nil];
    [asyncSocket disconnect];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - GCDAsyncSocketDelegate
-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    NSLog(@"接続に成功しました！");
    NSLog(@"Host:%@ Port:%hu", host, port);
    
}


-(void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    NSLog(@"書き込み完了！");
}

- (NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutReadWithTag:(long)tag
                 elapsed:(NSTimeInterval)elapsed
               bytesDone:(NSUInteger)length{
    NSLog(@"Timeout:%lu BytesDone:%lu",tag,(unsigned long)length);
    return -1;
}

- (NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutWriteWithTag:(long)tag
                 elapsed:(NSTimeInterval)elapsed
               bytesDone:(NSUInteger)length{
    NSLog(@"Timeout:%lu BytesDone:%lu",tag,(unsigned long)length);
    return -1;
}








#pragma mark - TextField Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)sender{
    [sender resignFirstResponder];
    return YES;
}

@end
