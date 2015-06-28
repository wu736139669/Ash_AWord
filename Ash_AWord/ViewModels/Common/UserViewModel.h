//
//  UserInfoViewModel.h
//  Ash_AWord
//
//  Created by xmfish on 15/6/4.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import "BaseViewModel.h"

@interface UserInfoViewModel : BaseViewModel
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *figureurl;
@property (nonatomic, assign) NSInteger userType;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString *signature;
@property (nonatomic, assign) NSInteger followCount;
@property (nonatomic, assign) NSInteger followerCount;
@property (nonatomic, assign) BOOL isNew;


@end

@interface UserViewModel : BaseViewModel
@property (nonatomic, strong) NSArray *userInfoArr;
@property (nonatomic, strong) NSArray *friendUserArr;
@property (nonatomic, strong)UserInfoViewModel* userInfo;
@property (nonatomic, strong) NSArray *userBaseInfoArr;
@property (nonatomic, assign)NSInteger relation;//与当前用户关系。0：没有关系，1：已关注此人，2：已被此人关注，3：相互关注（如果是获取自己的个人信息，可以无视该项0.0）
+(PropertyEntity*)requireLoadPraiseUserWithRecordId:(NSInteger)recordId withPage:(NSInteger)page withPage_size:(NSInteger)page_size withType:(CommentType)type;

+(PropertyEntity*)requireUserInfoWithTargetUid:(NSString*)targetUid;

+(PropertyEntity*)requireLoadUserListWithTargetUid:(NSString*)targetUid withType:(NSInteger)isAttention withPage:(NSInteger)page withPage_size:(NSInteger)page_size; // 1是关注列表,2是粉丝列表
+(PropertyEntity*)requireAttentionWithTargetUid:(NSString*)targetUid withIsAttention:(BOOL)isAttention;

+(PropertyEntity*)requireUserListWithUid:(NSArray*)uidArr;

+(PropertyEntity*)requireNewUserList;
@end
