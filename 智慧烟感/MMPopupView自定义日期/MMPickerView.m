//
//  MMPickerView.m
//  库啦啦
//
//  Created by Mr.yang on 2018/4/2.
//  Copyright © 2018年 Mr.yang. All rights reserved.
//

#import "MMPickerView.h"
#import "MMPopupDefine.h"
#import "MMPopupCategory.h"
#import <Masonry/Masonry.h>

@interface MMPickerView() <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIButton *btnCancel;
@property (nonatomic, strong) UIButton *btnConfirm;

@end

@implementation MMPickerView

- (instancetype)init
{
    self = [super init];
    
    if ( self )
    {
        self.type = MMPopupTypeSheet;
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width);
            make.height.mas_equalTo(216+50);
        }];
        
        self.btnCancel = [UIButton mm_buttonWithTarget:self action:@selector(actionHide)];
        [self addSubview:self.btnCancel];
        [self.btnCancel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80, 50));
            make.left.top.equalTo(self);
        }];
        [self.btnCancel setTitle:@"取消" forState:UIControlStateNormal];
        [self.btnCancel setTitleColor:MMHexColor(0x999999FF) forState:UIControlStateNormal];
        
        
        self.btnConfirm = [UIButton mm_buttonWithTarget:self action:@selector(confirmClick)];
        [self addSubview:self.btnConfirm];
        [self.btnConfirm mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80, 50));
            make.right.top.equalTo(self);
        }];
        [self.btnConfirm setTitle:@"确定" forState:UIControlStateNormal];
        [self.btnConfirm setTitleColor:MMHexColor(0xE0A704FF) forState:UIControlStateNormal];
        
        self.picker = [UIPickerView new];
        self.picker.delegate = self;
        [self addSubview:self.picker];
        [self.picker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(50, 0, 0, 0));
        }];
    }
    
    return self;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.array.count;
}

//-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//    NSString *string = self.array[row];
//    return string;
//}

-(NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *string = self.array[row][@"carNumber"];
    NSInteger length = string.length;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString: string];
    [attributedString addAttribute:NSForegroundColorAttributeName value:MMHexColor(0xEBB826FF) range:NSMakeRange(0,  length)];
    return attributedString;
}

-(void)setSelect:(NSInteger)select {
    [self.picker selectRow: select inComponent:0 animated: YES];
}

- (void)confirmClick {
    if (self.indexBlock) {
        self.indexBlock([self.picker selectedRowInComponent:0]);
    }
    [self actionHide];
}

- (void)actionHide
{
    [self hide];
}

@end
