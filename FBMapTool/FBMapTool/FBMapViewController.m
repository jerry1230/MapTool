//
//  FBMapViewController.m
//  FBMapTool
//
//  Created by Bird on 15/1/4.
//  Copyright (c) 2015年 flyingbird. All rights reserved.
//

#import "FBMapViewController.h"
#import "BMapKit.h"
#import "FBMacro.h"
#import "FBUtils.h"
@interface FBMapViewController()<BMKMapViewDelegate,BMKLocationServiceDelegate>

@property (nonatomic,strong)BMKMapView *mapView;
@property (nonatomic,strong)BMKLocationService *locService;


@end
@implementation FBMapViewController

- (void)viewDidLoad
{
    //适配ios7
    if(IOS7_OR_LATER)
    {
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, [FBUtils GetScreeWidth], [FBUtils GetScreeHeight])];
    _mapView.mapType = BMKMapTypeStandard;
    _mapView.zoomLevel = 14;
    [_mapView setTrafficEnabled:NO];
    [_mapView setBuildingsEnabled:YES];
    [_mapView setBaiduHeatMapEnabled:NO];
    [self.view addSubview:_mapView];
    [self.view sendSubviewToBack:_mapView];
    _locService = [[BMKLocationService alloc]init];

}

-(void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    _mapView.delegate = self;
    _locService.delegate = self;// 此处记得不用的时候需要置nil，否则影响内存的释放
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;
    _locService.delegate = nil;// 不用时，置nil
}

- (void)dealloc
{
    if (_mapView) {
        _mapView = nil;
    }
}

//普通态
-(IBAction)startLocation:(id)sender
{
    NSLog(@"进入普通定位态");
    [_locService startUserLocationService];
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
//    [startBtn setEnabled:NO];
//    [startBtn setAlpha:0.6];
//    [stopBtn setEnabled:YES];
//    [stopBtn setAlpha:1.0];
//    [followHeadBtn setEnabled:YES];
//    [followHeadBtn setAlpha:1.0];
//    [followingBtn setEnabled:YES];
//    [followingBtn setAlpha:1.0];
}

/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)willStartLocatingUser
{
    NSLog(@"start locate");
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
    NSLog(@"heading is %@",userLocation.heading);
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [_mapView updateLocationData:userLocation];
    _mapView.centerCoordinate = userLocation.location.coordinate;
}

/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)didStopLocatingUser
{
    NSLog(@"stop locate");
}

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
}


#pragma mark - BMKMapViewDelegate

- (void)mapViewDidFinishLoading:(BMKMapView *)mapView {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"BMKMapView控件初始化完成" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
    [alert show];
    alert = nil;
}

- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate {
    NSLog(@"map view: click blank");
}

- (void)mapview:(BMKMapView *)mapView onDoubleClick:(CLLocationCoordinate2D)coordinate {
    NSLog(@"map view: double click");
}
@end
