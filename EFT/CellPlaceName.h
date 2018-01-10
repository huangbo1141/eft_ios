//
//  CellPlaceName.h
//  EFT
//
//  Created by Twinklestar on 12/7/15.
//  Copyright © 2015 Twinklestar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EftRegion.h"
#import "EftReview.h"
@interface CellPlaceName : UITableViewCell

@property (weak,nonatomic) IBOutlet UILabel * lbl_content;
@property (weak,nonatomic) IBOutlet UIButton * btn_close;
@property (weak,nonatomic) IBOutlet UIImageView * img_right;

-(void)setData:(EftRegion*)region;
-(void)setDataForMenu:(EftRegion*)region;
-(void)setDataReview:(EftReview*)review IndexPath:(NSIndexPath*)indexPath;

@property (weak,nonatomic) id delegate;
@property (strong,nonatomic) NSIndexPath*indexPath;

-(void)setMyDelegate:(id)delegate;
+(CGFloat)getLabelWidth:(CGFloat) defWidth;

@property (weak,nonatomic) IBOutlet NSLayoutConstraint * constraint_label;
@end
