//
//  TEXASRenderer.hpp
//  TEXAS
//
//  Created by Uli Kusterer on 27.01.19.
//  Copyright © 2019 Uli Kusterer. All rights reserved.
//

#ifndef TEXASRenderer_hpp
#define TEXASRenderer_hpp

#include <cstdint>
#include <cstddef>
#include <climits>

#if __OBJC__
@class NSImage;
#else
struct NSImage;
#endif

enum _TEXASTextStyle {
	TEXASPlainStyle = 0,
	TEXASSelectedStyle = (1 << 0),
	TEXASBoxedStyle = (1 << 1),
};
typedef uint32_t TEXASTextStyle;

class TEXASRenderer {
public:
	TEXASRenderer();
	~TEXASRenderer();

	void	DrawGlyphAtIndex(size_t glyphIndex, bool drawCursor);
	
	void	SetX(int inX)	{ x = inX; }
	int		GetX() 			{ return x; }
	void	SetY(int inY)	{ y = inY; }
	int		GetY() 			{ return y; }
	void	MoveX(int inX)	{ x += inX; }
	void	MoveY(int inY)	{ y += inY; }
	void	SetTextStyle(TEXASTextStyle inStyle) { style = inStyle; }

	int		GetLineHeight();

	void	DrawCharacters(const char *theCh, size_t cursorOffset);
	int		WidthOfCharacters( const char *theCh, size_t *outMeasuredChars = nullptr, int maximumWidth = INT_MAX, char stopChar = '\0' );

protected:
	int x = 0;
	int y = 0;
	TEXASTextStyle style = TEXASPlainStyle;
	NSImage * img = nullptr;
};

#endif /* TEXASRenderer_hpp */
