//
//  WeatherData.h
//  VkWeatherForecast
//
//  Created by Jane on 20.06.14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface WeatherData : NSManagedObject

@property (nonatomic, retain) NSData * cityId;
@property (nonatomic, retain) NSNumber * cloudsValue;
@property (nonatomic, retain) NSDate   * date;
@property (nonatomic, retain) NSNumber * humidity;
@property (nonatomic, retain) NSNumber * isCelsius;
@property (nonatomic, retain) NSNumber * temperature;
@property (nonatomic, retain) NSNumber * windSpeed;

@end
