//
//  CellPicture.h
//  EFT
//
//  Created by Twinklestar on 12/16/15.
//  Copyright © 2015 Twinklestar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
@interface CellPicture : UICollectionViewCell

@property (weak,nonatomic) IBOutlet AsyncImageView *img_content;
@end
