\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{db-practice}[2024/11/25 Ejecicios de Bases de Datos]

\LoadClass[a4paper]{article}

\RequirePackage{hyperref}
\RequirePackage[spanish,es-tabla,activeacute]{babel}
\RequirePackage[utf8]{inputenc}
\RequirePackage{geometry}
%\RequirePackage{lmodern,textcomp}
\RequirePackage{graphicx}
\RequirePackage{url}
\RequirePackage{fancyhdr}
\RequirePackage{scrextend}
\RequirePackage{float}
%\RequirePackage{mathtools}
\RequirePackage{listings}
\RequirePackage{xcolor}
\RequirePackage[type={CC},modifier={by-nc-sa},version={3.0}]{doclicense}

% Configurar márgenes
\geometry{top=2.5cm, bottom=3.5cm, left=2.5cm, right=2.5cm}

% Configurar espacio entre párrafos
\setlength{\parskip}{0.5\baselineskip} % Espacio entre párrafos de 1.1 líneas
\setlength{\parindent}{0pt} % Opcional: sin sangría en los párrafos

% Configuración de cabecera y pie de página
\newcommand{\docTitle}{}
\renewcommand{\title}[1]{\gdef\docTitle{#1}}

\pagestyle{fancy}
\fancyhf{} 
\setlength\headheight{50pt}
\fancyhead[L]{\includegraphics[height=1.5cm]{logos/upm_logo}} 
\fancyhead[C]{%
    Bases de Datos \\[0.5\baselineskip] 
    \docTitle \\[-0.5\baselineskip]
} 
\fancyhead[R]{\includegraphics[height=1.5cm]{logos/etsisi_logo}}
\fancyfoot[C]{Página \thepage}

% Configuracion de listings para SQL
\definecolor{keywordcolor}{rgb}{0.1,0.1,0.8} % Azul para palabras clave
\definecolor{stringcolor}{rgb}{0.8,0.1,0.1}  % Rojo para cadenas
\definecolor{commentcolor}{rgb}{0.1,0.6,0.1} % Verde para comentarios

\lstdefinestyle{mysqlstyle}{
  basicstyle=\ttfamily\footnotesize,          % Estilo básico
  keywordstyle=\color{keywordcolor}\bfseries, % Estilo para palabras clave
  commentstyle=\color{commentcolor}\itshape,  % Estilo para comentarios
  stringstyle=\color{stringcolor},            % Estilo para cadenas
  showstringspaces=false,                     % No mostrar espacios en cadenas
  tabsize=2,                                  % Tamaño de tabulación
  breaklines=true,                            % Dividir líneas largas
  morestring=[b]",                            % Cadenas con comillas dobles
  literate={ñ}{{\~n}}1,                       % Permite el carácter "ñ"
  morekeywords={SELECT, INSERT, UPDATE, DELETE, FROM, WHERE, JOIN, INNER, LEFT, RIGHT, ON, GROUP, BY, ORDER, ASC, DESC, CREATE, TABLE, DROP, ALTER, DATABASE, USE, INDEX, INTO, VALUES, SET, IF, EXISTS, NOT, NULL, AND, HAVING, COUNT, DISTINCT, LIKE, USER, IDENTIFIED, PRIVILEGE, WITH, SHOW, GRANTS, FOR, TO} % Palabras clave SQL
}

\lstset{style=mysqlstyle}

% Añadir texto antes de finalizar el documento
\let\oldenddocument\enddocument
\renewcommand{\enddocument}{%
    \vspace{1em}
    \hrule
    \doclicenseThis
    \oldenddocument
}

