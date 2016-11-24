//
//  GUTabBarView.m
//  GoEuro Test
//
//  Created by mohamed mohamed El Dehairy on 11/24/16.
//  Copyright © 2016 mohamed El Dehairy. All rights reserved.
//

#import "GUTabBarView.h"
#import "GUTabBarCollectionViewCell.h"

static NSString *const kGUTabBarCellcId = @"tabCell";

@interface GUTabBarView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
-(instancetype)initWithCoder:(NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSArray<GUTabBarViewItem*>* items;
@property(nonatomic,strong)UIView *selectorView;
@end

@implementation GUTabBarView
-(instancetype)initWithItems:(NSArray<GUTabBarViewItem*> *)items frame:(CGRect)frame{
    if((self = [super initWithFrame:frame])){
        _items = items;
        [self initialize];
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    return [super initWithCoder:aDecoder];
}
-(void)initialize{
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.layoutMargins = UIEdgeInsetsZero;
    self.backgroundColor = [UIColor colorWithRed:(16.0f/255.0f) green:(76.0f/255.0f) blue:(146.0f/255.0f) alpha:1.0];
    // Collection View
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        [_collectionView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_collectionView registerClass:[GUTabBarCollectionViewCell class] forCellWithReuseIdentifier:kGUTabBarCellcId];
        [self addSubview:_collectionView];
    }
    
    // Selector View
    {
        _selectorView = [UIView new];
        _selectorView.backgroundColor = [UIColor colorWithRed:(249.0f/255.0f) green:(137.0f/255.0f) blue:(26.0f/255.0f) alpha:1.0];
        _selectorView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_selectorView];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_selectorView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_collectionView attribute:NSLayoutAttributeWidth multiplier:0.333333 constant:0.0]];
        [_selectorView addConstraint:[NSLayoutConstraint constraintWithItem:_selectorView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:5]];
    }
    
    // Layout constraints
    {
        NSDictionary *viewsDict = NSDictionaryOfVariableBindings(_collectionView,_selectorView);
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_collectionView]-|" options:0 metrics:nil views:viewsDict]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-statusHeight-[_collectionView][_selectorView]|" options:0 metrics:@{@"statusHeight":([UIApplication sharedApplication].isStatusBarHidden ? @0 : [NSNumber numberWithDouble:[UIApplication sharedApplication].statusBarFrame.size.height])} views:viewsDict]];
    }
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [_collectionView.collectionViewLayout invalidateLayout];
}

#pragma mark - UICollectionViewDelegate/DataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _items.count;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    GUTabBarCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGUTabBarCellcId forIndexPath:indexPath];
    cell.titleLabel.text = _items[indexPath.item].title;
    [cell setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    GUTabBarViewItem *item = _items[indexPath.item];
    if(_tapCallBack){
        _tapCallBack(item);
    }
    
    UICollectionViewLayoutAttributes *cellAttributes = [collectionView layoutAttributesForItemAtIndexPath:indexPath];
    CGRect convertedCellRect = [self convertRect:cellAttributes.frame toView:self];
    [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        CGRect selectorViewRect = _selectorView.frame;
        selectorViewRect.origin.x = convertedCellRect.origin.x;
        selectorViewRect.origin.y = CGRectGetMaxY(collectionView.frame);
        _selectorView.frame = selectorViewRect;
        
    } completion:nil];
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(collectionView.bounds.size.width/3, 50);
}
@end
