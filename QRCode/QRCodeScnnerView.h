//
//  QRCodeScnnerView.h
//  QRCode
//
//  Created by shenzhenshihua on 2017/1/20.
//  Copyright © 2017年 shenzhenshihua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QRCodeScnnerView : UIView

- (id)initWithFrame:(CGRect)frame outsideViewLayer:(CALayer *)outsideViewLayer;

- (void)removeTimer;

@end
