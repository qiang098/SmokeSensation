//
//  MMPickerView.m
//  库啦啦
//
//  Created by Mr.yang on 2018/4/2.
//  Copyright © 2018年 Mr.yang. All rights reserved.
//

#import "MPickerView.h"
#import "MMPopupDefine.h"
#import "MMPopupCategory.h"
#import <Masonry/Masonry.h>

@interface MPickerView() <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIButton *btnCancel;
@property (nonatomic, strong) UIButton *btnConfirm;
@property (nonatomic, strong) NSArray *array;
@property (nonatomic, strong) NSArray *letter;

@end

@implementation MPickerView

- (instancetype)init
{
    self = [super init];
    
    if ( self )
    {
        self.array = @[@"京", @"津",@"翼",@"鲁",@"晋",@"蒙",@"辽",@"吉",@"黑",@"沪",@"苏", @"浙",@"皖",@"闽",@"赣",@"豫",@"鄂",@"湘",@"粤",@"桂",@"渝", @"川",@"贵",@"云",@"藏",@"陕",@"甘",@"青",@"琼", @"新",@"宁",@"港",@"澳",@"台"];
        self.letter = @[@"A", @"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K", @"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T", @"U",@"V",@"W",@"X",@"Y",@"Z"];
        
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
    return 2;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.array.count;
    }else{
        return self.letter.count;
    }
}

-(NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *string = [[NSString alloc] init];
    if (component == 0) {
        string = self.array[row];
    }else{
        string = self.letter[row];
    }
    NSInteger length = string.length;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString: string];
    [attributedString addAttribute:NSForegroundColorAttributeName value:MMHexColor(0xEBB826FF) range:NSMakeRange(0,  length)];
    return attributedString;
}

-(void)setSelect:(NSInteger)row1 :(NSInteger)row2 {
    [self.picker selectRow: row1 inComponent:0 animated: YES];
    [self.picker selectRow: row2 inComponent:1 animated: YES];
}

- (void)confirmClick {
    if (self.stringBlock) {
        NSString *string1 = self.array[[self.picker selectedRowInComponent:0]];
        NSString *string2 = self.letter[[self.picker selectedRowInComponent:1]];
        NSString *string = [[NSString alloc] initWithFormat:@"%@%@", string1, string2];
        self.stringBlock(string, [self.picker selectedRowInComponent:0], [self.picker selectedRowInComponent:1]);
    }
    [self actionHide];
}

- (void)actionHide
{
    [self hide];
}

@end
