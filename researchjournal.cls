\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{researchjournal}[2023/02/22 Research Journal]

%% OPTIONS AND LOAD CLASS
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{memoir}}
\ProcessOptions\relax
\LoadClass{memoir}

%% PACKAGES

\RequirePackage[svgnames]{xcolor}

%% Encoding
\RequirePackage{ifxetex,ifluatex} 
\newif\ifxetexorluatex %https://tex.stackexchange.com/a/47579/144146
\ifxetex
  \xetexorluatextrue
\else
  \ifluatex
    \xetexorluatextrue
  \else
    \xetexorluatexfalse
  \fi
\fi

\ifxetexorluatex 
    \RequirePackage{fontspec}
    \defaultfontfeatures{Scale=MatchLowercase, Ligatures=TeX}
    \setsansfont{Fira Sans}
    \setmonofont{Fira Mono}
    \renewcommand{\familydefault}{\sfdefault}
\else
    \RequirePackage[utf8]{inputenc}
    \RequirePackage[T1]{fontenc}
    \RequirePackage[sfdefault,lf]{FiraSans}
    \RequirePackage{FiraMono}
\fi

%% Fonts and Typography
\RequirePackage{microtype} % Improved tipography
\RequirePackage[lowtilde]{url} % Manage typed urls

%% Mathematics
\RequirePackage{amsmath,amssymb}
\ifxetexorluatex
    \let\STAR\bigstar %store's amssymb \bigstar command for later use
    \RequirePackage{unicode-math}
    \setmathfont{Fira Math}
    \AtBeginDocument{\let\bigstar\STAR%
    \let\STAR\relax}
\fi

%% Language Support
\RequirePackage[english]{babel}
\RequirePackage{csquotes}

%% Graphics
\RequirePackage{tikz} % Create figures (used for drawing decorations)
\RequirePackage{graphicx} % Import figures

\RequirePackage{silence}
\WarningFilter[pagecolorcrop]{pagecolor}{\nopagecolor does not work with} %nopagecolor doesn't work with memoir's crop functionality, and hence the background color is not 'none', but 'white'. We want to suppress pagecolor's warning

\ActivateWarningFilters[pagecolorcrop]
\RequirePackage[nopagecolor=white]{pagecolor} %page color (used on cover)
\DeactivateWarningFilters[pagecolorcrop]

%% Standard Colors (can be changed on main.tex)
\definecolor{ChapterBackground}{HTML}{101010} %colors to use on chapters
\definecolor{ChapterForeground}{HTML}{e93820} %colors to use on chapters
\definecolor{DayColor}{HTML}{df2d16} %colors to use on newdays and daybibs
\definecolor{CoverBackground}{HTML}{101010} %cover background
\definecolor{CoverForeground}{HTML}{e93820} %cover letters
\definecolor{LinkColor}{HTML}{eb5a00} %color for links

%% Miscelaneous
\RequirePackage{xparse} % Updated command-creation facilities 
\RequirePackage{xspace} % Better spacing
\RequirePackage{calc} % arithmetic with lengths
\RequirePackage{pgfcalendar} % calendar and date features
\RequirePackage{afterpage} % used to restore pagecolor after the cover

%% Bibliography (highly customized)
\RequirePackage[backend    = biber, 
                style      = ext-authoryear-comp,
                sorting    = nyvt, 
                backref    = false,
                articlein  = false,
                uniquename = false,
                doi        = true, 
                dashed     = true]{biblatex} %Custom bibliography
