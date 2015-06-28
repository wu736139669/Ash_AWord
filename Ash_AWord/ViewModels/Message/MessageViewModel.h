//
//  MessageViewModel.h
//  Ash_AWord
//
//  Created by xmfish on 15/4/13.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import "BaseViewModel.h"

@interface Text_Voice : MTLModel<MTLJSONSerializing>
@property (nonatomic, strong)NSString* content;
@property (nonatomic, strong)NSNumber* createTime;
@property (nonatomic, strong)NSURL* voiceUrl;
@property (nonatomic, strong)NSURL* ownerFigureurl;
@property (nonatomic, strong)NSString* ownerName;
@property (nonatomic, strong)NSNumber* voiceLength;
//@property (nonatomic, strong)NSNumber* imageHeight;
@property (nonatomic, strong)NSString* ownerId;
@property (nonatomic, assign)BOOL hasPraised;
@property (nonatomic, assign)BOOL hasShared;
@property (nonatomic, assign)NSInteger shareCount;
@property (nonatomic, assign)NSInteger praiseCount;
@property (nonatomic, assign)NSInteger messageId;
@property (nonatomic, assign)NSInteger commentCount;

@end

@interface MessageViewModel : BaseViewModel

@property (nonatomic, strong)NSArray* text_voicesArr;

@property (nonatomic, strong)Text_Voice *text_voice;


+(PropertyEntity*)requireWithOrder_by:(Order_by)order_by withPage:(NSInteger)page withPage_size:(NSInteger)page_size withType:(NSInteger)type; //type 0 查看全部，1关注;
+(PropertyEntity*)requireMyWithOrder_by:(Order_by)order_by withPage:(NSInteger)page withPage_size:(NSInteger)page_size;
+(PropertyEntity*)requireOhterWithOrder_by:(Order_by)order_by withPage:(NSInteger)page withPage_size:(NSInteger)page_size withOtherId:(NSString*)otherid;


+(PropertyEntity*)requirePraiseWithRecordId:(NSInteger)recordId;
+(PropertyEntity*)requireShareWithRecordId:(NSInteger)recordId;

+(PropertyEntity*)requireDelWithRecordId:(NSInteger)recordId;

+(PropertyEntity*)requireMessageWithRecordId:(NSInteger)recordId;

@end
