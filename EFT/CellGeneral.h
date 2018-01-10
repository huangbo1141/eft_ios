//
//  CellGeneral.h
//  EFT
//
//  Created by Twinklestar on 12/11/15.
//  Copyright © 2015 Twinklestar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EftCategory.h"
#import "EftReview.h"
@interface CellGeneral : UITableViewCell

@property (weak,nonatomic) IBOutlet UILabel *lbl_content;

-(void)setHeaderData:(EftCategory*)category;
-(void)setData:(EftCategory*)category;
-(void)setDataReview:(EftReview*)review;
@end
