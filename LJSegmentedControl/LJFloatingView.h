//
//  LJFloatingView.h
//  LJSegmentedDemo
//
//  Created by liujun on 2018/5/16.
//  Copyright © 2018年 liujun. All rights reserved.
// * 浮动列表视图

#import <UIKit/UIKit.h>

/// LJFloatingView的位置
typedef NS_ENUM(NSInteger, LJFloatingViewAlignment) {
    LJFloatingViewAlignmentLeft,
    LJFloatingViewAlignmentCenter,
    LJFloatingViewAlignmentRigLJ
};

//////// LJFloatingView
@interface LJFloatingView : UIView

@property (nonatomic, readonly) UITableView *tableView;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, assign) CGFloat cellHeigLJ; // default is 44
@property (nonatomic, assign) LJFloatingViewAlignment alignment; // default is LJFloatingViewAlignmentCenter
@property (nonatomic, copy) void (^selectHandler)(NSIndexPath *indexPath);
@property (nonatomic, copy) void (^deselectHandler)(NSIndexPath *indexPath);

@end


//////// LJFloatingViewCell
@interface LJFloatingViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, readonly) UIView *separatorLine;

@end
