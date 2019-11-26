//
//  MKAppleLogin.m
//  MoKaVideo
//
//  Created by ligeng on 2019/11/5.
//  Copyright © 2019 hzdykj. All rights reserved.
//

#import "MKAppleLogin.h"
#import <AuthenticationServices/AuthenticationServices.h>

@interface MKAppleLogin ()<ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding>
@property (nonatomic,strong) UIView *superView;

@end

@implementation MKAppleLogin



-(void)authorizationAppleIDButtonPressWithSuperView:(UIView *)superView{
    NSLog(@"////////");
    if (@available(iOS 13.0, *)) {
        self.superView = superView;
        // 基于用户的Apple ID授权用户，生成用户授权请求的一种机制
        ASAuthorizationAppleIDProvider *appleIDProvider = [[ASAuthorizationAppleIDProvider alloc] init];
        // 创建新的AppleID 授权请求
        ASAuthorizationAppleIDRequest *appleIDRequest = [appleIDProvider createRequest];
        // 在用户授权期间请求的联系信息
        appleIDRequest.requestedScopes = @[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail];
        // 由ASAuthorizationAppleIDProvider创建的授权请求 管理授权请求的控制器
        ASAuthorizationController *authorizationController = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[appleIDRequest]];
        // 设置授权控制器通知授权请求的成功与失败的代理
        authorizationController.delegate = self;
        // 设置提供 展示上下文的代理，在这个上下文中 系统可以展示授权界面给用户
        authorizationController.presentationContextProvider = self;
        // 在控制器初始化期间启动授权流
        [authorizationController performRequests];
    }
}

#pragma mark ---<ASAuthorizationControllerDelegate>
//@optional 授权成功地回调
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization API_AVAILABLE(ios(13.0)){
    NSLog(@"授权完成:::%@", authorization.credential);
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"%@", controller);
    NSLog(@"%@", authorization);
    
    if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
        ASAuthorizationAppleIDCredential *apple = (ASAuthorizationAppleIDCredential*)authorization.credential;
        ///将返回得到的user 存储起来
        NSString *userIdentifier = apple.user;
        NSPersonNameComponents *fullName = apple.fullName;
        NSString *email = apple.email;
        NSData *code = apple.authorizationCode;
        //用于后台像苹果服务器验证身份信息
        NSData *identityToken = apple.identityToken;
        NSLog(@"%@%@%@%@%@",userIdentifier,fullName,email,identityToken,code);
        if (_delegate&&[_delegate respondsToSelector:@selector(authorizationdidSuccessWithUserID:andAuthorizationCode:andIdentityToken:andEmail:)]) {
            [_delegate authorizationdidSuccessWithUserID:userIdentifier andAuthorizationCode:code andIdentityToken:identityToken andEmail:email];
        }
    }else if ([authorization.credential isKindOfClass:[ASPasswordCredential class]]){
         // Sign in using an existing iCloud Keychain credential.
        ASPasswordCredential *pass = (ASPasswordCredential*)authorization.credential;
        NSString *username = pass.user;
        NSString *passw = pass.password;
        
    }else{
         if (_delegate&&[_delegate respondsToSelector:@selector(authorizationdidSuccessWithErrorCode:)]) {
               [_delegate authorizationdidSuccessWithErrorCode:@"error"];
           }
    }
}
// 授权失败的回调
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error API_AVAILABLE(ios(13.0)){
    // Handle error.
    NSLog(@"Handle error：%@", error);
    NSString *errorMsg = @"error";
    switch (error.code) {
        case ASAuthorizationErrorCanceled:
            errorMsg = @"用户取消了授权请求";
            break;
        case ASAuthorizationErrorFailed:
            errorMsg = @"授权请求失败";
            break;
        case ASAuthorizationErrorInvalidResponse:
            errorMsg = @"授权请求响应无效";
            break;
        case ASAuthorizationErrorNotHandled:
            errorMsg = @"未能处理授权请求";
            break;
        case ASAuthorizationErrorUnknown:
            errorMsg = @"授权请求失败未知原因";
            break;
            
        default:
            break;
    }
    if (_delegate&&[_delegate respondsToSelector:@selector(authorizationdidSuccessWithErrorCode:)]) {
        [_delegate authorizationdidSuccessWithErrorCode:errorMsg];
    }
}

-(ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller API_AVAILABLE(ios(13.0)){
    return self.superView.window;
}


@end
