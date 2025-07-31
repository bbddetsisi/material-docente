\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{db-exam}[2025/06/08 Examen de bases de datos]

\LoadClassWithOptions{exam}

\RequirePackage{hyperref}
\RequirePackage{kvoptions}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Opciones de la clase
%
\SetupKeyvalOptions{family=@bbdd, prefix=@bbdd@}

% Parámetros de configuración de la clase
\DeclareStringOption{convocatoria}
\DeclareStringOption{curso}
\DeclareStringOption{titulacion}
\ProcessKeyvalOptions*

% Variables relacionadas con la convocatoria (arg. `convocatoria`)
\newcommand{\convocatoria}{}
\ifthenelse{\equal{\@bbdd@convocatoria}{ord}}{%
    \renewcommand{\convocatoria}{Convocatoria ordinaria}%
}{%
\ifthenelse{\equal{\@bbdd@convocatoria}{ext}}{%
    \renewcommand{\convocatoria}{Convocatoria extraordinaria}%
}{%
\ifthenelse{\equal{\reporttype}{}}{%
    \PackageError{db-exam}{Conv}{Falta el parámetro 'convocatoria'}%
}{}}}

% Variables relacionadas con el curso (arg. `curso`)
\newcommand{\curso}{}
\ifthenelse{\equal{\@bbdd@curso}{}}{%
    \PackageError{db-exam}{Curso}{Falta el parámetro 'curso'}%
}{%
    \renewcommand{\curso}{\@bbdd@curso}%
}

% Variables relacionadas con la titulacion (arg. `titulacion`)
\newcommand{\titulacion}{}
\ifthenelse{\equal{\@bbdd@titulacion}{CD}}{%
    \renewcommand{\titulacion}{Bases de Datos I}%
}{%
\ifthenelse{\equal{\@bbdd@titulacion}{NoCD}}{
    \renewcommand{\titulacion}{Bases de Datos}
{
\ifthenelse{\equal{\reporttype}{}}{
    \PackageError{db-exam}{Tit}{Falta el parámetro 'titulacion'}
}
{}}}}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage[T1]{fontenc}  % Font (output) encodings
\RequirePackage[spanish]{babel}  % Spanish-specific commands
\RequirePackage{amsmath}
\RequirePackage{csquotes}
\RequirePackage[type={CC},modifier={by-sa},version={4.0}]{doclicense}
%\RequirePackage{multirow}
%\RequirePackage{graphicx}
\RequirePackage{xcolor}
\RequirePackage{listings}

\AtBeginDocument{%
    \pagestyle{headandfoot}
    \runningheadrule
    \header{\textbf{Nombre y apellidos:}}{}{\titulacion\\\convocatoria\\Curso \curso}
    \runningfootrule
    \footer{\doclicenseIcon}{}{Página\,\thepage\,de\,\numpages}
    
    \firstpageheadrule
    \firstpagefootrule

    \begin{center}\textbf{Normativa de examen}\end{center}
    \begin{itemize}
        \item No se permite el uso de ningún dispositivo electrónico, así como libros ni apuntes.
        \item Cada estudiante podrá disponer de un folio tamaño A4 con las anotaciones que considere oportunas para desarrollar su examen. El folio podrá contener texto por ambas caras.
        \item Durante el examen, los profesores podrán solicitar acreditar la identidad de los participantes en el mismo. Deberá tener en todo momento su documento nacional de identidad, permiso de residencia o carné de estudiante visible sobre la mesa.
        \item Deberá escribir su nombre y apellidos, con bolígrafo, en todas las hojas de las que consta el examen.
        \item No se permite abandonar el aula de examen durante los primeros 20 minutos. Transcurrido este tiempo, no se permitirá entrar al examen.
        \item El examen tiene una duración máxima de \textbf{2.5 horas}. 
        \item Justifique sus respuestas lo mejor posible indicando, si fuese necesario, los pasos realizados.
        \item Las calificaciones provisionales serán publicadas en el aula virtual de la asignatura dentro de los 15 días naturales desde la fecha de realización del examen, publicándose ahí la fecha para su revisión.
    \end{itemize}
    \newpage
}
% Definición de colores
\definecolor{keywordcolor}{rgb}{0.1,0.1,0.8} % Azul para palabras clave
\definecolor{stringcolor}{rgb}{0.8,0.1,0.1}  % Rojo para cadenas
\definecolor{commentcolor}{rgb}{0.1,0.6,0.1} % Verde para comentarios

