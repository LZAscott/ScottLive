//
//  UITableView+EmptyPlaceholder.h
//  QQLive
//
//  Created by bopeng on 2017/7/7.
//  Copyright © 2017年 Scott. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ScottTableViewPlaceholderDelegate <NSObject>

@required
- (UIView *)makePlaceHolderView;
@optional
- (BOOL)enableScrollWhenPlaceHolderViewShowing;

@end

@interface UITableView (EmptyPlaceholder)

- (void)scott_reloadData;

@end
