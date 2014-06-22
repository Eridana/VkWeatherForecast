//
//  WeatherUtils.h
//  VkWeatherForecast
//
//  Created by Женя Михайлова on 22.06.14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherUtils : NSObject

+(WeatherUtils *)sharedInstance;
-(double)convertToFahrenhate:(double)temp;
-(double)convertToCelsuis:(double)temp;
-(double)convertKelvinToCelsius:(double)degreesKelvin;

@end
