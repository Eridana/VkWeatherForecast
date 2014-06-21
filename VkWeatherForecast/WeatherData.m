//
//  WeatherData.m
//  VkWeatherForecast
//
//  Created by Женя Михайлова on 21.06.14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import "WeatherData.h"


@implementation WeatherData

@dynamic cityName;
@dynamic weatherDescription;
@dynamic cloudsValue;
@dynamic date;
@dynamic humidity;
@dynamic isCelsius;
@dynamic temperature;
@dynamic windSpeed;

- (double)kelvinToCelsius:(double)degreesKelvin
{
    const double ZERO_CELSIUS_IN_KELVIN = 273.15;
    return degreesKelvin - ZERO_CELSIUS_IN_KELVIN;
}

@end
