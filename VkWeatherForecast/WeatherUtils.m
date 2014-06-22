//
//  WeatherUtils.m
//  VkWeatherForecast
//
//  Created by Женя Михайлова on 22.06.14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import "WeatherUtils.h"

@implementation WeatherUtils

+ (WeatherUtils *)sharedInstance
{
    static WeatherUtils * _sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[WeatherUtils alloc] init];
    });
    return _sharedInstance;
}

-(double)convertCelsiusToFahrenhate:(double)temp
{
     return temp * (9.0 / 5.0) + 32.0;
}

-(double)convertFahrenhateToCelsuis:(double)temp
{
    return (temp - 32.0) * (5.0 / 9.0);
}

-(double)convertKelvinToCelsius:(double)temp
{
    const double ZERO_CELSIUS_IN_KELVIN = 273.15;
    return temp - ZERO_CELSIUS_IN_KELVIN;
}

@end
