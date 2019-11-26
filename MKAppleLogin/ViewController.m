//
//  ViewController.m
//  MKAppleLogin
//
//  Created by ligeng on 2019/11/26.
//  Copyright © 2019 flyWhite. All rights reserved.
//

#import "ViewController.h"
#import <AuthenticationServices/AuthenticationServices.h>
#import "MKAppleLogin.h"
@interface ViewController ()<MKAppleLoginDelegate>
 @property (nonatomic,strong) MKAppleLogin *appLoginManger;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.appLoginManger = [[MKAppleLogin alloc]init];
    self.appLoginManger.delegate = self;
        if (@available(iOS 13.0,*)){
            ASAuthorizationAppleIDButton *appleIDBtn = [ASAuthorizationAppleIDButton buttonWithType:ASAuthorizationAppleIDButtonTypeDefault style:ASAuthorizationAppleIDButtonStyleBlack];
//            appleIDBtn.layer.cornerRadius = 24;
//            appleIDBtn.clipsToBounds = YES;
            appleIDBtn.frame = CGRectMake(30, self.view.bounds.size.height/2-200, 200, 48);
            [appleIDBtn addTarget:self action:@selector(handleAuthorizationAppleIDButtonPress) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:appleIDBtn];

           
            
        }
    
}

#pragma mark ---<appleLoginDelegate>
-(void)authorizationdidSuccessWithUserID:(NSString *)userID andAuthorizationCode:(NSData *)Acode andIdentityToken:(NSData *)token andEmail:(NSString *)email{
    
    
    //网络请求验证
    NSLog(@"userID=%@---Acode=%@----token=%@----email=%@",userID,[[NSString alloc]initWithData:Acode encoding:NSUTF8StringEncoding],[[NSString alloc]initWithData:token encoding:NSUTF8StringEncoding],email);
    
    
    
    
}
-(void)authorizationdidSuccessWithErrorCode:(NSString *)errorCode{
    NSLog(@"%@",errorCode);
}


-(void)handleAuthorizationAppleIDButtonPress{
     [_appLoginManger authorizationAppleIDButtonPressWithSuperView:self.view];
}

@end
