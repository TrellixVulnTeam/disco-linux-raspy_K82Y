/* To launch this program from within Mathematica use:
 *   In[1]:= link = Install["sumalist"]
 *
 * Or, launch this program from a shell and establish a
 * peer-to-peer connection.  When given the prompt Create Link:
 * type a port name. ( On Unix platforms, a port name is a
 * number less than 65536.  On Mac or Windows platforms,
 * it's an arbitrary word.)
 * Then, from within Mathematica use:
 *   In[1]:= link = Install["portname", LinkMode->Connect]
 */

#include "mathlink.h"


#if MLINTERFACE >= 3
int sumalist P(( int *, long));
#else
int sumalist P(( intp_nt, long));
#endif /* MLINTERFACE >= 3 */

:Begin:
:Function:      sumalist
:Pattern:       SumAList[ list:{___Integer} ]
:Arguments:     { Reverse[list] }
:ArgumentTypes: { IntegerList }
:ReturnType:    Integer
:End:

:Evaluate:      SumAList[ sequence___Integer]:= SumAList[ {sequence} ]


#if MLINTERFACE >= 3
int sumalist( int *list, long len)
#else
int sumalist( intp_nt list, long len)
#endif /* MLINTERFACE >= 3 */
{
        int res = 0;
        while(len--)
			res += *list++;
        return res;
}


#if WINDOWS_MATHLINK

#if __BORLANDC__
#pragma argsused
#endif

int PASCAL WinMain( HINSTANCE hinstCurrent, HINSTANCE hinstPrevious, LPSTR lpszCmdLine, int nCmdShow)
{
	char  buff[512];
	char FAR * buff_start = buff;
	char FAR * argv[32];
	char FAR * FAR * argv_end = argv + 32;

    hinstPrevious = hinstPrevious; /* suppress warning */

	if( !MLInitializeIcon( hinstCurrent, nCmdShow)) return 1;
	MLScanString( argv, &argv_end, &lpszCmdLine, &buff_start);
	return MLMain( (int)(argv_end - argv), argv);
}

#else

int main(int argc, char **argv)
{
	return MLMain(argc, argv);
}

#endif
