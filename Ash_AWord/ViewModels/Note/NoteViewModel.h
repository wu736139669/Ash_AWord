//
//  NoteViewModel.h
//  Ash_AWord
//
//  Created by xmfish on 15/4/1.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import "BaseViewModel.h"


@interface Text_Image : MTLModel<MTLJSONSerializing>
@property (nonatomic, strong)NSString* content;
@property (nonatomic, strong)NSNumber* createTime;
@property (nonatomic, strong)NSURL* imageUrl;
@property (nonatomic, strong)NSURL* ownerFigureurl;
@property (nonatomic, strong)NSString* ownerName;
@property (nonatomic, strong)NSNumber* imageWidth;
@property (nonatomic, strong)NSNumber* imageHeight;
@property (nonatomic, strong)NSString* ownerId;
@property (nonatomic, assign)BOOL hasPraised;
@property (nonatomic, assign)BOOL hasShared;
@property (nonatomic, assign)NSInteger shareCount;
@property (nonatomic, assign)NSInteger praiseCount;
@property (nonatomic, assign)NSInteger messageId;
@property (nonatomic, assign)NSInteger commentCount;
@end
@interface NoteViewModel : BaseViewModel

@property (nonatomic, strong)NSArray* text_imagesArr;
@property (nonatomic, strong)Text_Image* text_image;

+(PropertyEntity*)requireWithOrder_by:(Order_by)order_by withPage:(NSInteger)page withPage_size:(NSInteger)page_size withType:(NSInteger)type; //type 0 查看全部，1关注
+(PropertyEntity*)requireMyWithOrder_by:(Order_by)order_by withPage:(NSInteger)page withPage_size:(NSInteger)page_size;
+(PropertyEntity*)requireOhterWithOrder_by:(Order_by)order_by withPage:(NSInteger)page withPage_size:(NSInteger)page_size withOtherId:(NSString*)otherid;

+(PropertyEntity*)requireNoteWithRecordId:(NSInteger)recordId;

+(PropertyEntity*)requirePraiseWithRecordId:(NSInteger)recordId;
+(PropertyEntity*)requireShareWithRecordId:(NSInteger)recordId;

+(PropertyEntity*)requireDelWithRecordId:(NSInteger)recordId;




@end
