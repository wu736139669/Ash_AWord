//
//  ReportViewController.h
//  Ash_AWord
//
//  Created by xmfish on 15/4/25.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPlaceHolderTextView.h"
typedef enum {
    Msg_Note = 1,
    Msg_Message = 2,
}MsgType;
@interface ReportViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *reportNameLabel;
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *reportContentTextView;

@property (strong, nonatomic)NSString* authorName;
@property (assign, nonatomic)NSInteger msgId;
@property (assign, nonatomic)MsgType msgType;
@end
