��   �   0   p  �   �     �     �  �      ,  �   -  7  �  �  7  -      F   .     u     �  7   �  �   �  �   �  �   
  �   �  �  �  H   J     �  E     �   Y    �  >     9   E  �     �     �   �  �     �   �  �   ~  l   <     �     �     �     �          /     I     c  z   }     �           ,   .   >      m      �      �      �   !   �   !   �   '   �      !     ;!     [!  *   z!  /   �!  %   �!     �!  /   "  ,   ="     j"  4   �"     �"     �"     �"     #      #      =#      ^#  h   #  <   �#     %$  :   8$  $   s$     �$  2   �$     �$  $   %  /   (%  I   X%     �%  3   �%  =   �%  d   (&      �&  O   �&  .   �&  /   -'     ]'  A   x'  )   �'     �'     �'  8   (     ?(     Z(  (   o(  I   �(  !   �(  '   )  '   ,)  9   T)     �)     �)  0   �)     �)  <   �)  -   *  @   M*  /   �*  7   �*  D   �*  &   ;+  '   b+     �+  %   �+     �+     �+  
   �+  
   �+  
   �+  
   �+  
   
,  	   ,  	   ,  	   ),  	   3,  	   =,  	   G,  	   Q,  "   [,  *   ~,     �,  A   �,  Q   �,  *   Q-  @   |-  !   �-     �-  �  �-  �   �/  L  �0  �  �4  2   �6  ^   �6     U7     t7  :   �7  �   �7  �   p8  =  �8  �   ;:  �  ;  F   �<  �   (=  D   �=  �   �=  +  �>  B   �?  =   @  �   \@  �   %A  �   �A  �   /B  �   .C  �   D  m   �D     QE     mE     �E     �E     �E     �E     �E     F  w   5F     �F     �F     �F  2    G     3G     EG     [G     `G  0   ~G  6   �G  1   �G  &   H  *   ?H  "   jH  3   �H  >   �H  5    I     6I  <   KI  >   �I     �I  E   �I  )   'J  *   QJ     |J  "   �J  #   �J  /   �J  *   K  {   :K  E   �K     �K  J   L  0   aL     �L  C   �L  (   �L  /   M  ;   MM  V   �M     �M  6   �M  D   3N  {   xN  +   �N  i    O  9   �O  ;   �O  !    P  F   "P  ,   iP     �P     �P  B   �P      Q     &Q  .   ;Q  P   jQ  &   �Q  -   �Q  -   R  T   >R  *   �R     �R  I   �R     S  @   S  g   TS  A   �S  .   �S  4   -T  L   bT  '   �T  .   �T     U  .   U     =U     XU  	   kU  	   uU  	   U  	   �U  	   �U     �U     �U     �U     �U     �U     �U     �U  $   �U  5   V     7V  Z   NV  J   �V  7   �V  B   ,W  +   oW     �W     \   ;       I   G       z   �           �          �   /              S   s      e          ]              3   6       o       "   b       7   ^   '       1   a          [       +   Y   �   w   _          H   !   �       h            X       $           q      .                          v          #   c       ?          C      i           *   {       P       M   @   �       (   =       >   
       �       J   r   d   E             �       :              ,   y   l   j   <   T   O   0      W   Z       k   K   &           D          B   m      p   9      n      V   u   t   5   x       	      L         �   g   2           `   )   F   U       4   |   }   ~          R   %       f               N   -   8              A   Q         �W     �W  �  �  �    �W  2          �����W  0               ����X  J          ����`X  :               ���� 
  --delta[=OPTS]      Delta filter; valid OPTS (valid values; default):
                        dist=NUM   distance between bytes being subtracted
                                   from each other (1-256; 1) 
  --lzma1[=OPTS]      LZMA1 or LZMA2; OPTS is a comma-separated list of zero or
  --lzma2[=OPTS]      more of the following options (valid values; default):
                        preset=PRE reset options to a preset (0-9[e])
                        dict=NUM   dictionary size (4KiB - 1536MiB; 8MiB)
                        lc=NUM     number of literal context bits (0-4; 3)
                        lp=NUM     number of literal position bits (0-4; 0)
                        pb=NUM     number of position bits (0-4; 2)
                        mode=MODE  compression mode (fast, normal; normal)
                        nice=NUM   nice length of a match (2-273; 64)
                        mf=NAME    match finder (hc3, hc4, bt2, bt3, bt4; bt4)
                        depth=NUM  maximum search depth; 0=automatic (default) 
  --x86[=OPTS]        x86 BCJ filter (32-bit and 64-bit)
  --powerpc[=OPTS]    PowerPC BCJ filter (big endian only)
  --ia64[=OPTS]       IA-64 (Itanium) BCJ filter
  --arm[=OPTS]        ARM BCJ filter (little endian only)
  --armthumb[=OPTS]   ARM-Thumb BCJ filter (little endian only)
  --sparc[=OPTS]      SPARC BCJ filter
                      Valid OPTS for all BCJ filters:
                        start=NUM  start offset for conversions (default=0) 
 Basic file format and compression options:
 
 Custom filter chain for compression (alternative for using presets): 
 Operation modifiers:
 
 Other options:
 
