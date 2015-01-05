//
//  FBMacro.h
//  louyou
//
//  Created by Iceland on 14/10/29.
//  Copyright (c) 2014年 xxw. All rights reserved.
//


//部分常用颜色
#define kColorClear         [UIColor clearColor]
#define kColorWhite         [UIColor whiteColor]
#define kColorBlack         [UIColor blackColor]
#define kColorYellow        [UIColor yellowColor]
#define kColorBlue          [UIColor blueColor]


#define kUserDefaut  [NSUserDefaults standardUserDefaults]


#define IOS7_OR_LATER ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
#define IOS8_OR_LATER ([[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != NSOrderedAscending)


#ifdef DEBUG
# define FBLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ## __VA_ARGS__);
#else
#define FBLog(fmt, ...)
#endif



#define BAIDUMAP_ACCESSKEY @"hGvcNB9QqYLfZNQCkrjHZdB1"

//#define APP_ID  @"5181991"






#define LX_LOADING @"加载中..."
#define LX_UPLOADING @"上传中..."

#define FB_UID @"UserID"
#define FB_NICKNAME @"UserNickName"
#define FB_ICON @"user_icon_url"
#define FB_QIANMING @"signature"


#define NOTI_DATAOK @"userInputDataOK"







