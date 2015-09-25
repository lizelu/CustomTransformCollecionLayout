//
//  CustomTransformCollecionLayout.h
//  CustomTransformCollecionLayout
//
//  Created by Mr.LuDashi on 15/9/24.
//  Copyright (c) 2015年 ZeluLi. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

@class CustomTransformCollecionLayout;

@protocol CustomTransformCollecionLayoutDelegate <NSObject>
/**
 * 确定cell的大小
 */
- (CGSize) itemSizeWithCollectionView: (UICollectionView *)collectionView
                 collectionViewLayout:(CustomTransformCollecionLayout *)collectionViewLayout;

/**
 * 确定cell的大小
 */
- (CGFloat) marginSizeWithCollectionView: (UICollectionView *)collectionView
                 collectionViewLayout:(CustomTransformCollecionLayout *)collectionViewLayout;



@end

@interface CustomTransformCollecionLayout : UICollectionViewLayout

@property (nonatomic, weak) id<CustomTransformCollecionLayoutDelegate> layoutDelegate;

@end
