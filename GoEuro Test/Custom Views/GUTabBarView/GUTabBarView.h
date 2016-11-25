//
//  GUTabBarView.h
//  GoEuro Test
//
//  Created by mohamed mohamed El Dehairy on 11/24/16.
//  Copyright © 2016 mohamed El Dehairy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GUTabBarViewItem.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^GUTabBarViewItemCallBack)(NSInteger itemIndex);

@interface GUTabBarView : UIView
-(instancetype)initWithItems:( NSArray<GUTabBarViewItem*>*)items frame:(CGRect)frame NS_DESIGNATED_INITIALIZER;
-(instancetype)init NS_UNAVAILABLE;
-(instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
@property(nonatomic,copy)GUTabBarViewItemCallBack tapCallBack;
@end

NS_ASSUME_NONNULL_END