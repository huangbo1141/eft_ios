//
//  PhotoViewController.h
//  EFT
//
//  Created by Twinklestar on 12/16/15.
//  Copyright © 2015 Twinklestar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak,nonatomic) IBOutlet UICollectionView* collectionview;
@property (weak,nonatomic) IBOutlet UIImageView* img_large;
@property (weak,nonatomic) IBOutlet UIButton* btn_back;

@property (weak,nonatomic) IBOutlet UICollectionViewFlowLayout *flowlayout_collection;

@end
