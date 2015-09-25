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
@property (nonatomic, strong) NSMutableArray *itemsX;
@property (nonatomic) CGFloat transForm;
@end

@implementation CustomTransformCollecionLayout

- (void) prepareLayout{
    [super prepareLayout];
    
    [self initData];
    
    [self initItemsX];
}

/**
 * 该方法返回CollectionView的ContentSize的大小
 */
- (CGSize)collectionViewContentSize{
    
    CGFloat width = _numberOfCellsInSection * (_itemSize.width + _itemMargin);
    
    
    return CGSizeMake(width,  SCREEN_HEIGHT);
}


/**
 * 该方法为每个Cell绑定一个Layout属性~
 */
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    
    //[self initCellYArray];
    
    NSMutableArray *array = [NSMutableArray array];
    
    //add cells
    for (int i=0; i < _numberOfCellsInSection; i++)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        
        [array addObject:attributes];
    }
    
    return array;
    
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGFloat contentOffsetX = self.collectionView.contentOffset.x;
    
    
    NSInteger currentIndex = [self countIndexWithOffsetX: contentOffsetX];
    
    CGFloat centerX = [_itemsX[indexPath.row] floatValue];
    CGFloat centerY = SCREEN_HEIGHT/2;
    
    attributes.center = CGPointMake(centerX, centerY);
    
    attributes.size = CGSizeMake(_itemSize.width, _itemSize.height);

    CGFloat animationDistance = _itemSize.width + _itemMargin;
    
    CGFloat change = contentOffsetX - currentIndex * animationDistance + SCREEN_WIDTH/2 - _itemSize.width/2;
    
    if (change < 0) {
        
        change = contentOffsetX - (currentIndex - 1) * animationDistance + SCREEN_WIDTH/2 - _itemSize.width/2;
    }
    
    if (currentIndex == 0 && contentOffsetX <= 0) {
        
        change = 0;
        
    }
    
    CGFloat temp = M_PI * 2 * (change / (_itemSize.width + _itemMargin));
    
    attributes.transform = CGAffineTransformMakeRotation(temp);
    
    
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

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    
    
    //计算显示的是第几个Cell
    NSInteger index = [self countIndexWithOffsetX:proposedContentOffset.x];
    
    CGFloat centerX = index * (_itemSize.width + _itemMargin) + (_itemSize.width/2);
    
    proposedContentOffset.x = centerX - SCREEN_WIDTH/2;
    
    return proposedContentOffset;
}



- (NSInteger) countIndexWithOffsetX: (CGFloat) offsetX{
    return (offsetX + (SCREEN_WIDTH / 2)) / (_itemSize.width + _itemMargin);
}

- (void) initData{
    _numberOfSections = self.collectionView.numberOfSections;
    
    _numberOfCellsInSection = [self.collectionView numberOfItemsInSection:0];

    _itemSize = [_layoutDelegate itemSizeWithCollectionView:self.collectionView collectionViewLayout:self];
    
    _itemMargin = [_layoutDelegate marginSizeWithCollectionView:self.collectionView collectionViewLayout:self];
    
    _transForm = M_PI * 2 * _numberOfCellsInSection;
    
    
}

- (void) initItemsX{
    _itemsX = [[NSMutableArray alloc] initWithCapacity:_numberOfCellsInSection];
    
    for (int i = 0; i < _numberOfCellsInSection; i ++) {
        CGFloat tempX = i * (_itemSize.width + _itemMargin) + _itemSize.width/2;
        [_itemsX addObject:@(tempX)];
    }
    
    
}
@end
