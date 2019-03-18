//
//  MMDateView.h
//  MMPopupView
//
//  Created by Ralph Li on 9/7/15.
//  Copyright © 2015 LJC. All rights reserved.
//

#import "MMPopupView.h"

typedef void(^Block)(NSDate *date);

@interface MMDateView : MMPopupView

@property (nonatomic, copy)Block dateBlock;
@property (nonatomic, strong) UIDatePicker *datePicker;

@end
