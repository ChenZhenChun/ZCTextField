//
//  ZCTextField.m
//  AiyoyouDemo
//
//  Created by aiyoyou on 15/12/15.
//  Copyright © 2015年 aiyoyou. All rights reserved.
//

#import "ZCTextField.h"

@interface ZCTextField()<TextFieldTipViewDelegate>
@property (nonatomic,strong) TextFieldTipView *tipView;
@property (nonatomic,assign) UIViewController *currentController;
@end

@implementation ZCTextField


#pragma mark -initProperty

- (void)setData:(NSMutableArray *)data {
    _data = data;
    self.tipView.data = data;
}

- (void)setZcDelegate:(UIViewController<ZCTextFieldDelegate> *)zcDelegate {
    _zcDelegate = zcDelegate;
    [self addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventEditingChanged];
}

- (UIViewController *)currentController {
    return ((UIViewController *)self.zcDelegate);
}

- (TextFieldTipView *)tipView {
    if (!_tipView) {
        //因为用autolayout加载的控件没有frame的概念，
        //如果没有让autolayout算好位置的话拿出来的frame都是xib上写的值。所以必须加上layoutIfNeeded
        [self layoutIfNeeded];
        [[self superview] layoutIfNeeded];
        [self setNeedsDisplay];
        //获取到textFiel在控制器上的坐标
        CGPoint textFieldPoint = [[self superview]convertPoint:self.frame.origin toView:self.currentController.view];
        _tipView = [[TextFieldTipView alloc]initWithFrame:CGRectMake(textFieldPoint.x, textFieldPoint.y+self.frame.size.height, self.frame.size.width,tipViewH)];
        _tipView.delegate = self;
    }
    return _tipView;
}


#pragma mark -TextFiledTipViewDelegate

- (void)TextFieldTipView:(TextFieldTipView *)tipView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tipView hiddenTipView];
    if ([self.zcDelegate respondsToSelector:@selector(zcTextFieldWithTipView:didSelectRowAtIndexPath:)]) {
        [self.zcDelegate zcTextFieldWithTipView:tipView didSelectRowAtIndexPath:indexPath];
    }
}

- (void)didSelectClearButtonWithData:(id)data {
    if ([self.zcDelegate respondsToSelector:@selector(zcDidSelectClearButtonWithData:)]) {
        [self.zcDelegate zcDidSelectClearButtonWithData:data];
    }
}


#pragma mark -userNameFieldValueChangeAction

- (void)valueChange:(UITextField *)textField {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF BEGINSWITH[cd] %@ ",textField.text];
    NSArray *data = [self.data filteredArrayUsingPredicate:predicate];
    if (data.count != 0) {
        if (self.tipView.isRemoved) {
            [self.tipView showTipView:self.currentController.view];
        }
        self.tipView.data = [data mutableCopy];
    }else{
        [_tipView hiddenTipView];
    }
}

- (void)hiddenTipView {
    [self.tipView hiddenTipView];
}

@end
