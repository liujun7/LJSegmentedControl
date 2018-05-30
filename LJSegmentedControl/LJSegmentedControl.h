//
//  LJSegmentedControl.h
//  LJSegmentedDemo
//
//  Created by liujun on 2018/5/10.
//  Copyright © 2018年 liujun. All rights reserved.
// * 分段控件

#import <UIKit/UIKit.h>
#import "LJFloatingView.h"

typedef NS_ENUM(NSUInteger, LJSegmentedControlIndicatorPosition) {
    LJSegmentedControlIndicatorPositionTop,
    LJSegmentedControlIndicatorPositionBottom
};

typedef NS_ENUM(NSInteger, LJSegmentedControlSegmentWidthStyle) {
    LJSegmentedControlSegmentWidthStyleFixed,
    LJSegmentedControlSegmentWidthStyleDynamic
};

////////// LJSegmentedItem
@interface LJSegmentedItem : NSObject

@property (nonatomic, copy, nonnull) NSString *title; // default is nil
@property (nonatomic, copy, nullable) NSString *selectedTitle; // default is nil
@property (nonatomic, assign) UIEdgeInsets titleEdgeInsets; // default is UIEdgeInsetsZero
@property (nonatomic, copy, nullable) NSString *imageName; // default is nil
@property (nonatomic, copy, nullable) NSString *selectedImageName; // default is nil
@property(nonatomic, assign) UIEdgeInsets imageEdgeInsets; // default is UIEdgeInsetsZero

@end


////////// LJSegmentedItemAttributes
@interface LJSegmentedItemAttributes : NSObject

@property (nonatomic, assign) CGRect itemFrame; // default is CGRectZero

@end


////////////////////////////////////////////////////////////////

////////// LJSegmentedControlDelegate

@class LJSegmentedControl;
@protocol LJSegmentedControlDelegate <NSObject>

@optional
- (NSArray<LJSegmentedItemAttributes *> * _Nullable)segmentedControl:(LJSegmentedControl *)segmentedControl segmentedItemAttributesForItems:(NSArray<LJSegmentedItem *> *)items;
- (void)segmentedControl:(LJSegmentedControl *)segmentedControl clickItemButton:(UIButton *)itemButton;
- (LJFloatingView *)segmentedControl:(LJSegmentedControl *)segmentedControl floatingViewAtIndex:(NSInteger)index;

@end

////////// LJSegmentedControl
@interface LJSegmentedControl : UIView

- (instancetype)initWithSegmentedItmes:(NSArray<LJSegmentedItem *> * _Nonnull)items;

@property (nonatomic, weak) id<LJSegmentedControlDelegate> delegate; // default is nil
@property (nonatomic, strong, nonnull) NSArray<LJSegmentedItem *> *items; // default is nil
@property (nonatomic, readonly) NSMutableArray<UIButton *> *itemButtons;
@property (nonatomic, strong, nullable) UIColor *itemBackgroudColor; // default is ligLJGrayColor
@property (nonatomic, strong, nullable) UIColor *selectedItemBackgroudColor; // default is whiteColor
@property (nonatomic, strong, nullable) UIColor *titleColor; // default is blackColor
@property (nonatomic, strong, nullable) UIColor *selectedTitleColor; // default is grayColor
@property (nonatomic, assign) CGFloat titleFontSize; // default is 14
@property (nonatomic, assign) CGFloat selectedTitleFontSize; // default is 14
@property (nonatomic, assign) NSInteger selectedIndex; // you need external settings
@property (nonatomic, assign) BOOL showIndicator; // default is NO
@property (nonatomic, strong, nullable) UIColor *selectedIndicatorColor; // default is grayColor
@property (nonatomic, assign) CGFloat indicatorHeight; // default is 2
@property (nonatomic, assign) LJSegmentedControlIndicatorPosition indicatorPosition; // default is LJSegmentedControlIndicatorPositionBottom
@property (nonatomic, assign) LJSegmentedControlSegmentWidthStyle segmentWidthStyle; // default is LJSegmentedControlSegmentWidthStyleFixed
@property (nonatomic, assign) BOOL scaleSize; // default is NO
@property (nonatomic, readonly) LJFloatingView *reuseFloatingView;

@end

