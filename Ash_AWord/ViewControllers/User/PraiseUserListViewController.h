//
//  PraiseUserListViewController.h
//  Ash_AWord
//
//  Created by xmfish on 15/6/5.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import "BaseRefreshViewController.h"
typedef enum {
    UserList_Praise_Type = 1,      //点赞列表
    UserList_Attention_Type = 2,   //关注列表
    UserList_Fans_Type = 3,        //粉丝列表
}UserList_Type;

@interface PraiseUserListViewController : BaseRefreshViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(assign, nonatomic)NSInteger recordId;
@property(strong, nonatomic)NSString* targetId;
@property(strong, nonatomic)NSArray* firstPraiseUserArr;

@property(assign, nonatomic)UserList_Type userListType;
@property(assign, nonatomic)CommentType commentType;
@end
