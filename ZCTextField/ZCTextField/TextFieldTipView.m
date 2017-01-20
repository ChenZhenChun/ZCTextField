//
//  TextFiledTipView.m
//  MH_DOCTOR
//
//  Created by aiyoyou on 15/12/15.
//  Copyright © 2015年 Xiamen Zoenet Tech Co.,Ltd. All rights reserved.
//

#import "TextFieldTipView.h"
#define icon_deleteH 15

@interface TextFieldTipView()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic) BOOL removeFlag;
@end

@implementation TextFieldTipView


#pragma mark -initProperty

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderColor = [[UIColor grayColor] CGColor];
        self.layer.borderWidth = 0.3;
        self.layer.cornerRadius = 3;
        self.removeFlag = YES;
        [self addSubview:self.tableView];
    }
    return self;
}

-(void)setData:(NSMutableArray *)data {
    _data = data;
    [self.tableView reloadData];
}

- (void)showTipView:(UIView *)view {
    self.removeFlag = NO;
    [view addSubview:self];
}


- (void)hiddenTipView {
    self.removeFlag = YES;
    [self removeFromSuperview];
}

- (BOOL)isRemoved {
    return self.removeFlag;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width,self.frame.size.height) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
    }
    return _tableView;
}


#pragma mark -UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}


#pragma mark -UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [NSString stringWithFormat:@"ayyTextFieldCell%ld",(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];

        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.frame = CGRectMake(self.frame.size.width-deleIconBtnW,0.0,deleIconBtnW,tipCellH);
        deleteBtn.backgroundColor = [UIColor clearColor];
        deleteBtn.tag = indexPath.row;
        [deleteBtn addTarget:self action:@selector(clearUserName:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((deleIconBtnW-icon_deleteH)/2.0+5, (tipCellH-icon_deleteH)/2.0, icon_deleteH, icon_deleteH)];
        imageView.image = [UIImage imageNamed:@"icon_delete"];
        imageView.backgroundColor = [UIColor clearColor];
        [deleteBtn addSubview:imageView];
        
        [cell.contentView addSubview:deleteBtn];
    }
    cell.textLabel.textColor = [UIColor grayColor];
    cell.textLabel.text =self.data[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return tipCellH;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(TextFieldTipView:didSelectRowAtIndexPath:)]) {
        [self.delegate TextFieldTipView:self didSelectRowAtIndexPath:indexPath];
    }
}


#pragma mark -Action

- (void)clearUserName:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didSelectClearButtonWithData:)]) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
        id key = self.data[sender.tag];
        [self.data removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        if (self.data.count == 0) {
            [self hiddenTipView];
        }
        [self.delegate didSelectClearButtonWithData:key];
        [self.tableView reloadData];
    }
}

@end
