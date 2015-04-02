//
//  NoteViewModel.h
//  Ash_AWord
//
//  Created by xmfish on 15/4/1.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import "BaseViewModel.h"
typedef enum {
    Order_by_Time = 0,
    Order_by_Good = 1,
}Order_by;

@interface Text_Image : MTLModel<MTLJSONSerializing>
@property (nonatomic, strong)NSString* content;
@property (nonatomic, strong)NSString* createTime;
@property (nonatomic, strong)NSURL* imageUrl;
@property (nonatomic, strong)NSString* ownerId;
@property (nonatomic, assign)BOOL hasPraised;
@property (nonatomic, assign)NSInteger praiseCount;
@property (nonatomic, assign)NSInteger messageId;
@end
@interface NoteViewModel : BaseViewModel

@property (nonatomic, strong)NSArray* text_imagesArr;
+(PropertyEntity*)requireWithOrder_by:(Order_by)order_by withPage:(NSInteger)page withPage_size:(NSInteger)page_size;
@end
