//
//  ViewSetting.h
//  EFT
//
//  Created by Twinklestar on 12/8/15.
//  Copyright © 2015 Twinklestar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewSetting : UIView

@property (weak,nonatomic) UILabel *lbl_search;
@property (weak,nonatomic) IBOutlet UITextField * txt_radius;
@property (weak,nonatomic) IBOutlet UIButton * btn_ok;

-(NSString*)getRadius;
-(void)initData;
-(void)initControl;
@end
