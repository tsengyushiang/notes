# Tree Graph

```latex
\documentclass[border=5pt]{standalone}

%---setup chinese font------------------------------------
\usepackage{xeCJK}
\setCJKmainfont{Noto Sans CJK SC}
\setCJKsansfont{Noto Sans CJK SC}

%---required packages & variable definitions------------------------------------
\usepackage{forest}
\usepackage{xcolor}
\usetikzlibrary{angles}
\definecolor{drawColor}{RGB}{128 128 128}

%---Define the style of the tree------------------------------------------------
\forestset{
	featureDiagram/.style={
		for tree={
			text depth = 0,
			parent anchor = east,
			child anchor = west,
			draw = drawColor,
			edge = {draw=drawColor},
			grow = east,
			l sep = 10mm,
			s sep = 10mm,
		}
	},
	/tikz/abstract/.style={
		fill = blue!85!cyan!5,
		draw = drawColor
	},
	/tikz/concrete/.style={
		fill = blue!85!cyan!20,
		draw = drawColor
	}
}
%-------------------------------------------------------------------------------

\begin{document}
\begin{forest}
    featureDiagram
    [專案名稱
       [功能1,abstract]
       [功能2,concrete]
    ]	
    \matrix [draw=drawColor,anchor=north west] at (current bounding box.north east) {
        \node [label=center:\underline{分類:}] {}; \\
        \node [abstract,label=right:Abstract Feature] {}; \\
        \node [concrete,label=right:Concrete Feature] {}; \\
    };
    \end{forest}
\end{document}
```