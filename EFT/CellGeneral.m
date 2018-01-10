//
//  CellGeneral.m
//  EFT
//
//  Created by Twinklestar on 12/11/15.
//  Copyright © 2015 Twinklestar. All rights reserved.
//

#import "CellGeneral.h"

@implementation CellGeneral

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setHeaderData:(EftCategory*)category{
    _lbl_content.text = category.ec_name;
    self.backgroundColor = [UIColor grayColor];
}
-(void)setData:(EftCategory*)category{
    _lbl_content.text = category.ec_name;
    self.backgroundColor = [UIColor whiteColor];
}
-(void)setDataReview:(EftReview*)review{
    _lbl_content.text = review.er_text;
    self.backgroundColor = [UIColor whiteColor];
}
@end
