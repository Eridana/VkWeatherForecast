//
//  WeatherManager.h
//  VkWeatherForecast
//
//  Created by Женя Михайлова on 21.06.14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "WeatherManagerDelegate.h"
#import "WeatherCommunicatorDelegate.h"

@class WeatherCommunicator;

@interface WeatherManager : NSObject<WeatherCommunicatorDelegate>
@property (strong, nonatomic) WeatherCommunicator *communicator;
@property (weak, nonatomic) id<WeatherManagerDelegate> delegate;
-(void)fetchWeatherDataAtCoordinate:(CLLocationCoordinate2D)coordinate;
-(void)fetchWeatherDataByCityName:(NSString *)name;
-(void)fetchDataFromDB;
-(void)saveWeatherData;
-(BOOL)isConnectionAvailable;
@end
