//
//  TextFiledTipView.h
//  MH_DOCTOR
//
//  Created by aiyoyou on 15/12/15.
//  Copyright © 2015年 Xiamen Zoenet Tech Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TextFieldTipView;
#define tipCellH 30
#define deleIconBtnW (tipCellH+15)
#define tipViewH (tipCellH*3)

@protocol TextFieldTipViewDelegate <NSObject>
@optional
- (void)TextFieldTipView:(TextFieldTipView *)tipView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)didSelectClearButtonWithData:(id)data;
@end

@interface TextFieldTipView : UIView
@property (nonatomic,strong) NSMutableArray *data;//对数据源赋值即可刷新列表(数据源结构写死，不设置数据源代理。)
@property (nonatomic,readonly) BOOL isRemoved;//TextFieldTipView是否已经被移除
@property (nonatomic,weak)  id<TextFieldTipViewDelegate> delegate;

- (void)showTipView:(UIView *)view;
- (void)hiddenTipView;
@end
