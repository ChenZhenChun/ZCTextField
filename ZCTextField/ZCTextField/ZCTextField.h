//
//  ZCTextField.h
//  AiyoyouDemo
//
//  Created by aiyoyou on 15/12/15.
//  Copyright © 2015年 aiyoyou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextFieldTipView.h"
@class ZCTextField;

@protocol ZCTextFieldDelegate <NSObject>
@optional
- (void)zcTextFieldWithTipView:(TextFieldTipView *)tipView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)zcDidSelectClearButtonWithData:(id)data;
@end

@interface ZCTextField : UITextField
/**
    ps:在设置数据源及代理之前必须将ZCTextField addSubview 到容器中
 */
@property (nonatomic,strong) NSMutableArray<NSString *> *data;
@property (nonatomic,assign) UIViewController<ZCTextFieldDelegate> *zcDelegate;//必须设置代理才能使用搜索功能,代理必须是控制器

- (void)hiddenTipView;
@end

/**
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self userNameField];
}

- (ZCTextField *)userNameField {
    if (!_userNameField) {
        _userNameField=[[ZCTextField alloc]initWithFrame:CGRectMake(20,3, 200, 30)];
        [self.view addSubview:_userNameField];
        _userNameField.placeholder=@"请输入手机号";
        _userNameField.layer.borderColor = [[UIColor grayColor] CGColor];
        _userNameField.layer.borderWidth = 0.7;
        _userNameField.data = self.tipViewData;
        _userNameField.zcDelegate = self;
        
    }
    return _userNameField;
}

- (NSMutableArray *)tipViewData {
    if (!_tipViewData) {
        _tipViewData = [@[@"15659720810",@"18965712135",@"13876567821"]mutableCopy];
    }
    return _tipViewData;
}


#pragma mark -TextFiledTipViewDelegate

- (void)zcTextFieldWithTipView:(TextFieldTipView *)tipView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _userNameField.text = tipView.data[indexPath.row];
}

- (void)zcDidSelectClearButtonWithData:(id)data {
    
}
 */
