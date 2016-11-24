//
//  GUTabBarCollectionViewCell.m
//  GoEuro Test
//
//  Created by mohamed mohamed El Dehairy on 11/24/16.
//  Copyright © 2016 mohamed El Dehairy. All rights reserved.
//

#import "GUTabBarCollectionViewCell.h"

@interface GUTabBarCollectionViewCell ()

@end

@implementation GUTabBarCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    if((self = [super initWithFrame:frame])){
        [self setTranslatesAutoresizingMaskIntoConstraints:NO];
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_titleLabel];
        NSDictionary *viewsDict = NSDictionaryOfVariableBindings(_titleLabel);
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_titleLabel]-|" options:0 metrics:nil views:viewsDict]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_titleLabel]-|" options:0 metrics:nil views:viewsDict]];
    }
    return self;
}
@end