\renewcommand*{\bibnamedash}{\rule[.4ex]{3em}{.5pt} \,}
\addbibresource{bib.bib} %Load references
\DeclareFieldFormat[article,periodical]{volume}{\mkbibbold{#1}}

%% Cross references
\RequirePackage{varioref}
\RequirePackage[colorlinks  = true, 
    urlcolor        = LinkColor, 
    anchorcolor     = LinkColor, 
    citecolor       = LinkColor, 
    filecolor       = LinkColor, 
    linkcolor       = LinkColor, 
    menucolor       = LinkColor, 
    linktocpage     = true, 
    bookmarks       = true,
    pdfusetitle]{hyperref} % Hyperlinks in pdf
\RequirePackage{memhfixc} % Memoir + Hyperref
\RequirePackage[capitalize]{cleveref} % Clever references

%% FRONTMATTER
\def\@author{\@empty}
\renewcommand{\author}[1]{\gdef\@author{#1}\gdef\theauthor{\@author}}

%% Logo
\def\@logo{\@empty}
\providecommand{\logo}[1]{\gdef\@logo{#1}}
\renewcommand{\logo}[1]{\gdef\@logo{#1}}

%% Maketitle
\renewcommand{\maketitle}{
%% Front Cover
\thispagestyle{empty}
\renewcommand\thepage{C}
\colorlet{saved}{.}
\newpagecolor{CoverBackground}
\color{CoverForeground}
\newcommand\restorecolor{\color{saved}}
\afterpage{\restorepagecolor\aftergroup\restorecolor}
\begin{center}
    \null%
    
    \vspace{5ex}%
    
    {\if!\@logo!%
        \null\vspace{10ex}%
    \else%
        \@logo%
    \fi}%
    
    \vspace{15ex}\par%
    
    {\sffamily\bfseries\Huge%
    Research Journal%
    \par}%

    \vfill%

    {\if!\@author!%
    \else%
        \Large\@author%
    \fi}%
\end{center}

\mainmatter
}
\AtBeginDocument{\maketitle}

%% MAINMATTER
%% Chapter Style
\renewcommand*{\colorchapnum}{\color{ChapterForeground}}
\renewcommand*{\colorchaptitle}{\color{ChapterBackground}}

\newlength{\barextralength} %extra length for bars, it will adapt to the chapter number
\newlength{\fillinglength} %approximate length of the bar
\newlength{\pushchaplength}%length used to push the bar to the corner of the page

\makechapterstyle{veelo2}{% chaper style based on veelo
\setlength{\afterchapskip}{40pt}
\renewcommand*{\chapterheadstart}{}
\renewcommand*{\afterchapternum}{}

\setlength{\beforechapskip}{18mm} %bar height

\setlength{\midchapskip}{\spinemargin} %bar fixed width

\renewcommand*{\chapnamefont}{%
    \setlength{\barextralength}{\widthof{\chapnumfont\thechapter}*\ratio{\beforechapskip}{\heightof{\chapnumfont\thechapter}}}% extra length for bar is the size of the number inside it
    \setlength{\fillinglength}{\barextralength+0.4\beforechapskip}% size of the number inside bar plus round section
    \setlength{\pushchaplength}{\textwidth-\fillinglength}% length to be pushed to get the bar to the right place
    \normalfont\LARGE\null\hspace{\pushchaplength}%
}

\renewcommand*{\chapnumfont}{\normalfont\HUGE\colorchapnum}

\renewcommand*{\chaptitlefont}{\normalfont\HUGE\bfseries\colorchaptitle\raggedleft}

\renewcommand*{\printchaptername}{%
\chapnamefont}

\renewcommand*{\chapternamenum}{}

\renewcommand*{\printchapternum}{%
\makebox[0pt][l]{%
\begin{tikzpicture}
    \filldraw[ChapterBackground] (\barextralength,0pt) -- (-\midchapskip,0pt) arc[start angle=270, end angle=90, radius=0.75*\beforechapskip] -- (\barextralength, 1.5*\beforechapskip); %draw bar
    \node[name=B,anchor=west] at (-\midchapskip-0.35*\beforechapskip, 0.75*\beforechapskip) {\resizebox{!}{\beforechapskip}{\chapnumfont\thechapter}}; % write number inside bar
\end{tikzpicture}
}\par}%
\makeoddfoot{plain}{}{}{\thepage}}

\chapterstyle{veelo2}

%% Lower Level Headings
\newcommand{\sectionheadstyle}[1]{%
\setlength{\barextralength}{\widthof{\Large\bfseries\colorchapnum#1}}
\addtolength{\barextralength}{\spinemargin}%
\noindent\hspace{-\spinemargin}\hspace{-2.5ex}\makebox[0pt][l]{%
\begin{tikzpicture}
    \filldraw[ChapterBackground] (-2.5ex,0pt) -- (\barextralength,0pt) arc[start angle=-90, end angle=90, radius=2.5ex] -- (-2.5ex, 5ex); %draw bar
    \node[name=B,anchor=west] at (\spinemargin, 2.5ex) {\Large\bfseries\colorchapnum%
    #1}; % write title
\end{tikzpicture}
}%\raggedright
}

\setsecheadstyle{\sectionheadstyle}
\setsechook{
    \setsecnumformat{}
}

\setsubsecheadstyle{\bfseries\color{DayColor}\raggedright}

%% Journal Macros

\newcounter{JulianDay}
\newcounter{LastJulianDay}
    \setcounter{LastJulianDay}{1}
\newcount\Weekday
\newcounter{Day}
\newcounter{Month}
\newcounter{CurrentMonth}
    \setcounter{CurrentMonth}{1}
\newcounter{LastMonth}
    \setcounter{LastMonth}{0}
\newcounter{Year}
\newcounter{CurrentYear}
    \setcounter{CurrentYear}{1}
\newcounter{LastYear}
    \setcounter{LastYear}{0}

\newcommand\twodigits[1]{% converts numbers to two-digit format (as opposed to one-digit)
   \ifnum#1<10 0\number#1 \else #1\fi 
}

\NewDocumentCommand{\newday}{s m}{% takes an ISO date as argument and formats a subsection accordingly. The starred version adds a star to the formatting
    \pgfcalendardatetojulian{#2}{\c@JulianDay}%
    \pgfcalendarjuliantodate{\c@JulianDay}{\theYear}{\theMonth}{\theDay}%
    \pgfcalendarjuliantoweekday{\c@JulianDay}{\Weekday}%
    \setcounter{CurrentMonth}{\theMonth}
    \setcounter{CurrentYear}{\theYear}
    \ifnum\value{LastYear}<\value{CurrentYear}
        \setcounter{chapter}{\theYear-1}
        \chapter[\theYear]{}
        \setcounter{LastMonth}{0}
    \fi
    \ifnum\value{LastMonth}<\value{CurrentMonth}
        \section{\pgfcalendarmonthname{\theMonth}}
    \fi
    \ifnum\value{LastJulianDay}<\value{JulianDay}
    \else\ifnum\value{LastJulianDay}=\value{JulianDay}
        \ClassWarning{researchjournal}{repeated day}
        \else
            \ifnum\value{LastJulianDay}>\value{JulianDay}
            \ClassWarning{researchjournal}{entry out of chronological order}
            \fi
        \fi
    \fi
    \subsection{\texorpdfstring{\IfBooleanT{#1}{\textcolor{ChapterForeground}{\(\bigstar\)}} \pgfcalendarmonthshortname{\theMonth}. \twodigits{\theDay}, \theYear {} --- \pgfcalendarweekdayname{\Weekday}}{\pgfcalendarmonthshortname{\theMonth}. \twodigits{\theDay}, \theYear {} --- \pgfcalendarweekdayname{\Weekday}}}
    \markboth{\textsc{\pgfcalendarmonthname{\theMonth} \(|\) \twodigits{\theDay}}}{\textsc{\pgfcalendarmonthname{\theMonth} \(|\) \twodigits{\theDay}}}
    \setcounter{LastMonth}{\theMonth}
    \setcounter{LastYear}{\theYear}
    \setcounter{LastJulianDay}{\c@JulianDay}
}

\newcommand{\daybib}{%
    {%\bfseries%
    \newline%
    \textcolor{DayColor}{References:}%
    }
}

\AtEndDocument{%
    \clearpage
    \pagestyle{fancyrefs} % clears the middle part of the headers from here on (no year to specify)
    \markboth{\textsc{References}}{\textsc{References}} % ensures headers are working as intended during reference chapter
    \printbibliography[heading=bibintoc, title=References]
} % prints references

%% Headers and Footers
\copypagestyle{fancy}{ruled}
\makepsmarks{fancy}{%
    \nouppercaseheads
    \clearmark{chapter}
    \clearmark{section}
}
\makeevenhead{fancy}{\rightmark}{\thechapter}{\leftmark}
\makeoddhead{fancy}{\rightmark}{\thechapter}{\leftmark}
\makeevenfoot{fancy}{}{}{\thepage}
\makeoddfoot{fancy}{}{}{\thepage}
\pagestyle{fancy}

\copypagestyle{fancyrefs}{fancy}
\makeevenhead{fancyrefs}{\leftmark}{}{\leftmark}
\makeoddhead{fancyrefs}{\leftmark}{}{\leftmark}

%% MISC
%% Page Layout
\settypeblocksize{*}{0.7071\stockwidth}{1.4142}
\setlrmargins{*}{*}{1}
\setulmargins{*}{*}{1}
\checkandfixthelayout[nearest]