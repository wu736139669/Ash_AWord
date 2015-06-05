//
//  NoteCommentViewModel.h
//  Ash_AWord
//
//  Created by xmfish on 15/6/2.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import "BaseViewModel.h"

@interface NoteCommentInfoViewModel : BaseViewModel
@property (nonatomic, strong)NSString* commentId;
@property (nonatomic, strong)NSString* ownerId;
@property (nonatomic, strong) NSURL *ownerFigureUrl;
@property (nonatomic, strong) NSString *ownerName;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *createTime;
@end
@interface NoteCommentViewModel : BaseViewModel

@property (nonatomic, strong)NSArray* commentArr;

+(PropertyEntity*)requireLoadWithPage:(NSInteger)page withPage_size:(NSInteger)page_size withRecordId:(NSString*)recordId;

+(PropertyEntity*)requireAddwithRecordId:(NSString*)recordId withContent:(NSString*)content;
@end