% Configuración de listings
\lstdefinestyle{mysqlstyle}{
  basicstyle=\ttfamily\footnotesize,          % Estilo básico
  keywordstyle=\color{keywordcolor}\bfseries, % Estilo para palabras clave
  commentstyle=\color{commentcolor}\itshape,  % Estilo para comentarios
  stringstyle=\color{stringcolor},            % Estilo para cadenas
  showstringspaces=false,                     % No mostrar espacios en cadenas
  tabsize=2,                                  % Tamaño de tabulación
  breaklines=true,                            % Dividir líneas largas
  morestring=[b]",                            % Cadenas con comillas dobles
  morekeywords={SELECT, INSERT, UPDATE, DELETE, FROM, WHERE, JOIN, INNER, LEFT, RIGHT, ON, GROUP, BY, ORDER, ASC, DESC, CREATE, TABLE, DROP, ALTER, DATABASE, USE, INDEX, INTO, VALUES, SET, IF, EXISTS, NOT, NULL, AND, HAVING, COUNT, DISTINCT, LIKE, BEFORE, FOR, EACH, ROW, DECLARE, IF, SIGNAL, OPEN, CURSOR, FOUND, USER, TO, IDENTIFIED} % Palabras clave SQL
}
\lstset{literate=
  {á}{{\'a}}1 {é}{{\'e}}1 {í}{{\'i}}1 {ó}{{\'o}}1 {ú}{{\'u}}1
  {Á}{{\'A}}1 {É}{{\'E}}1 {Í}{{\'I}}1 {Ó}{{\'O}}1 {Ú}{{\'U}}1
  {à}{{\`a}}1 {è}{{\`e}}1 {ì}{{\`i}}1 {ò}{{\`o}}1 {ù}{{\`u}}1
  {À}{{\`A}}1 {È}{{\'E}}1 {Ì}{{\`I}}1 {Ò}{{\`O}}1 {Ù}{{\`U}}1
  {ä}{{\"a}}1 {ë}{{\"e}}1 {ï}{{\"i}}1 {ö}{{\"o}}1 {ü}{{\"u}}1
  {Ä}{{\"A}}1 {Ë}{{\"E}}1 {Ï}{{\"I}}1 {Ö}{{\"O}}1 {Ü}{{\"U}}1
  {â}{{\^a}}1 {ê}{{\^e}}1 {î}{{\^i}}1 {ô}{{\^o}}1 {û}{{\^u}}1
  {Â}{{\^A}}1 {Ê}{{\^E}}1 {Î}{{\^I}}1 {Ô}{{\^O}}1 {Û}{{\^U}}1
  {ã}{{\~a}}1 {ẽ}{{\~e}}1 {ĩ}{{\~i}}1 {õ}{{\~o}}1 {ũ}{{\~u}}1
  {Ã}{{\~A}}1 {Ẽ}{{\~E}}1 {Ĩ}{{\~I}}1 {Õ}{{\~O}}1 {Ũ}{{\~U}}1
  {œ}{{\oe}}1 {Œ}{{\OE}}1 {æ}{{\ae}}1 {Æ}{{\AE}}1 {ß}{{\ss}}1
  {ű}{{\H{u}}}1 {Ű}{{\H{U}}}1 {ő}{{\H{o}}}1 {Ő}{{\H{O}}}1
  {ç}{{\c c}}1 {Ç}{{\c C}}1 {ø}{{\o}}1 {å}{{\r a}}1 {Å}{{\r A}}1
  {€}{{\euro}}1 {£}{{\pounds}}1 {«}{{\guillemotleft}}1
  {»}{{\guillemotright}}1 {ñ}{{\~n}}1 {Ñ}{{\~N}}1 {¿}{{?`}}1 {¡}{{!`}}1,
}

% Usar el estilo
\lstset{style=mysqlstyle}

% Términos en castellano
\pointpoints{Punto}{Puntos}
\renewcommand{\solutiontitle}{\noindent\textbf{Solución propuesta:}\enspace\\}
\renewcommand{\questionlabel}{\textbf{EJERCICIO \thequestion.}}