//
//  LJSegmentedControl.m
//  LJSegmentedDemo
//
//  Created by liujun on 2018/5/10.
//  Copyright © 2018年 liujun. All rights reserved.
//

#import "LJSegmentedControl.h"

#define TOP_MARGIN 2
#define KEY_WINDOW [UIApplication sharedApplication].windows.firstObject

@interface LJSegmentedControl ()

@property (nonatomic, readwrite) NSMutableArray<UIButton *> *itemButtons;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *sizeLabel;
@property (nonatomic, strong) UIButton *selectedButton;
@property (nonatomic, strong) UIView *indicatorView;
@property (nonatomic, strong) LJFloatingView *floatingView;
@property (nonatomic, readwrite) LJFloatingView *reuseFloatingView;
@property (nonatomic, strong) UIControl *floatingBackgroudView;
@property (nonatomic, strong) NSArray<LJSegmentedItemAttributes *> *itemAttributes;
@property (nonatomic, assign) NSInteger index;

@end

@implementation LJSegmentedControl

#pragma mark - 懒加载

- (NSMutableArray<UIButton *> *)itemButtons {
    if (!_itemButtons) {
        _itemButtons = [[NSMutableArray alloc] init];
    }
    return _itemButtons;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIView alloc] init];
    }
    return _indicatorView;
}

- (UILabel *)sizeLabel {
    if (!_sizeLabel) {
        _sizeLabel = [[UILabel alloc] init];
    }
    return _sizeLabel;
}

- (NSInteger)selectedIndex {
    return self.selectedButton.tag;
}

- (UIControl *)floatingBackgroudView {
    if (!_floatingBackgroudView) {
        _floatingBackgroudView = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [_floatingBackgroudView addTarget:self action:@selector(clickFloatingBackgroudView:) forControlEvents:UIControlEventTouchUpInside];
        _floatingBackgroudView.alpha = 0;
    }
    return _floatingBackgroudView;
}

#pragma mark - setter方法

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setItems:(NSArray<LJSegmentedItem *> *)items {
    _items = items;
    
    for (UIButton *button in self.itemButtons) {
        [button removeFromSuperview];
    }
    [self.itemButtons removeAllObjects];
    [self.scrollView removeFromSuperview];

    for (NSInteger i = 0; i < items.count; i++) {
        LJSegmentedItem *item = items[i];
        UIButton *button = [[UIButton alloc] init];
        button.tag = i;
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:item.title forState:UIControlStateNormal];
        [button setTitle:item.selectedTitle ? item.selectedTitle : item.title forState:UIControlStateSelected];
        [button setImage:[UIImage imageNamed:item.imageName] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:item.selectedImageName] forState:UIControlStateSelected];
        button.titleEdgeInsets = item.titleEdgeInsets;
        button.imageEdgeInsets = item.imageEdgeInsets;
        [self.scrollView addSubview:button];
        [self.itemButtons addObject:button];
    }
    [self.scrollView addSubview:self.indicatorView];
    [self addSubview:self.scrollView];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (selectedIndex < self.itemButtons.count && selectedIndex >= 0) {
        [self setNeedsLayout];
        [self layoutIfNeeded];
        [self clickButton:self.itemButtons[selectedIndex]];
    }
}

- (void)setItemBackgroudColor:(UIColor *)itemBackgroudColor {
    _itemBackgroudColor = itemBackgroudColor;
    
    for (UIButton *button in self.itemButtons) {
        if (button.selected) {
            button.backgroundColor = itemBackgroudColor;
        }
    }
}

- (void)setSelectedItemBackgroudColor:(UIColor *)selectedItemBackgroudColor {
    _selectedItemBackgroudColor = selectedItemBackgroudColor;
    
    for (UIButton *button in self.itemButtons) {
        if (button.selected) {
            button.backgroundColor = selectedItemBackgroudColor;
        }
    }
}

- (void)setTitleFontSize:(CGFloat)titleFontSize {
    _titleFontSize = titleFontSize;
    
    for (UIButton *button in self.itemButtons) {
        if (!button.selected) {
            button.titleLabel.font = [UIFont systemFontOfSize:titleFontSize];
        }
    }
}

- (void)setSelectedTitleFontSize:(CGFloat)selectedTitleFontSize {
    _selectedTitleFontSize = selectedTitleFontSize;
    
    for (UIButton *button in self.itemButtons) {
        if (button.selected) {
            button.titleLabel.font = [UIFont systemFontOfSize:selectedTitleFontSize];
        }
    }
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    
    for (UIButton *button in self.itemButtons) {
        if (!button.selected) {
            [button setTitleColor:titleColor forState:UIControlStateNormal];
        }
    }
}

- (void)setSelectedTitleColor:(UIColor *)selectedTitleColor {
    _selectedTitleColor = selectedTitleColor;
    
    for (UIButton *button in self.itemButtons) {
        if (button.selected) {
            [button setTitleColor:selectedTitleColor forState:UIControlStateNormal];
        }
    }
}

