//
//  ImageCollectionViewCell.m
//  CollectionViewCustomLayout
//
//  Created by Mr.LuDashi on 15/9/21.
//  Copyright (c) 2015年 ZeluLi. All rights reserved.
//

#import "ImageCollectionViewCell.h"

@interface ImageCollectionViewCell ()

@property (nonatomic, strong) TapButtonBlock block;

@end

@implementation ImageCollectionViewCell

-(void) setTapButtonBlock: (TapButtonBlock) block{
    if (block) {
        _block = block;
    }
}
- (IBAction)tapCellButton:(id)sender {
    if (_block) {
        _block();
    }
    
}

@end
