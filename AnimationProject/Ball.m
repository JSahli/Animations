//
//  Ball.m
//  AnimationProject
//
//  Created by Jesse Sahli on 8/2/16.
//  Copyright © 2016 sahlitude. All rights reserved.
//

#import "Ball.h"

@implementation Ball


- (UIDynamicItemCollisionBoundsType)collisionBoundsType{
    return UIDynamicItemCollisionBoundsTypeEllipse;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
