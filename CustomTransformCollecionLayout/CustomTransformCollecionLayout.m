//
//  CustomTransformCollecionLayout.m
//  CustomTransformCollecionLayout
//
//  Created by Mr.LuDashi on 15/9/24.
//  Copyright (c) 2015年 ZeluLi. All rights reserved.
//

#import "CustomTransformCollecionLayout.h"

@interface CustomTransformCollecionLayout()

@property (nonatomic) NSInteger numberOfSections;
@property (nonatomic) NSInteger numberOfCellsInSection;
@property (nonatomic) CGSize itemSize;
@property (nonatomic) CGFloat itemMargin;
@property (nonatomic) CGFloat transForm;
@property (nonatomic, strong) NSMutableArray *itemsX;

@end

@implementation CustomTransformCollecionLayout


#pragma mark -- UICollectionViewLayout 重写的方法
- (void)prepareLayout {
    [super prepareLayout];
    
    [self initData];
    
    [self initItemsX];
}

/**
 * 该方法返回CollectionView的ContentSize的大小
 */
- (CGSize)collectionViewContentSize {
    CGFloat width = _numberOfCellsInSection * (_itemSize.width + _itemMargin);
    return CGSizeMake(width,  SCREEN_HEIGHT);
}


/**
 * 该方法为每个Cell绑定一个Layout属性~
 */
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSMutableArray *array = [NSMutableArray array];
    
    //add cells
    for (int i = 0; i < _numberOfCellsInSection; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        
        [array addObject:attributes];
    }
    return array;
}


/**
 * 为每个Cell设置attribute
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //获取当前Cell的attributes
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    //获取滑动的位移
    CGFloat contentOffsetX = self.collectionView.contentOffset.x;
    //根据滑动的位移计算当前显示的时第几个Cell
    NSInteger currentIndex = [self countIndexWithOffsetX: contentOffsetX];
    //获取Cell的X坐标
    CGFloat centerX = [_itemsX[indexPath.row] floatValue];
    //计算Cell的Y坐标
    CGFloat centerY = SCREEN_HEIGHT/2;
    
    //设置Cell的center和size属性
    attributes.center = CGPointMake(centerX, centerY);
    attributes.size = CGSizeMake(_itemSize.width, _itemSize.height);

    //计算当前偏移量（滑动后的位置 - 滑动前的位置）
    CGFloat animationDistance = _itemSize.width + _itemMargin;
    CGFloat change = contentOffsetX - currentIndex * animationDistance + SCREEN_WIDTH / 2 - _itemSize.width / 2;
    
    //做一个位置修正，因为当滑动过半时，currentIndex就会加一，就不是上次显示的Cell的索引，所以要减去一做个修正
    if (change < 0) {
        change = contentOffsetX - (currentIndex - 1) * animationDistance + SCREEN_WIDTH/2 - _itemSize.width/2;
    }
    
    if (currentIndex == 0 && contentOffsetX <= 0) {
        change = 0;
    }
    
    //旋转量
    CGFloat temp = M_PI * 2 * (change / (_itemSize.width + _itemMargin));
    
    //仿射变换 赋值
    attributes.transform = CGAffineTransformMakeRotation(temp);
    
    //把当前显示的Cell的zIndex设置成较大的值
    if (currentIndex == indexPath.row) {
        attributes.zIndex = 1000;
    } else {
        attributes.zIndex = currentIndex;
    }
    
    return attributes;
}


//当边界发生改变时，是否应该刷新布局。如果YES则在边界变化（一般是scroll到其他地方）时，将重新计算需要的布局信息。
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return !CGRectEqualToRect(newBounds, self.collectionView.bounds);
}

//修正Cell的位置，使当前Cell显示在屏幕的中心
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    
    
    //计算显示的是第几个Cell
    NSInteger index = [self countIndexWithOffsetX:proposedContentOffset.x];
    
    CGFloat centerX = index * (_itemSize.width + _itemMargin) + (_itemSize.width/2);
    
    proposedContentOffset.x = centerX - SCREEN_WIDTH/2;
    
    return proposedContentOffset;
}





#pragma mark -- 自定义的方法
/**
 * 根据滚动便宜量来计算当前显示的时第几个Cell
 */
- (NSInteger) countIndexWithOffsetX: (CGFloat) offsetX{
    return (offsetX + (SCREEN_WIDTH / 2)) / (_itemSize.width + _itemMargin);
}

/**
 * 初始化私有属性，通过代理获取配置参数
 */
- (void) initData{
    _numberOfSections = self.collectionView.numberOfSections;
    
    _numberOfCellsInSection = [self.collectionView numberOfItemsInSection:0];

    _itemSize = [_layoutDelegate itemSizeWithCollectionView:self.collectionView collectionViewLayout:self];
    
    _itemMargin = [_layoutDelegate marginSizeWithCollectionView:self.collectionView collectionViewLayout:self];
    
}

/**
 * 计算每个Cell的X坐标
 */
- (void) initItemsX{
    _itemsX = [[NSMutableArray alloc] initWithCapacity:_numberOfCellsInSection];
    
    for (int i = 0; i < _numberOfCellsInSection; i ++) {
        CGFloat tempX = i * (_itemSize.width + _itemMargin) + _itemSize.width/2;
        [_itemsX addObject:@(tempX)];
    }
    
    
}
@end
