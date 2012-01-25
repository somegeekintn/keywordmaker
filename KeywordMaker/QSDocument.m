//
//  QSDocument.m
//  KeywordMaker
//
//  Created by Casey Fleser on 1/24/12.
//  Copyright (c) 2012 Casey Fleser. All rights reserved.
//

#import "QSDocument.h"
#import "CSVParser.h"
#import "NSString+QS.h"

@implementation QSDocument

@synthesize queryKey = _queryKey;
@synthesize countKey = _countKey;

- (void) dealloc
{
	self.queryKey = nil;
	self.countKey = nil;
	[_wordCount release];
	[_wordList release];
	
	[self dealloc];
}

- (NSString *) windowNibName
{
	return @"QSDocument";
}

- (void) windowControllerDidLoadNib: (NSWindowController *) inController
{
	[super windowControllerDidLoadNib: inController];
}


- (BOOL) readFromURL: (NSURL *) inAbsoluteURL
	ofType: (NSString *) inTypeName
	error: (NSError **) outError
{
	NSString		*rawData = [NSString stringWithContentsOfURL: inAbsoluteURL encoding: NSUTF8StringEncoding error: nil];
	NSMutableString	*trimmedData = [NSMutableString string];
	NSNumber		*count;
	CSVParser		*parser;
	
	[_wordCount release];
	_wordCount = [[NSMutableDictionary alloc] init];
	
	// ditch the comments, blank linkes at the beginning
	[rawData enumerateLinesUsingBlock: ^(NSString *inLine, BOOL *outStop) {
		if ([inLine length]) {
			NSRange		commentRange;

			commentRange = [inLine rangeOfString: @"#" options: NSAnchoredSearch];
			if (commentRange.location == NSNotFound)
				[trimmedData appendFormat: @"%@\r\n", inLine];
		}
	}];
	parser = [[[CSVParser alloc] initWithString: trimmedData separator: @"," hasHeader: YES fieldNames: nil] autorelease];
	[parser parseRowsForReceiver: self selector: @selector(receiveRecord:)];
	
	_wordList = [[NSMutableArray alloc] initWithCapacity: [[_wordCount allKeys] count]];
	for (NSString *word in [_wordCount allKeys]) {
		count = [_wordCount objectForKey: word];
		[_wordList addObject: [NSDictionary dictionaryWithObjectsAndKeys: word, @"word", count, @"count", nil]];
	}
	[_wordList sortUsingComparator:^(id inObj1, id inObj2) {
		NSDictionary	*info1 = inObj1;
		NSDictionary	*info2 = inObj2;
		
		return [[info2 objectForKey: @"count"] compare: [info1 objectForKey: @"count"]];
	}];
	
	return YES;
}

+ (BOOL) autosavesInPlace
{
    return NO;
}

- (NSString *) autosavingFileType
{
	return nil;
}

- (void) receiveRecord: (NSDictionary *) inRecord
{
	NSString	*query;		// one of "Matched Search Query" or "Query"
	NSString	*visits;	// one of "Impressions" or "Visits"
	NSNumber	*countVal;
	NSInteger	count;
	
	if (self.queryKey == nil || self.countKey == nil) {		// figure out which report we're looking at
		if ([[inRecord allKeys] containsObject: @"Matched Search Query"])
			self.queryKey = @"Matched Search Query";
		else if ([[inRecord allKeys] containsObject: @"Query"])
			self.queryKey = @"Query";
			
		if ([[inRecord allKeys] containsObject: @"Visits"])
			self.countKey = @"Visits";
		else if ([[inRecord allKeys] containsObject: @"Impressions"])
			self.countKey = @"Impressions";

		NSAssert(self.queryKey != nil, @"Couldn't determine query key. Must be one of \"Matched Search Query\" or \"Query\"");
		NSAssert(self.countKey != nil, @"Couldn't determine count key. Must be one of \"Visits\" or \"Impressions\"");
	}
	
	query = [inRecord objectForKey: self.queryKey];
	visits = [inRecord objectForKey: self.countKey];
	if ([visits isEqualToString: @"< 10"])	// assume 1
		visits = @"1";
	
	visits = [visits stringByRemovingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString: @","]];	// strip commas 
	if (![query isEqualToString: @"(not set)"]) {
		for (NSString *word in [query componentsSeparatedByCharactersInSet: [NSCharacterSet whitespaceCharacterSet]]) {
			if ([word length]) {
				count = [visits integerValue];
				if ((countVal = [_wordCount objectForKey: word]) != nil)
					count += [countVal integerValue];
				
				[_wordCount setObject: [NSNumber numberWithInteger: count] forKey: word];
			}
		}
	}
}

#pragma - NSTableViewDataSource

- (NSInteger) numberOfRowsInTableView: (NSTableView *) inTableView
{
	return [_wordList count];
}

- (id) tableView: (NSTableView *) inTableView
	objectValueForTableColumn: (NSTableColumn *) inTableColumn
	row: (NSInteger) inRow
{
	return [[_wordList objectAtIndex: inRow] objectForKey: inTableColumn.identifier];
}

@end