With no FILE, or when FILE is -, read standard input.
       --block-size=SIZE
                      when compressing to the .xz format, start a new block
                      after every SIZE bytes of input; 0=disabled (default)       --info-memory   display the total amount of RAM and the currently active
                      memory usage limits, and exit       --memlimit-compress=LIMIT
      --memlimit-decompress=LIMIT
  -M, --memlimit=LIMIT
                      set memory usage limit for compression, decompression,
                      or both; LIMIT is in bytes, % of RAM, or 0 for defaults       --no-adjust     if compression settings exceed the memory usage limit,
                      give an error instead of adjusting the settings downwards       --no-sparse     do not create sparse files when decompressing
  -S, --suffix=.SUF   use the suffix `.SUF' on compressed files
      --files[=FILE]  read filenames to process from FILE; if FILE is
                      omitted, filenames are read from the standard input;
                      filenames must be terminated with the newline character
      --files0[=FILE] like --files but use the null character as terminator       --robot         use machine-parsable messages (useful for scripts)       --single-stream decompress only the first stream, and silently
                      ignore possible remaining input data       CheckVal %*s Header  Flags        CompSize    MemUsage  Filters   -0 ... -9           compression preset; default is 6; take compressor *and*
                      decompressor memory usage into account before using 7-9!   -F, --format=FMT    file format to encode or decode; possible values are
                      `auto' (default), `xz', `lzma', and `raw'
  -C, --check=CHECK   integrity check type: `none' (use with caution),
                      `crc32', `crc64' (default), or `sha256'   -Q, --no-warn       make warnings not affect the exit status   -V, --version       display the version number and exit   -e, --extreme       try to improve compression ratio by using more CPU time;
                      does not affect decompressor memory requirements   -h, --help          display the short help (lists only the basic options)
  -H, --long-help     display this long help and exit   -h, --help          display this short help and exit
  -H, --long-help     display the long help (lists also the advanced options)   -k, --keep          keep (don't delete) input files
  -f, --force         force overwrite of output file and (de)compress links
  -c, --stdout        write to standard output and don't delete input files   -q, --quiet         suppress warnings; specify twice to suppress errors too
  -v, --verbose       be verbose; specify twice for even more verbose   -z, --compress      force compression
  -d, --decompress    force decompression
  -t, --test          test compressed file integrity
  -l, --list          list information about .xz files   Blocks:
    Stream     Block      CompOffset    UncompOffset       TotalSize      UncompSize  Ratio  Check   Blocks:             %s
   Check:              %s
   Compressed size:    %s
   Memory needed:      %s MiB
   Number of files:    %s
   Ratio:              %s
   Sizes in headers:   %s
   Stream padding:     %s
   Streams:
    Stream    Blocks      CompOffset    UncompOffset        CompSize      UncompSize  Ratio  Check      Padding   Streams:            %s
   Uncompressed size:  %s
  Operation mode:
 %s MiB of memory is required. The limit is %s. %s file
 %s files
 %s home page: <%s>
 %s:  %s: Cannot remove: %s %s: Cannot set the file group: %s %s: Cannot set the file owner: %s %s: Cannot set the file permissions: %s %s: Closing the file failed: %s %s: Error reading filenames: %s %s: Error seeking the file: %s %s: File already has `%s' suffix, skipping %s: File has setuid or setgid bit set, skipping %s: File has sticky bit set, skipping %s: File is empty %s: File seems to have been moved, not removing %s: Filename has an unknown suffix, skipping %s: Filter chain: %s
 %s: Input file has more than one hard link, skipping %s: Invalid filename suffix %s: Invalid multiplier suffix %s: Invalid option name %s: Invalid option value %s: Is a directory, skipping %s: Is a symbolic link, skipping %s: Not a regular file, skipping %s: Null character found when reading filenames; maybe you meant to use `--files0' instead of `--files'? %s: Options must be `name=value' pairs separated with commas %s: Read error: %s %s: Seeking failed when trying to create a sparse file: %s %s: Too small to be a valid .xz file %s: Unexpected end of file %s: Unexpected end of input when reading filenames %s: Unknown file format type %s: Unsupported integrity check type %s: Value is not a non-negative decimal integer %s: With --format=raw, --suffix=.SUF is required unless writing to stdout %s: Write error: %s --list does not support reading from standard input --list works only on .xz files (--format=xz or --format=auto) Adjusted LZMA%c dictionary size from %s MiB to %s MiB to not exceed the memory usage limit of %s MiB Cannot establish signal handlers Cannot read data from standard input when reading filenames from standard input Compressed data cannot be read from a terminal Compressed data cannot be written to a terminal Compressed data is corrupt Compression and decompression with --robot are not supported yet. Decompression will need %s MiB of memory. Disabled Empty filename, skipping Error restoring the O_APPEND flag to standard output: %s File format not recognized Internal error (bug) LZMA1 cannot be used with the .xz format Mandatory arguments to long options are mandatory for short options too.
 Maximum number of filters is four Memory usage limit for compression:     Memory usage limit for decompression:   Memory usage limit is too low for the given filter setup. Memory usage limit reached No No integrity check; not verifying file integrity None Only one file can be specified with `--files' or `--files0'. Report bugs to <%s> (in English or Finnish).
 Strms  Blocks   Compressed Uncompressed  Ratio  Check   Filename The .lzma format supports only the LZMA1 filter The environment variable %s contains too many arguments The exact options of the presets may vary between software versions. The sum of lc and lp must not exceed 4 Total amount of physical memory (RAM):  Totals: Try `%s --help' for more information. Unexpected end of input Unknown error Unknown-11 Unknown-12 Unknown-13 Unknown-14 Unknown-15 Unknown-2 Unknown-3 Unknown-5 Unknown-6 Unknown-7 Unknown-8 Unknown-9 Unsupported LZMA1/LZMA2 preset: %s Unsupported filter chain or filter options Unsupported options Unsupported type of integrity check; not verifying file integrity Usage: %s [OPTION]... [FILE]...
Compress or decompress FILEs in the .xz format.

 Using a preset in raw mode is discouraged. Valid suffixes are `KiB' (2^10), `MiB' (2^20), and `GiB' (2^30). Writing to standard output failed Yes Project-Id-Version: xz-utils
Report-Msgid-Bugs-To: lasse.collin@tukaani.org
POT-Creation-Date: 2012-11-29 03:17+0000
PO-Revision-Date: 2011-05-27 11:59+0200
Last-Translator: Milo Casagrande <milo@ubuntu.com>
Language-Team: Italian <tp@lists.linux.it>
Language: it
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Launchpad-Export-Date: 2010-08-16 19:16+0000
X-Generator: Launchpad (build Unknown)
Plural-Forms: nplurals=2; plural=(n != 1)
 
  --delta[=OPZ]      Filtro Delta; OPZ valide (valori validi; predefinito):
                      dist=NUM   Distanza tra byte sottratti
                                 gli uni dagli altri (1-256; 1) 
  --lzma1[=OPZ]      LZMA1 o LZMA2; OPZ è un elenco separato da virgole di zero
  --lzma2[=OPZ]      o più delle seguenti opzioni (valori validi; predefinito):
                        preset=NUM Reimposta le opzioni al preset NUM (0-9[e])
                        dict=NUM   Dimensione del dizionario
                                   (4KiB - 1536MiB; 8MiB)
                        lc=NUM     Numero di bit letterali di contesto (0-4; 3)
                        lp=NUM     Numero di bit letterali di posizione (0-4; 0)
                        pb=NUM     Numero di bit di posizione (0-4; 2)
                        mode=MODE  Modalità di compressione
                                   (fast, normal; normal)
                        nice=NUM   Lunghezza valida per una corrispondenza
                                   (2-273; 64)
                        mf=NAME    Strumento per cercare corrispondenze
                                   (hc3, hc4, bt2, bt3, bt4; bt4)
                        depth=NUM  Profondità massima di ricerca; 0=automatica
                                   (predefinito) 
  --x86[=OPZ]        Filtro BCJ x86 (32 e 64 bit)
  --powerpc[=OPZ]    Filtro BCJ PowerPC (solo big endian)
  --ia64[=OPZ]       Filtro BCJ IA-64 (Itanium)
  --arm[=OPZ]        Filtro BCJ ARM (solo little endian)
  --armthumb[=OPZ]   Filtro BCJ ARM-Thumb (solo little endian)
  --sparc[=OPZ]      Filtro BCJ SPARC
                     OPZ valide per tutti i filtri BCJ:
                      start=NUM Offset iniziale per le conversioni
                                (predefinito=0) 
 Formato file di base e opzioni di compressione:
 
 Catena di filtri personalizzati per la compressione (alternative per
 l'utilizzo di preset): 
 Modificatori di operazioni:
 
 Altre opzioni:
 
Senza FILE, o quando FILE è -, legge lo standard input.
       --block-size=DIM 
                      Comprimendo nel formato .zx, comincia un nuovo blocco
                      dopo DIM byte di input; 0=disabilitato (predefinito)       --info-memory   Visualizza la quantità totale di RAM, il limite attuale
                      attivo di utilizzo della memore ed esce       --memlimit-compress=LIMIT
      --memlimit-decompress=LIMIT
  -M, --memlimit=LIMIT
                      Imposta il limite di utilizzo della memoria per la
                      compressione, l'estrazione o entrambe; LIMIT è in byte,
                      % della memoria RAM oppure 0 per il valore predefinito       --no-adjust     Se le impostazioni di compressione eccedono il limite di
                      utilizzo della memoria, lancia un errore invece di
                      utilizzare valori più piccoli       --no-sparse     Non crea file sparsi durante l'estrazione
  -S, --suffix=.SUF   Usa il suffisso ".SUF" sui file compressi
      --files=[FILE]  Legge i nomi dei file da elaborare da FILE; se FILE è
                      omesso, i nomi dei file sono letti dallo standard input;
                      i nomi dei file devono essere terminati con un carattere
                      di newline
      --files0=[FILE] Come --files ma usa il carattere null come terminatore       --robot         Usa messaggi analizzabili (utile per gli script)       --single-stream Decomprime solamente il primo stream e ignora
                      silenziosamente i restanti dati di input       Val.cont %*s Header  Flag       Dim.compr.    Uso mem.  Filtri   -0 ... -9           Preset di compressione; predefinito è 6; tenere a mente
                      l'utilizzo di memoria per comprimere ed estrarre prima
                      di usare 7-9   -F, --format=FMT    Formato file per codificare o decodificare; i possibili
                      valori sono "auto" (predefinito) "xz", "lzma" e "raw"
  -C, --check=CHECK   Tipo di verifica integrità: "none" (usare con attenzione),
                      "crc32", "crc64" (predefinito) o "sha256"   -Q, --no-warn       Gli avvisi non influenzano lo stato d'uscita   -V, --version       Stampa il numero della versione ed esce   -e, --extreme       Tenta di migliorare il rapporto di compressione
                      utilizzando più tempo di CPU; non cambia i requisiti di
                      memoria in fase di estrazione   -h, --help          Stampa l'aiuto breve (elenca solo le opzioni di base)
  -H, --long-help     Stampa questo lungo aiuto ed esce   -h, --help          Stampa questo breve aiuto ed esce
  -H, --long-help     Stampa l'aiuto lungo (elenca anche le opzioni avanzate)   -k, --keep          Mantiene (non elimina) i file di input
  -f, --force         Forza la sovrascrittura dell'output e comprime/estrae i
                      collegamenti
  -c, --stdout        Scrive sullo standard output e non elimina i file di input   -q, --quiet         Sopprime gli avvisi; specificare due volte per sopprimere
                      anche gli errori
  -v, --verbose       Output prolisso; specificare due volte per output ancora
                      più prolisso   -z, --compress      Forza la compressione
  -d, --decompress    Forza l'estrazione
  -t, --test          Verifica l'integrità dei file compressi
  -l, --list          Elenca informazioni sui file .xz   Blocchi:
    Stream    Blocc.    Offset comp. Offset estratto       Dim. tot.   Dim. estratto  Rapp.  Contr   Blocchi:              %s
   Controllo:            %s
   Dim. compresso:       %s
   Memoria necessaria:   %s MiB
   Numero di file:       %s
   Rapporto:             %s
   Dim. negli header:    %s
   Padding dello stream: %s
 Stream:
    Stream    Blocc.    Offset comp.    Offset estr.      Dim. comp.   Dim. estratto  Rapp.  Contr      Padding   Stream:               %s
   Dim. estratto:        %s
  Modalità di operazione:
 %s MiB di memoria sono richiesti. Il limite è %s. %s file
 %s file
 Sito web di %s: <%s>
 %s:  %s: impossibile rimuovere: %s %s: impossibile impostare il gruppo del file: %s %s: impossibile impostare il proprietario del file: %s %s: impossibile impostare i permessi del file: %s %s: chiusura del file non riuscita: %s %s: errore nel leggere i nomi dei file: %s %s: errore nel cercare il file: %s %s: il file ha già il suffisso "%s", viene saltato %s: il file ha il bit setuid o setgid impostato, viene saltato %s: il file ha lo sticky bit impostato, viene saltato %s: il file è vuoto %s: sembra che il file sia stato spostato, non viene rimosso %s: il nome del file ha un suffisso sconosciuto, viene saltato %s: catena di filtri: %s
 %s: il file di input ha più di un collegamento fisico, viene saltato %s: suffisso del nome del file non valido %s: suffisso del moltiplicatore non valido %s: nome opzione non valido %s: valore dell'opzione non valido %s: è una directory, viene saltata %s: è un collegamento simbolico, viene saltato %s: non è un file regolare, viene saltato %s: nessun carattere trovato durante la lettura dei nomi dei file; forse si intendeva usare "--files0" invece di "--files"? %s: le opzioni devono essere coppie "nome=valore" separate da virgole %s: errore di lettura: %s %s: posizionamento non riuscito nel tentativo di creare un file sparso: %s %s: troppo piccolo per essere un file .xz valido %s: fine del file inaspettata %s: fine dell'input durante la lettura dei nomi dei file non attesa %s: tipo di formato del file sconosciuto %s: tipo di controllo integrità non supportato %s: il valore non è un numero intero decimale non-negativo %s: con --format=raw, --suffix=.SUF è richiesto a meno che non si scriva sullo stdout %s: errore di scrittura: %s --list non è in grado di leggere dallo standard input --list funziona solamente con file .xz (--format=xz o --format=auto) Regolata la dimensione del dizionario LZMA%c da %s MiB a %s MiB per non superare il limite dell'uso della memoria di %s MiB Impossibile stabilire i gestori dei segnali Impossibile leggere i dati dallo standard input durante la lettura dei nomi dei file dallo standard input I dati compressi non possono essere letti da un terminale I dati compressi non possono essere scritti ad un terminale I dati compressi sono danneggiati La compressione e l'estrazione con --robot non sono ancora supportate. L'estrazione necessita di %s MiB di memoria. Disabilitato Nome file vuoto, viene saltato Errore nel ripristinare la flag O_APPEND sullo standard output: %s Formato di file non riconosciuto Errore interno (bug) LZMA1 non può essere usato con il formato .xz Gli argomenti obbligatori per le opzioni lunghe lo sono anche per quelle brevi.
 Il numero massimo di filtri è quattro Limite utilizzo memoria per la compressione:  Limite utilizzo memoria per l'estrazione:     Il limite dell'uso della memoria è troppo basso per l'impostazione del filtro dato. Limite di utilizzo della memoria raggiunto No Nessun controllo d'integrità; l'integrità del file non viene verificata Nessuno Solo un file può essere specificato con "--files" o "--files0". Segnalare i bug a <%s> (in inglese o finlandese).
Segnalare i bug di traduzione a <tp@lists.linux.it>.
  Strm  Blocc.    Compresso     Estratto  Rapp.  Contr   Nome file Il formato .lzma supporta solo il filtro LZMA1 La variabile d'ambiente %s contiene troppi argomenti Le opzioni esatte per i preset possono variare tra le versioni del software. La somma di lc e lp non deve superare 4 Quantità totale di memoria fisica (RAM):      Totali: Provare "%s --help" per maggiori informazioni. Fine dell'input non attesa Errore sconosciuto Sconosc11 Sconosc12 Sconosc13 Sconosc14 Sconosc15 Sconosc2 Sconosc3 Sconosc5 Sconosc6 Sconosc7 Sconosc8 Sconosc9 Preset LZMA/LZMA2 non supportato: %s Catena di filtri od opzioni del filtro non supportata Opzioni non supportate Tipo di controllo di integrità non supportato; l'integrità del file non viene verificata Uso: %s [OPZIONI]... [FILE]...
Comprime o estrae i FILE nel formato .xz.

 Non è consigliato usare un preset nella modalità raw. I suffissi validi sono "KiB" (2^10), "MiB" (2^20), e "GiB" (2^30). Scrittura sullo standard ouput non riuscita Sì PRIu32 PRIu64 The selected match finder requires at least nice=% Value of the option `%s' must be in the range [%, %] Lo strumento per cercare corrispondenze selezionato richiede almeno nice=% Il valore dell'opzione "%s" deve essere nell'intervallo [%, %] 