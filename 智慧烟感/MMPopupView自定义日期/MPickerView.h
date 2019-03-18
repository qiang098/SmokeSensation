//
//  MMPickerView.h
//  库啦啦
//
//  Created by Mr.yang on 2018/4/2.
//  Copyright © 2018年 Mr.yang. All rights reserved.
//

#import "MMPopupView.h"

typedef void(^StringBlock)(NSString *string, NSInteger row1, NSInteger row2);

@interface MPickerView : MMPopupView

@property (nonatomic, copy)StringBlock stringBlock;
@property (nonatomic, strong) UIPickerView *picker;

-(void)setSelect:(NSInteger)row1 :(NSInteger)row2;

@end
