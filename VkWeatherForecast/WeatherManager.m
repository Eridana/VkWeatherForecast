//
//  WeatherApi.m
//  VkWeatherForecast
//
//  Created by Jane on 20.06.14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import "WeatherManager.h"

@interface WeatherManager ()
{
    NSManagedObjectContext *context;
    AppDelegate *appDelegate;
}
@end

@implementation WeatherManager

+ (WeatherManager *)sharedInstance
{
    static WeatherManager * _sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[WeatherManager alloc] init];
    });
    return _sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        if(!context) {
            appDelegate = [[UIApplication sharedApplication] delegate];
            context = [appDelegate managedObjectContext];
        }
    }
    return self;
}

//-(void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
//{
//    context = managedObjectContext;
//}

@end
