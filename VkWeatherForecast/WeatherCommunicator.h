//
//  WeatherCommunicator.h
//  VkWeatherForecast
//
//  Created by Женя Михайлова on 21.06.14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol WeatherCommunicatorDelegate;

@interface WeatherCommunicator : NSObject
@property (weak, nonatomic) id<WeatherCommunicatorDelegate> delegate;
-(void)searchWeatherDataByCoordinate:(CLLocationCoordinate2D)coordinate;
-(void)searchWeatherDataByCityName:(NSString *)name;
@end
