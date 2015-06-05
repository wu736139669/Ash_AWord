//
//  CommentViewModel.h
//  Ash_AWord
//
//  Created by xmfish on 15/6/5.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import "BaseViewModel.h"

@interface CommentInfoViewModel : BaseViewModel
@property (nonatomic, strong) NSString *commentId;
@property (nonatomic, strong) NSString *ownerId;
@property (nonatomic, strong) NSString *ownerFigureurl;
@property (nonatomic, strong) NSString *ownerName;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *createTime;
@end
@interface CommentViewModel : BaseViewModel

@property (nonatomic, strong)NSArray* commentInfoArr;

+(PropertyEntity*)requireAddCommentWithReconrdId:(NSInteger)recordId withContent:(NSString*)content;

+(PropertyEntity*)requireLoadCommentWithRecordId:(NSInteger)recordId withPage:(NSInteger)page withPage_size:(NSInteger)page_size;
@end
