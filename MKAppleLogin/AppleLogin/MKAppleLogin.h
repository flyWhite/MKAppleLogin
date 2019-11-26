//
//  MKAppleLogin.h
//  MoKaVideo
//
//  Created by ligeng on 2019/11/5.
//  Copyright © 2019 hzdykj. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UIView;
NS_ASSUME_NONNULL_BEGIN

@protocol MKAppleLoginDelegate <NSObject>

-(void)authorizationdidSuccessWithUserID:(NSString*)userID andAuthorizationCode:(NSData*)Acode andIdentityToken:(NSData*)token andEmail:(NSString*)email;
-(void)authorizationdidSuccessWithErrorCode:(NSString*)errorCode;


@end

@interface MKAppleLogin : NSObject

@property (nonatomic,weak) id<MKAppleLoginDelegate>delegate;

-(void)authorizationAppleIDButtonPressWithSuperView:(UIView*)superView;

@end

NS_ASSUME_NONNULL_END
