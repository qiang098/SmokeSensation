//
//  MMPickerView.h
//  库啦啦
//
//  Created by Mr.yang on 2018/4/2.
//  Copyright © 2018年 Mr.yang. All rights reserved.
//

#import "MMPopupView.h"

typedef void(^IndexBlock)(NSInteger index);

@interface MMPickerView : MMPopupView

@property (nonatomic, copy)IndexBlock indexBlock;
@property (nonatomic, strong) UIPickerView *picker;
@property (nonatomic, strong) NSArray *array;

-(void)setSelect:(NSInteger)select;

@end
