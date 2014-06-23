//
//  NSString+ToLatin.m
//  VkWeatherForecast
//
//  Created by Jane on 23.06.14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import "NSString+ToLatin.h"

@implementation NSString (ToLatin)

- (NSString *)toLatinWithDictionary
{
    NSMutableString* newString = [NSMutableString string];
    NSRange range;
    NSString* symbol;
    NSString* newSymbol;
    
    for (int i = 0; i < [self length]; i ++)
    {
        range = NSMakeRange(i, 1);
        symbol = [self substringWithRange:range];
        newSymbol = [self transliterateChar:symbol];
        if (newSymbol) {
            [newString appendString:newSymbol];
        }
        else {
            [newString appendString:symbol];
        }
    }
    return [NSString stringWithString:newString];
}

- (NSString*)transliterateChar:(NSString*)symbol
{
    NSArray* cyrillicChars = [NSArray arrayWithObjects:
                               @"а", @"б", @"в", @"г", @"д", @"е", @"ё", @"ж", @"з", @"и", @"й", @"к",
                               @"л", @"м", @"н", @"о", @"п", @"р", @"с", @"т", @"у", @"ф", @"х", @"ц",
                               @"ч", @"ш", @"щ", @"ъ", @"ы", @"ь", @"э", @"ю", @"я", nil];
    
    NSArray* latinChars = [NSArray arrayWithObjects:
                           @"a", @"b", @"v", @"g", @"d", @"e", @"yo", @"zh", @"z", @"i", @"y", @"k",
                           @"l", @"m", @"n", @"o", @"p", @"r", @"s", @"t", @"u", @"f", @"h", @"ts",
                           @"ch", @"sh", @"shch", @"'", @"y", @"'", @"e", @"yu", @"ya", nil];
    
    NSDictionary* convertDict = [NSDictionary dictionaryWithObjects:latinChars forKeys:cyrillicChars];
    return [convertDict valueForKey:[symbol lowercaseString]];
}

@end