- (void)setShowIndicator:(BOOL)showIndicator {
    _showIndicator = showIndicator;
    
    if (showIndicator) {
        self.indicatorView.hidden = NO;
    } else {
        self.indicatorView.hidden = YES;
    }
}

- (void)setIndicatorHeight:(CGFloat)indicatorHeight {
    _indicatorHeight = indicatorHeight;

    if (self.selectedButton) {
        [self setIndicatorAppearEffectWithButton:self.selectedButton];
    }
}

- (void)setIndicatorPosition:(LJSegmentedControlIndicatorPosition)indicatorPosition {
    _indicatorPosition = indicatorPosition;
    
    if (self.selectedButton) {
        [self setIndicatorAppearEffectWithButton:self.selectedButton];
    }
}

- (void)setSelectedIndicatorColor:(UIColor *)selectedIndicatorColor {
    _selectedIndicatorColor = selectedIndicatorColor;
    
    self.indicatorView.backgroundColor = selectedIndicatorColor;
}

- (void)setSegmentWidthStyle:(LJSegmentedControlSegmentWidthStyle)segmentWidthStyle {
    _segmentWidthStyle = segmentWidthStyle;
    
    if (self.selectedButton) {
        [self setIndicatorAppearEffectWithButton:self.selectedButton];
    }
}

- (void)setScaleSize:(BOOL)scaleSize {
    _scaleSize = scaleSize;
    
    if (self.selectedButton) {
        [self setIndicatorAppearEffectWithButton:self.selectedButton];
    }
}

#pragma mark - 初始化方法

- (instancetype)initWithSegmentedItmes:(NSArray<LJSegmentedItem *> *)items {
    if (self = [super init]) {
        self.items = items;
        [self setDefaultParameter];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        [self setDefaultParameter];
    }
    return self;
}

- (void)setDefaultParameter {
    self.showIndicator = NO;
    self.scaleSize = NO;
    self.itemBackgroudColor = [UIColor lightGrayColor];
    self.selectedItemBackgroudColor = [UIColor whiteColor];
    self.titleFontSize = 14;
    self.selectedTitleFontSize = 14;
    self.titleColor = [UIColor blackColor];
    self.selectedTitleColor = [UIColor grayColor];
    self.selectedIndicatorColor = [UIColor grayColor];
    self.indicatorHeight = 2;
    self.indicatorPosition = LJSegmentedControlIndicatorPositionBottom;
    self.segmentWidthStyle = LJSegmentedControlSegmentWidthStyleFixed;
}

#pragma mark - 布局方法

- (void)layoutSubviews {
    [super layoutSubviews];

    self.scrollView.frame = self.bounds;
    NSArray<LJSegmentedItemAttributes *> *itemAttributes = nil;
    if ([self.delegate respondsToSelector:@selector(segmentedControl:segmentedItemAttributesForItems:)]) {
        itemAttributes = [self.delegate segmentedControl:self segmentedItemAttributesForItems:self.items];
    }
    CGFloat itemTotalWidth = 0;
    if (itemAttributes && itemAttributes.count > 0) {
        for (NSInteger i = 0; i < self.itemButtons.count; i++) {
            UIButton *button = self.itemButtons[i];
            button.frame = itemAttributes[i].itemFrame;
        }
        itemTotalWidth = CGRectGetMaxX(self.itemButtons.lastObject.frame);
        self.scrollView.contentSize = CGSizeMake(itemTotalWidth, self.bounds.size.height);
    } else {
        CGFloat width = self.bounds.size.width / self.itemButtons.count;
        for (UIButton *button in self.itemButtons) {
            button.frame = CGRectMake(width * [self.itemButtons indexOfObject:button], 0, width, self.bounds.size.height);
        }
    }
    self.itemAttributes = itemAttributes;
}

- (void)didMoveToWindow {
    [super didMoveToWindow];

    [self.floatingBackgroudView removeFromSuperview];
    [KEY_WINDOW addSubview:self.floatingBackgroudView];
}

#pragma mark - 按钮点击事件

