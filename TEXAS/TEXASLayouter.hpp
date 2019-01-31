//
//  TEXASLayouter.hpp
//  TEXAS
//
//  Created by Uli Kusterer on 28.01.19.
//  Copyright © 2019 Uli Kusterer. All rights reserved.
//

#ifndef TEXASLayouter_hpp
#define TEXASLayouter_hpp

#include <cstddef>
#include <vector>
#include <string>
#include "TEXASRenderer.hpp"

class TEXASLineRun {
public:
	size_t lineStart;
	size_t lineEnd;
	int lineHeight;
	bool hardBreak;
};

class TEXASLayouter {
public:
	void CalculateLineRuns(TEXASRenderer& renderer);
	void Draw(TEXASRenderer& renderer, size_t cursorOffset, TEXASCharacterHitPart hitEdge);
	size_t OffsetAtXY(TEXASRenderer& renderer, int mouseX, int mouseY, TEXASCharacterHitPart* hitEdge);
	
	std::string text;
	std::vector<TEXASLineRun> lineRuns;
	int lineWidth; // In pixels.
};

#endif /* TEXASLayouter_hpp */
