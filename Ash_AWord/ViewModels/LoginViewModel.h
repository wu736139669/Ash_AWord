//
//  LoginViewModel.h
//  Ash_AWord
//
//  Created by xmfish on 15/3/30.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import "BaseViewModel.h"

typedef enum {
    Note_Img_Type = 0,
    Message_Voice_Type = 1,
    Report_Note_Img_Type = 2,
    Report_Message_Voice_Type = 3,
}Msg_Type;
@interface LoginViewModel : BaseViewModel

@property (nonatomic, strong) NSString* uId; //用户id。
@property (nonatomic, strong) NSString* figureurl;
@property (nonatomic, strong) NSString* userName;

+ (PropertyEntity *)requireLoginWithOpenId:(NSString*)openId withName:(NSString*)name withGender:(NSString*)gender withFigureUrl:(NSString*)figureUrl;

//本地注册.
+ (PropertyEntity *)requireRegistWithUserName:(NSString*)userName withNickName:(NSString*)nickName withPassword:(NSString*)password withGender:(NSString*)gender withAvatar:(UIImage*)avatarImg;

//本地登录
+ (PropertyEntity*)requireLoginWithUserName:(NSString*)userName withPassWord:(NSString*)passWord;

//修改密码
+(PropertyEntity*)requireModifyPassWord:(NSString*)newPassword withOldPaaaWord:(NSString*)oldPassWord;

//修改信息
+(PropertyEntity*)requireModifyInfoWithNickName:(NSString*)nickName withGender:(NSString*)gender withAvatarImg:(UIImage*)avatarImg;

//举报
+(PropertyEntity*)requireReportWith:(Msg_Type)type withMsgId:(NSInteger)msgId withContent:(NSString*)content ;

+(PropertyEntity*)requireFeedbackWithContent:(NSString*)content;

@end
