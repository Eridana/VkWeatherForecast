//
//  WeatherData+Save.m
//  VkWeatherForecast
//
//  Created by Jane on 20.06.14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import "WeatherData+Save.h"
#import "WeatherUtils.h"
#import "Constants.h"

@implementation WeatherData (Save)

+ (WeatherData *)saveWeatherData:(NSMutableDictionary *)info inManagedObjectContext:(NSManagedObjectContext *)context
{
    WeatherData *data = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:WEATHER_ENTITY_NAME];
    NSError *error = nil;
    data = [[context executeFetchRequest:request error:&error] lastObject];
    if(!error) {
        BOOL isFahrenhate = NO;
        // если объект есть, удаляем
        if(data) {
            isFahrenhate = data.isFahrenhate;
            [context deleteObject:data];
            if ([context hasChanges] && ![context save:&error]) {
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
            }
        }
        // создаем новый
        data = [NSEntityDescription insertNewObjectForEntityForName:WEATHER_ENTITY_NAME inManagedObjectContext:context];
        data.isFahrenhate = isFahrenhate;
        data.temperature = [[info objectForKey:TEMPERATURE_KEY] doubleValue];
        // в прошлый раз раз флажок был включен, т.е. нужно отображать с той же температурой в F
        if(isFahrenhate) {
            data.temperature = [[WeatherUtils sharedInstance] convertCelsiusToFahrenhate:data.temperature];
        }
        data.cityName = [info objectForKey:NAME_KEY];
        data.humidity = [[info objectForKey:HUMIDITY_KEY] doubleValue];
        data.weatherDescription = [info objectForKey:DESCRIPTION_KEY];
        data.cloudsValue = [[info objectForKey:CLOUDS_KEY] doubleValue];
        data.windSpeed = [[info objectForKey:SPEED_KEY] doubleValue];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat: @"dd-MMM-yyy HH:mm:ss"];
        data.dateAsString = [dateFormatter stringFromDate: [NSDate date]];
        [context save:&error];
    }
    
    if (error) {
        NSLog(@"Error creating weather data: %@", error);
    }

    return data;
}


@end
