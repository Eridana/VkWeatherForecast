//
//  CitiesViewController.m
//  VkWeatherForecast
//
//  Created by Женя Михайлова on 22.06.14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import "CitiesViewController.h"
#import "UIView+ActivityIndicator.h"
#import "Constants.h"
#import "NSString+ToLatin.h"

@interface CitiesViewController ()
{
    NSArray *_cities;
    NSArray *_searchResults;
}
@end

@implementation CitiesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _cities = [self readCitiesFromFile];
    _searchResults = [[NSArray alloc] init];
    [self updateTable];
}

- (void) updateTable
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_tableView reloadData];
    });
}

- (NSArray *)readCitiesFromFile
{
    NSError *error = nil;
    NSString *file = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource: @"cities" ofType: @"txt"] encoding:NSUTF8StringEncoding error:&error];
    if(error) {
        NSLog(@"Error reading file %@", error);
    }
    NSArray *result = [file componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    return result;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SearchBar

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self contains[c] %@", searchText];
    _searchResults = [_cities filteredArrayUsingPredicate:predicate];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                       objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return YES;
}

#pragma mark - TableVie

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [_searchResults count];
    } else {
        return [_cities count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *city = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        city = [_searchResults objectAtIndex:indexPath.row];
    } else {
        city = [_cities objectAtIndex:indexPath.row];
    }
    static NSString *сellIdentifier = @"CityCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:сellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:сellIdentifier];
    }
    [cell.textLabel setText:city];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     NSString *city = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        city = [_searchResults objectAtIndex:indexPath.row];
    } else {
        city = [_cities objectAtIndex:indexPath.row];
    }
    // openweather не всегда возвращает верное имя для русских названий
    city = [city toLatinWithDictionary];
    
    NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:city forKey:CITY_NAME_KEY];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cityDidSelect" object:self userInfo:userInfo];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
