//
//  TEXASLayouter.cpp
//  TEXAS
//
//  Created by Uli Kusterer on 28.01.19.
//  Copyright © 2019 Uli Kusterer. All rights reserved.
//

#include "TEXASLayouter.hpp"
#include <iostream>


void TEXASLayouter::CalculateLineRuns(TEXASRenderer& renderer) {
	lineRuns.clear();
	
	TEXASLineRun run;
	run.lineStart = 0;
	run.lineHeight = renderer.GetLineHeight();
	int currLineWidth = 0;
	const char* str = text.c_str();

	for (size_t x = 0; x < text.length();) {
		size_t measuredChars = 0;
		size_t measuredCharsWithSpaces = 0;
		currLineWidth += renderer.WidthOfCharacters(str + x, &measuredChars, &measuredCharsWithSpaces, lineWidth, '\n');
		run.lineEnd = x + measuredChars;
		run.hardBreak = text[run.lineEnd] == '\n';
				
		lineRuns.push_back(run);

		if (run.hardBreak) {
			x = run.lineStart = run.lineEnd + 1;
		} else {
			x = run.lineStart = x + measuredCharsWithSpaces;
		}
	}
}

size_t	TEXASLayouter::OffsetAtXY(TEXASRenderer& renderer, int mouseX, int mouseY, TEXASCharacterHitPart* hitEdge) {
	int x = renderer.GetX();
	int y = renderer.GetY();
	int currY = y;
	size_t foundOffs = text.length();
	
	for(TEXASLineRun& run : lineRuns) {
		if (mouseY < currY && mouseY > (currY -run.lineHeight)) {
			foundOffs = run.lineStart;
			size_t foundStartOffs = 0, foundEndOffs = 0;
			*hitEdge = renderer.HitTestCharacters(text.c_str() + run.lineStart, &foundStartOffs, &foundEndOffs, mouseX - x);
			foundOffs = foundStartOffs + run.lineStart;
			if (foundOffs >= run.lineEnd) {
				*hitEdge = TEXASCharacterHitRightHalf;
			}
			break;
		}
		currY -= run.lineHeight;
	}
	
	return foundOffs;
}

void	TEXASLayouter::Draw(TEXASRenderer& renderer, size_t cursorOffset, TEXASCharacterHitPart hitEdge) {
	int leftEdge = renderer.GetX();
	for(TEXASLineRun& run : lineRuns) {
		std::string currLine = text.substr(run.lineStart, run.lineEnd -run.lineStart);
		renderer.DrawCharacters(currLine.c_str(), (cursorOffset < run.lineStart) ? INT_MAX : (cursorOffset - run.lineStart), hitEdge);
		renderer.SetX(leftEdge);
		renderer.MoveY(-renderer.GetLineHeight());
	}
}
