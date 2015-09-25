//
//  ImageCollectionViewCell.h
//  CollectionViewCustomLayout
//
//  Created by Mr.LuDashi on 15/9/21.
//  Copyright (c) 2015年 ZeluLi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TapButtonBlock)();

@interface ImageCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *cellImageView;

- (void)setTapButtonBlock:(TapButtonBlock) block;

@end
