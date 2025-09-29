\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{db-practice}[2024/11/25 Ejecicios de Bases de Datos]

\LoadClass[a4paper]{article}

\RequirePackage[hidelinks]{hyperref}
\RequirePackage[spanish,es-tabla,activeacute]{babel}
\RequirePackage[utf8]{inputenc}
\RequirePackage{geometry}
\RequirePackage{graphicx}
\RequirePackage{url}
\RequirePackage{fancyhdr}
\RequirePackage{scrextend}
\RequirePackage{float}
\RequirePackage{upquote}
\RequirePackage{listings}
\RequirePackage{xcolor}
\RequirePackage{tikz}
\RequirePackage{helvet}
\RequirePackage{etoolbox}
\RequirePackage{amsmath}
\RequirePackage[type={CC},modifier={by-nc-sa},version={4.0}]{doclicense}

% Configurar márgenes
\geometry{top=2.5cm, bottom=2.7cm, left=2.5cm, right=2.5cm}

% Configurar sans-serif como fuente predeterminada
\renewcommand{\familydefault}{\sfdefault} 

% Configurar espacio entre párrafos
\setlength{\parskip}{0.5\baselineskip} % Espacio entre párrafos de 1.1 líneas
\setlength{\parindent}{0pt} % Opcional: sin sangría en los párrafos

% Colores
\definecolor{background-upm}{RGB}{1, 73, 148}
\definecolor{dark-gray-upm}{RGB}{112, 111, 111}
\definecolor{light-gray-upm}{RGB}{227, 227, 227}
\definecolor{blue-upm}{RGB}{0, 110, 183}

% Recuperamos el titulo del documento
\newcommand{\docTitle}{}
\renewcommand{\title}[1]{\gdef\docTitle{#1}}

% Configuración de cabecera y pie de página
\pagestyle{fancy}
\fancyhf{} 
\renewcommand{\headrulewidth}{0pt}
\renewcommand{\footrulewidth}{0pt}
\setlength\headheight{50pt}
\fancyhead[L]{\includegraphics[height=1.5cm]{logos/upm_logo}} 
\fancyhead[C]{%
    \color{blue-upm}Bases de Datos \\[0.5\baselineskip] 
    \color{dark-gray-upm}\docTitle \\[-0.5\baselineskip]
} 
\fancyhead[R]{\includegraphics[height=1.5cm]{logos/etsisi_logo}}
\fancyfoot[C]{%
  \colorbox{dark-gray-upm}{%
    \parbox[c][1.5em][c]{2em}{%
      \centering\color{white}\thepage}%
  }%
}

% Redefinir \maketitle
\renewcommand{\maketitle}{
    \begin{titlepage}
        \begin{tikzpicture}[remember picture, overlay]
            \fill[background-upm] (current page.south west) rectangle (current page.north east);
            \node[align=center, text=white, yshift=0.66\paperheight] at (current page.south) {
              {\bfseries\Huge Bases de datos} \\[3em]
              {\LARGE \docTitle}
            };
            \node[anchor=south east, xshift=22cm, yshift=-39.7cm] at (current page.south east) {
              \includegraphics[width=50cm]{logos/escudo-upm.pdf};
            };
        \end{tikzpicture}
    \end{titlepage}
}

% Definir estilo sin números de página
\fancypagestyle{sectionpage}{
    \fancyhf{} % Limpiar encabezados y pies
    
}

% Redefinir el comando \section
\renewcommand{\section}[1]{
    \setcounter{subsection}{0}
    \clearpage
    \thispagestyle{sectionpage}
    \begin{tikzpicture}[remember picture, overlay]
        \fill[light-gray-upm] (current page.south west) rectangle (current page.north east);
        \node[align=center, text=dark-gray-upm, yshift=0.66\paperheight] at (current page.south) {\Huge\bfseries #1};
        \ifstrequal{#1}{Soluciones}{%
            \node[align=justify, text=dark-gray-upm, yshift=0.58\paperheight, text width=.8\textwidth] at (current page.south) {
              \parbox{\textwidth}{\setlength{\baselineskip}{1.75em} % Establece interlineado de 1.5
                Las soluciones que se presentan a continuación pueden diferir de las discutidas en clase, ya que están basadas en las decisiones y criterios aplicados por el profesor al momento de su elaboración. Es importante señalar que estas soluciones podrían contener errores tipográficos o imprecisiones que no afectan su propósito principal.
              }
            };
        }{}
    \end{tikzpicture}
    \clearpage % Dejar la siguiente página vacía para el contenido
}

% Eliminar el núermo de sección de la subsección
\renewcommand{\thesubsection}{\arabic{subsection}}

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
  breaklines=true                             % Dividir líneas largas
}

\lstdefinelanguage{SQL}{
  morekeywords={RETURN, SELECT, INSERT, UPDATE, DELETE, FROM, WHERE, JOIN, INNER, LEFT, RIGHT, ON, GROUP, BY, ORDER, ASC, DESC, CREATE, TABLE, DROP, ALTER, DATABASE, USE, INDEX, INTO, VALUES, SET, IF, EXISTS, NOT, NULL, AND, HAVING, COUNT, DISTINCT, LIKE, IN, START, TRANSACTION, COMMIT, ROLLBACK, VISIBLE, USER, IDENTIFIED, GRANT, PRIVILEGE, TO, WITH, OPTION, REVOKE, SHOW, GRANTS, FOR, PROCEDURE, BEGIN, END, AS, END\$\$, ELSE, THEN, ADD, COLUMN, DECLARE, DEFAULT, INTEGER, FETCH, CLOSE, LOOP, CURSOR, FOUND, OPEN, OUT, TEXT, VARCHAR, FUNCTION, RETURNS, DECIMAL, DETERMINISTIC, SIGNAL, BEFORE, AFTER, EACH, ROW, PRIMARY, KEY, REFERENCES, FOREIGN, CONSTRAINT, OR, LIMIT}, % Palabras clave SQL
  sensitive=false,
  morestring=[b]',                            % Cadenas con comillas simples
  morestring=[b]",                            % Cadenas con comillas dobles
  literate={ñ}{{\~n}}1                        % Permite el carácter "ñ"
}

\lstset{style=mysqlstyle}

% Añadir texto antes de finalizar el documento
\let\oldenddocument\enddocument
\renewcommand{\enddocument}{%
    \newpage
    \thispagestyle{sectionpage}
    \begin{tikzpicture}[remember picture, overlay]
        \fill[background-upm] (current page.south west) rectangle (current page.north east);
    \end{tikzpicture}
    \vspace{22cm}
    \color{white}\doclicenseThis
    \oldenddocument
}

