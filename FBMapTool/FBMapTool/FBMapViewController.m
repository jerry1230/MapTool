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

#define HAS_LOCATION @"USERLOCATION_GOT"
#define FB_LATITUDE @"USER_LAST_LATITUDE"
#define FB_LONGTITUDE @"USER_LAST_LONGTITUDE"

/*
 *  CLLocationCoordinate2D
 *
 *  Discussion:
 *    A structure that contains a geographical coordinate.
 *
 *  Fields:
 *    latitude:
 *      The latitude in degrees.
 *    longitude:
 *      The longitude in degrees.
 */
//typedef struct {
//    CLLocationDegrees latitude;
//    CLLocationDegrees longitude;
//} CLLocationCoordinate2D;



@interface FBMapViewController()<BMKMapViewDelegate,BMKLocationServiceDelegate>

@property (nonatomic,strong)BMKMapView *mapView;
@property (nonatomic,strong)BMKLocationService *locService;
@property (nonatomic,strong)NSMutableArray *circleArray;
- (IBAction)mapTypeSwitchAction:(UIButton *)sender;

@end
@implementation FBMapViewController

- (void)viewDidLoad
{
//    self.navigationController.navigationBarHidden = YES;
    
    self.title = @"大侦探";
    self.circleArray = [[NSMutableArray alloc] initWithObjects:nil];
    //适配ios7
    if(IOS7_OR_LATER)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    int height = IOS7_OR_LATER?93:49;
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, [FBUtils GetScreeWidth], [FBUtils GetScreeHeight]-height)];
    _mapView.mapType = BMKMapTypeStandard;
    _mapView.zoomLevel = 14;
    _mapView.showMapScaleBar = YES; 
    [_mapView setTrafficEnabled:NO];
    [_mapView setBuildingsEnabled:YES];
    [_mapView setBaiduHeatMapEnabled:NO];
    [self.view addSubview:_mapView];
    [self.view sendSubviewToBack:_mapView];
    
    if ([LUserDefaut boolForKey:HAS_LOCATION])
    {
        CLLocationCoordinate2D coor;
        coor.latitude = [LUserDefaut floatForKey:FB_LATITUDE];
        coor.longitude = [LUserDefaut floatForKey:FB_LONGTITUDE];
        _mapView.centerCoordinate = coor;
    }
    
    _locService = [[BMKLocationService alloc]init];
    [_locService startUserLocationService];
    
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dataOK:)
                                                 name:NOTI_DATAOK
                                               object:nil];
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
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTI_DATAOK object:nil];
}

- (void)drawCircle:(int)radius
{
    BMKCircle *circle = [BMKCircle circleWithCenterCoordinate:_mapView.centerCoordinate radius:radius];
    [_mapView addOverlay:circle];
    [self.circleArray addObject:circle];
}

-(BOOL)canPerformUnwindSegueAction:(SEL)action fromViewController:(UIViewController *)fromViewController withSender:(id)sender
{
    return YES;
}

- (IBAction)done:(UIStoryboardSegue *)segue
{
    // React to the impending segue
    // Pull state back, etc.
}

# pragma mark -
# pragma mark - NSNotification
- (void)dataOK:(NSNotification *)notification
{
    NSString *radius =notification.object;
    if ([radius intValue]<=2000)
    {
        _mapView.zoomLevel = 17-([radius intValue]-1)/500;
    }
    else if([radius intValue]<=4000&&[radius intValue]>2000)
    {
        _mapView.zoomLevel = 19-([radius intValue]-1)/500;
    }
    else if([radius intValue]<=6000&&[radius intValue]>4000)
    {
        _mapView.zoomLevel = 22-([radius intValue]-1)/500;
    }
    else if([radius intValue]<=8000&&[radius intValue]>6000)
    {
        _mapView.zoomLevel = 26-([radius intValue]-1)/500;
    }
    else if([radius intValue]<=10000&&[radius intValue]>8000)
    {
        _mapView.zoomLevel = 30-([radius intValue]-1)/500;
    }
    else if([radius intValue]>10000)
    {
        _mapView.zoomLevel = 11;
    }
    [self drawCircle:[radius intValue]];
    FBLog(@"_mapView.zoomLevel=%f",_mapView.zoomLevel);
}

# pragma mark -
# pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        //删除圆形覆盖物
        for (NSObject *obj in self.circleArray)
        {
            if ([obj isKindOfClass:[BMKCircle class]])
            {
                BMKCircle *circle = (BMKCircle *)obj;
                [_mapView removeOverlay:circle];
                circle=nil;
            }
        }
        [self.circleArray removeAllObjects];
    }
}

# pragma mark -
# pragma mark - Action
- (IBAction)mapTypeSwitchAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected)
    {
        _mapView.mapType = BMKMapTypeSatellite;
    }
    else
    {
        _mapView.mapType = BMKMapTypeStandard;
    }
}

-(IBAction)startLocation:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected)
    {
        FBLog(@"停止定位");
        [_locService stopUserLocationService];
        _mapView.showsUserLocation = NO;
        [sender setTitle:@"开始定位" forState:UIControlStateNormal];
    }
    else
    {
        FBLog(@"进入普通定位态");
        [sender setTitle:@"停止定位" forState:UIControlStateNormal];
        [_locService startUserLocationService];
        _mapView.showsUserLocation = NO;//先关闭显示的定位图层
        _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
        _mapView.showsUserLocation = YES;//显示定位图层
    }
}

//删除标注
-(IBAction)deleteCircles:(UIButton *)btn
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定删掉所有追踪记录吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    [alert show];
}

- (IBAction)plusBtnClicked:(UIButton *)btn
{
    float currentZoomLevel = _mapView.zoomLevel;
    if (currentZoomLevel + 1 <= 19)
    {
        [_mapView setZoomLevel: currentZoomLevel+1];
    }
    else
    {
        [_mapView setZoomLevel:19];
    }
}

- (IBAction)minusBtnClicked:(UIButton *)btn
{
    float currentZoomLevel = _mapView.zoomLevel;
    if (currentZoomLevel+1 >= 3)
    {
        [_mapView setZoomLevel:currentZoomLevel-1];
    }
    else
    {
        [_mapView setZoomLevel:3];
    }
}

#pragma mark -
#pragma mark - BMKLocationServiceDelegate
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
    [LUserDefaut setBool:YES forKey:HAS_LOCATION];
    [LUserDefaut setFloat:userLocation.location.coordinate.latitude forKey:FB_LATITUDE];
    [LUserDefaut setFloat:userLocation.location.coordinate.longitude forKey:FB_LONGTITUDE];
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

#pragma mark -
#pragma mark - BMKMapViewDelegate
- (void)mapViewDidFinishLoading:(BMKMapView *)mapView {
    FBLog(@"BMKMapView控件初始化完成");
}

- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate {
    NSLog(@"map view: click blank");
}

- (void)mapview:(BMKMapView *)mapView onDoubleClick:(CLLocationCoordinate2D)coordinate {
    NSLog(@"map view: double click");
}

/**
 *地图区域改变完成后会调用此接口
 *@param mapview 地图View
 *@param animated 是否动画
 */
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    FBLog(@"RegionDidChange mapView.zoomLevel=%f",_mapView.zoomLevel);

}

//根据overlay生成对应的View
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKCircle class]])
    {
        BMKCircleView* circleView = [[BMKCircleView alloc] initWithOverlay:overlay];
        circleView.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
        circleView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
        circleView.lineWidth = 5.0;
        
        return circleView;
    }
    return nil;
}
@end
