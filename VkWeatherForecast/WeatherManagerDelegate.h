//
//  WeatherManagerDelegate.h
//  VkWeatherForecast
//
//  Created by Женя Михайлова on 21.06.14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WeatherData;

@protocol WeatherManagerDelegate
- (void)didReceiveWeatherData:(NSMutableArray *)data;
- (void)fetchingFailedWithError:(NSError *)error;
@end
