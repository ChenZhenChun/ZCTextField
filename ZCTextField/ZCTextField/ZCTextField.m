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
        _tipView = [[TextFieldTipView alloc]init];
        _tipView.delegate = self;
    }
    return _tipView;
}

- (void)configTipViewFrame {
    //因为用autolayout加载的控件没有frame的概念，
    //如果没有让autolayout算好位置的话拿出来的frame都是xib上写的值。所以必须加上layoutIfNeeded
    [self layoutIfNeeded];
    [[self superview] layoutIfNeeded];
    [self setNeedsDisplay];
    //获取到textFiel在控制器上的坐标
    CGPoint textFieldPoint = [[self superview]convertPoint:self.frame.origin toView:self.currentController.view];
    self.tipView.frame = CGRectMake(textFieldPoint.x, textFieldPoint.y+self.frame.size.height, self.frame.size.width,tipViewH);
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
        self.tipView.data = [data mutableCopy];
        if (self.tipView.isRemoved) {
            [self configTipViewFrame];
            [self.tipView showTipView:self.currentController.view];
        }
    }else{
        [_tipView hiddenTipView];
    }
}

- (void)hiddenTipView {
    [self.tipView hiddenTipView];
}

@end
