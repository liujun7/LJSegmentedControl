//
//  LJFloatingView.m
//  LJSegmentedDemo
//
//  Created by liujun on 2018/5/16.
//  Copyright © 2018年 liujun. All rights reserved.
//

#import "LJFloatingView.h"

static NSString *cellID = @"LJFloatingViewCell";

@interface LJFloatingView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, readwrite) UITableView *tableView;

@end

@implementation LJFloatingView

#pragma mark - 懒加载

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[LJFloatingViewCell class] forCellReuseIdentifier:cellID];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
        [self addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark - setter方法

- (void)setTitles:(NSArray *)titles {
    _titles = titles;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    [self.tableView reloadData];
}

- (void)setCellHeigLJ:(CGFloat)cellHeigLJ {
    _cellHeigLJ = cellHeigLJ;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
   
    [self.tableView reloadData];
}

#pragma mark - 初始化方法

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.cellHeigLJ = 44;
        self.alignment = LJFloatingViewAlignmentCenter;
    }
    return self;
}

#pragma mark - 布局方法

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.tableView.frame = self.tableView.frame = CGRectMake(0, 0, self.bounds.size.width, self.cellHeigLJ * self.titles.count);
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LJFloatingViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.titleLabel.text = self.titles[indexPath.row];
    if (indexPath.row == self.titles.count - 1) {
        cell.separatorLine.hidden = YES;
    } else {
        cell.separatorLine.hidden = NO;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.deselectHandler) {
        self.deselectHandler(indexPath);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectHandler) {
        self.selectHandler(indexPath);
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.superview.alpha = 0;
    }];
}

@end


@interface LJFloatingViewCell ()

@property (nonatomic, readwrite) UIView *separatorLine;

@end

@implementation LJFloatingViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.titleLabel];
        self.separatorLine = [[UIView alloc] init];
        self.separatorLine.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
        [self.contentView addSubview:self.separatorLine];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.titleLabel.frame = self.bounds;
    self.separatorLine.frame = CGRectMake(0, self.bounds.size.height - 0.5, self.bounds.size.width, 0.5);
}

@end
