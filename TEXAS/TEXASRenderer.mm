//
//  TEXASRenderer.cpp
//  TEXAS
//
//  Created by Uli Kusterer on 27.01.19.
//  Copyright © 2019 Uli Kusterer. All rights reserved.
//

#include "TEXASRenderer.hpp"
#import <Cocoa/Cocoa.h>

const char* TEXASTimesCharacters[] = {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N",
										"O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
										"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n",
										"o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
										"0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
										".", ",", "?", "/", ":", ";", "'", "\"", "(", ")", "!", " ", "-",
										"Ä", "Ö", "Ü", "ä", "ö", "ü",
										nullptr};
CGFloat TEXASTimesCharacterWidth[] = { 13, 13, 12, 13, 11, 10, 13, 13, 6, 7, 12, 12, 16, 13,
										13, 10, 13, 12, 9, 12, 13, 13, 17, 13, 13, 12,
										7, 9, 8, 9, 8, 6, 8, 9, 5, 6, 8, 5, 14, 10,
										9, 9, 9, 6, 7, 5, 9, 9, 13, 9, 9, 7,
										10, 8, 10, 8, 10, 8, 10, 9, 9, 10,
										4, 4, 8, 6, 4, 4, 4, 7, 7, 7, 4, 5, 7,
										12, 13, 13, 7, 10, 9,
										10 };
bool TEXASBreakingCharacters[] = {	false, false, false, false, false, false, false, false, false, false, false, false, false, false,
									false, false, false, false, false, false, false, false, false, false, false, false,
									false, false, false, false, false, false, false, false, false, false, false, false, false, false,
									false, false, false, false, false, false, false, false, false, false, false, false,
									false, false, false, false, false, false, false, false, false, false,
									true, true, true, true, true, true, false, false, false, false, true, true, true,
									false, false, false, false, false, false,
									false
};
NSString * TEXASTimesImageName = @"Times";

TEXASRenderer::TEXASRenderer() {
	img = [NSImage imageNamed: TEXASTimesImageName];
}

TEXASRenderer::~TEXASRenderer() {
	img = nil;
}

void TEXASRenderer::DrawCharacters(const char *theCh) {
	for (size_t y = 0; theCh[y] != 0;) {
		bool foundGlyph = false;
		for (size_t x = 0; TEXASTimesCharacters[x] && !foundGlyph; ++x) {
			size_t patternLen = strlen(TEXASTimesCharacters[x]);
			if (strncmp(TEXASTimesCharacters[x], theCh + y, patternLen) == 0) {
				DrawGlyphAtIndex(x);
				y += patternLen;
				foundGlyph = true;
			}
		}
		if (!foundGlyph) {
			DrawGlyphAtIndex((sizeof(TEXASTimesCharacters) / sizeof(const char*)) - 1);
			y += 1;
		}
	}
}


int TEXASRenderer::WidthOfCharacters(const char *theCh, size_t *outMeasuredChars, int maximumWidth, char stopChar) {
	int width = 0;
	size_t y = 0;
	size_t lastBreakCharacter = SIZE_T_MAX;
	int lastBreakWidth = 0;
	
	while (theCh[y] != 0 && theCh[y] != stopChar) {
		bool foundGlyph = false;
		for (size_t x = 0; TEXASTimesCharacters[x] && !foundGlyph; ++x) {
			size_t patternLen = strlen(TEXASTimesCharacters[x]);
			if (strncmp(TEXASTimesCharacters[x], theCh + y, patternLen) == 0) {
				if ((width + TEXASTimesCharacterWidth[x]) > maximumWidth) {
					while(theCh[y] == ' ') {
						++y;
					}
					if (lastBreakCharacter != SIZE_T_MAX) {
						y = lastBreakCharacter;
						width = lastBreakWidth;
					}
					if (outMeasuredChars) {
						*outMeasuredChars = y;
					}
					return width;
				}

				width += TEXASTimesCharacterWidth[x];
				y += patternLen;
				foundGlyph = true;
				if (TEXASBreakingCharacters[x]) {
					lastBreakCharacter = y;
					lastBreakWidth = width;
				}
			}
		}
		if (!foundGlyph) {
			if ((width + TEXASTimesCharacterWidth[x]) > maximumWidth) {
				if (outMeasuredChars) {
					*outMeasuredChars = y;
				}
				return width;
			}
			width += TEXASTimesCharacterWidth[(sizeof(TEXASTimesCharacters) / sizeof(const char*)) - 1];
			y += 1;
		}
	}
	if (outMeasuredChars) {
		*outMeasuredChars = y;
	}
	return width;
}


void	TEXASRenderer::DrawGlyphAtIndex(size_t glyphIndex) {
	NSRect box = { NSZeroPoint, { 0, img.size.height } };
	for (int x = 0; x <= glyphIndex; ++x) {
		box.origin.x = NSMaxX(box);
		box.size.width = TEXASTimesCharacterWidth[x];
	}
	
	if (style & TEXASSelectedStyle) {
		[NSColor.selectedTextBackgroundColor set];
		[NSBezierPath fillRect: (NSRect){ {(CGFloat)x, (CGFloat)y - box.size.height}, NSMakeSize(box.size.width, box.size.height) }];
	}
	if (style & TEXASBoxedStyle) {
		[NSColor.cyanColor set];
		[NSBezierPath strokeRect: (NSRect){ {(CGFloat)x + 0.5, (CGFloat)y - box.size.height + 0.5}, NSMakeSize(box.size.width - 1.0, box.size.height - 1.0) }];
	}
	[img drawAtPoint: NSMakePoint(x, y - box.size.height) fromRect: box operation: NSCompositingOperationSourceOver fraction: 1.0];
	x += box.size.width;
}


int	TEXASRenderer::GetLineHeight() {
	return img.size.height;
}
