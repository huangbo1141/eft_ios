//
//  RounderBorderGcTextView.m
//  EFT
//
//  Created by BoHuang on 1/12/17.
//  Copyright © 2017 Twinklestar. All rights reserved.
//

#import "RounderBorderGcTextView.h"

@implementation RounderBorderGcTextView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setBorderColor:(UIColor *)borderColor{
    self.layer.masksToBounds = true;
    self.layer.cornerRadius = 5;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [borderColor CGColor];
}
@end