- (void)clickButton:(UIButton *)button {
    if (self.selectedButton == button) {
        return;
    }
    self.index = self.selectedButton.tag;
    self.selectedButton.selected = NO;
    button.selected = YES;
    self.selectedButton = button;
    
    for (UIButton *itemButton in self.itemButtons) {
        if (itemButton.selected) {
            itemButton.titleLabel.font = [UIFont systemFontOfSize:self.selectedTitleFontSize];
            [itemButton setTitleColor:self.selectedTitleColor forState:UIControlStateNormal];
            itemButton.backgroundColor = self.selectedItemBackgroudColor;
        } else if (!itemButton.selected) {
            itemButton.titleLabel.font = [UIFont systemFontOfSize:self.titleFontSize];
            [itemButton setTitleColor:self.titleColor forState:UIControlStateNormal];
            itemButton.backgroundColor = self.itemBackgroudColor;
        }
    }
//    [self setIndicatorAppearEffectWithButton:button];
    
    if ([self.delegate respondsToSelector:@selector(segmentedControl:floatingViewAtIndex:)]) {
        [self.floatingView removeFromSuperview];
        [self.floatingBackgroudView removeFromSuperview];
        
        self.floatingView = [self.delegate segmentedControl:self floatingViewAtIndex:button.tag];
        if (!self.reuseFloatingView) {
            self.reuseFloatingView = self.floatingView;
        }
        
        CGRect frame = self.floatingView.frame;
        CGPoint point = [self convertPoint:button.center toView:KEY_WINDOW];
        self.floatingView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        switch (self.floatingView.alignment) {
            case LJFloatingViewAlignmentLeft: {
                self.floatingView.frame = CGRectMake(point.x - button.bounds.size.width / 2, button.bounds.size.height / 2 + TOP_MARGIN + point.y, frame.size.width, frame.size.height);
            }
                break;
            case LJFloatingViewAlignmentCenter: {
                point = CGPointMake(point.x, point.y + button.bounds.size.height / 2 + TOP_MARGIN + self.floatingView.bounds.size.height / 2);
                self.floatingView.center = point;
            }
                break;
            case LJFloatingViewAlignmentRigLJ: {
                self.floatingView.frame = CGRectMake(point.x + button.bounds.size.width / 2 - frame.size.width, button.bounds.size.height / 2 + TOP_MARGIN + point.y, frame.size.width, frame.size.height);
            }
                break;
            default:
                break;
        }
        
        [self.floatingBackgroudView addSubview:self.floatingView];
        [KEY_WINDOW addSubview:self.floatingBackgroudView];

        if (self.floatingView) {
            [UIView animateWithDuration:0.25 animations:^{
                self.floatingBackgroudView.alpha = 1;
            }];
        } else {
            [UIView animateWithDuration:0.25 animations:^{
                self.floatingBackgroudView.alpha = 0;
            }];
        }
    }
    
    [self setIndicatorAppearEffectWithButton:button];
    
    if ([self.delegate respondsToSelector:@selector(segmentedControl:clickItemButton:)]) {
        [self.delegate segmentedControl:self clickItemButton:button];
    }
}

- (void)clickFloatingBackgroudView:(UIControl *)floatingBackgroudView {
    [UIView animateWithDuration:0.25 animations:^{
        self.floatingBackgroudView.alpha = 0;
    }];
    [self clickButton:self.itemButtons[self.index]];
}

#pragma mark - 根据属性设置处理按钮相关呈现形式

- (void)setIndicatorAppearEffectWithButton:(UIButton *)button {
    CGFloat indicatorY = 0;
    if (self.indicatorPosition == LJSegmentedControlIndicatorPositionBottom) {
        indicatorY = self.bounds.size.height - self.indicatorHeight;
    } else if (self.indicatorPosition == LJSegmentedControlIndicatorPositionTop) {
        indicatorY = 0;
    }
    
    CGFloat indicatorWidth = 0;
    if (self.segmentWidthStyle == LJSegmentedControlSegmentWidthStyleFixed) {
        indicatorWidth = button.bounds.size.width;
    } else if (self.segmentWidthStyle == LJSegmentedControlSegmentWidthStyleDynamic) {
        self.sizeLabel.text = button.titleLabel.text;
        self.sizeLabel.font = [UIFont systemFontOfSize:self.selectedTitleFontSize];
        [self.sizeLabel sizeToFit];
        indicatorWidth = self.sizeLabel.bounds.size.width;
    }

    [UIView animateWithDuration:0.25 animations:^{
        self.indicatorView.frame = CGRectMake(0, indicatorY, indicatorWidth, self.indicatorHeight);
        self.indicatorView.center = CGPointMake(button.center.x, self.indicatorView.center.y);
    }];
    if (self.itemAttributes && self.itemAttributes.count > 0) {
        CGFloat offsetX = button.center.x - self.bounds.size.width * 0.5;
        if (offsetX < 0) {
            offsetX = 0;
        }
        if (offsetX > self.scrollView.contentSize.width - self.bounds.size.width) {
            offsetX = self.scrollView.contentSize.width - self.bounds.size.width;
        }
        [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
        CGRect frame = self.floatingView.frame;
        self.floatingView.frame = CGRectMake(frame.origin.x - offsetX, frame.origin.y, frame.size.width, frame.size.height);
    }
    
    if (self.scaleSize) {
        [UIView animateWithDuration:0.25 animations:^{
            for (UIButton *itemButton in self.itemButtons) {
                if (button != itemButton) {
                    itemButton.transform = CGAffineTransformIdentity;
                }
            }
            button.transform = CGAffineTransformMakeScale(1.3, 1.3);
        }];
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }
}

@end


////// item
@implementation LJSegmentedItem

@end

////// itemAttributes
@implementation LJSegmentedItemAttributes

@end

