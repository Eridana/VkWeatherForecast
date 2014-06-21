//
//  WeatherCommunicatorDelegate.h
//  VkWeatherForecast
//
//  Created by Женя Михайлова on 21.06.14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WeatherCommunicatorDelegate
- (void)receivedWeatherDataJson:(NSData *)json;
- (void)fetchingFailedWithError:(NSError *)error;
@end
