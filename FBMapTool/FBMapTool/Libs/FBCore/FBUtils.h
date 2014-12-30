//
//  FBUtils.h
//  louyou
//
//  Created by Iceland on 14/10/30.
//  Copyright (c) 2014年 xxw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FBUtils : NSObject


/** check if object is empty
 if an object is nil, NSNull, or length == 0, return True
 */
static inline BOOL FBIsEmpty(id thing)
{
    return thing == nil ||
    ([thing isEqual:[NSNull null]]) ||
    ([thing respondsToSelector:@selector(length)] && [(NSData *)thing length] == 0) ||
    ([thing respondsToSelector:@selector(count)]  && [(NSArray *)thing count] == 0);
}


/*
 * 获得屏幕的分辨率
 */
+ (int)GetScreeWidth;
+ (int)GetScreeHeight;

/*
 *  Name    : colorWithHexString
 *  Param   : NSString
 *  Note    : html颜色值转化UIColor  如#FF9900,0XFF9900
 */
+ (UIColor *)colorWithHexString: (NSString *) stringToConvert;

/** check if object is empty
 
 if an object is nil, NSNull, or length == 0, return True
 */
+ (BOOL)isEmpty:(id)thing;

+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;



@end
