Þ    %      D  5   l      @     A  s   C    ·     Í  µ   U  ¿     k   Ë  ¸   7  k   ð  N   \  _   «  E   	  &   Q	  '   x	  '    	  (   È	  ×   ñ	  _   É
  ¯   )     Ù     ê     ó            E   3  ,   y  +   ¦  %   Ò     ø            +        C  	   [     e     r  6       ¿  p   Á    2     O  Ú   Ó  à   ®       Ó     ^   ï  M   N  o     ]     <   j  X   §  A      /   B  È   r  v   ;  ³   ²     f     t       $        ¿  M   Ó  *   !  ?   L  9        Æ     ×     ë  5   ó     )  
   G     R     d                          	      !      $                                       "                               %                                    
                    #               
   --debug, -d
    Print information on the screen that might be
    useful for diagnosing and/or solving problems.
   --description <description|file>, -D <description|file>
    Provide a descriptive name for the command to
    be used in the default message, making it nicer.
    You can also provide the absolute path for a
    .desktop file. The Name key for will be used in
    this case.
   --disable-grab, -g
    Disable the "locking" of the keyboard, mouse,
    and focus done by the program when asking for
    password.
   --login, -l
    Make this a login shell. Beware this may cause
    problems with the Xauthority magic. Run xhost
    to allow the target user to open windows on your
    display!
   --message <message>, -m <message>
    Replace the standard message shown to ask for
    password for the argument passed to the option.
    Only use this if --description does not suffice.
   --preserve-env, -k
    Preserve the current environments, does not set $HOME
    nor $PATH, for example.
   --print-pass, -p
    Ask gksu to print the password to stdout, just
    like ssh-askpass. Useful to use in scripts with
    programs that accept receiving the password on
    stdin.
   --prompt, -P
    Ask the user if they want to have their keyboard
    and mouse grabbed before doing so.
   --su-mode, -w
    Make GKSu use su, instead of using libgksu's
    default.
   --sudo-mode, -S
    Make GKSu use sudo instead of su, as if it had been
    run as "gksudo".
   --user <user>, -u <user>
    Call <command> as the specified user.
 <b>Failed to request password.</b>

%s <b>Failed to run %s as user %s.</b>

%s <b>Incorrect password... try again.</b> <b>Options to use when changing user</b> <b>Would you like your screen to be "grabbed"
while you enter the password?</b>

This means all applications will be paused to avoid
the eavesdropping of your password by a a malicious
application while you type it. <big><b>Missing options or arguments</b></big>

You need to provide --description or --message. <big><b>Unable to determine the program to run.</b></big>

The item you selected cannot be open with administrator powers because the correct application cannot be determined. Advanced options As user: GKsu version %s

 Missing command to run. Open as administrator Opens a terminal as the root user, using gksu to ask for the password Opens the file with administrator privileges Option not accepted for --disable-grab: %s
 Option not accepted for --prompt: %s
 Root Terminal Run program Run: Usage: %s [-u <user>] [options] <command>

 User %s does not exist. _Advanced _login shell _preserve environment Project-Id-Version: gksu 2.0.0
Report-Msgid-Bugs-To: kov@debian.org
POT-Creation-Date: 2007-03-26 01:56+0900
PO-Revision-Date: 2007-03-26 01:56+0900
Last-Translator: Changwoo Ryu <cwryu@debian.org>
Language-Team: Korean
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
 
   --debug, -d
    ë¬¸ì ì ì ê²ì¬íê³  í´ê²°íë ë° ì ì©í ì ë³´ë¥¼
    íë©´ì íìí©ëë¤.
   --description <ì¤ëª|íì¼>, -D <ì¤ëª|íì¼>
    ê¸°ë³¸ ë©ì¸ì§ìì ëªë ¹ì´ì ëí ì¤ëªì¼ë¡ ì¬ì©í 
    ì´ë¦ì ì§ì í©ëë¤. ì¬ê¸°ì .desktop íì¼ì ì ë
    ê²½ë¡ë¥¼ ì§ì í  ìë ììµëë¤. ê·¸ ê²½ì°ìë Name
    í¤ë¥¼ ì¬ì©í©ëë¤.
   --disable-grab, -g
    ì´ì ê¸ì ë¬¼ì´ë³¼ ë í¤ë³´ë, ë§ì°ì¤, í¬ì»¤ì¤ë¥¼
    "ì ê·¸ë" ì¼ì íì§ ììµëë¤.
   --login, -l
    ë¡ê·¸ì¸ ìë¡ í©ëë¤. Xauthority ë°©ìê³¼ ë¬¸ì ë¥¼
    ì¼ì¼í¬ ìë ìì¼ë ì£¼ìíì­ìì¤. í´ë¹ ì¬ì©ìë¡
    íë©´ì ì°½ì ëì°ê² íë ¤ë©´ xhostë¥¼ ì¬ì©íì­ìì¤!
   --message <ë©ì¸ì§>, -m <ë©ì¸ì§>
    ì´ì ê¸ì ë¬¼ì´ë³¼ ë ëì¤ë íì¤ ë©ì¸ì§ë¥¼ ìµìì
    ì¸ìë¡ ë°ê¿ëë¤. --description ìµìë§ ê°ì§ê³ ë
    ì ëë ê²½ì°ìë§ ì¬ì©íì­ìì¤.
   --preserve-env, -k
    íì¬ íê²½ì ì ì§í©ëë¤. ìë¥¼ ë¤ì´ $HOMEì´ë $PATH
    íê²½ ë³ìë¥¼ ë³ê²½íì§ ììµëë¤.
   --print-pass, -p
    ssh-askpassì ë§ì°¬ê°ì§ë¡ ì´ì ê¸ì íì¤ ì¶ë ¥ì¼ë¡
    íìí©ëë¤. ì´ì ê¸ì íì¤ ìë ¥ì¼ë¡ ë°ë ì¤í¬ë¦½í¸
    íë¡ê·¸ë¨ìì ì¬ì©íê¸° ì¢ìµëë¤.
   --prompt, -P
    í¤ë³´ëì ë§ì°ì¤ë¥¼ ì¡ì ì§ ì¬ë¶ë¥¼ ê·¸ ì ì ë¬¼ì´ë´ëë¤.
   --sudo-mode, -S
    libgksuì ê¸°ë³¸ê° ëì ì suë¥¼ ì¬ì©í©ëë¤. 
   --sudo-mode, -S
    su ëì ì sudoë¥¼ ì¬ì©í©ëë¤. gksudoë¥¼ ì¤íí ê²ì²ë¼
    ëìí©ëë¤.
   --user <ì¬ì©ì>, -u <ì¬ì©ì>
    ì§ì í ì¬ì©ìë¡ <ëªë ¹>ì ì¤íí©ëë¤.
 <b>ì´ì ê¸ì ìì²­íë ë° ì¤í¨íìµëë¤.</b>

%s <b>%2$s ì¬ì©ìë¡ %1$s íë¡ê·¸ë¨ì ì¤ííë ë° ì¤í¨íìµëë¤.</b>

%3$s <b>ì´ì ê¸ì´ íë ¸ìµëë¤... ë¤ì ìëíì­ìì¤.</b> <b>ì¬ì©ìë¥¼ ë°ê¿ ë ì¬ì©í  ìµì</b> <b>ì´ì ê¸ì ìë ¥íë ëìì íë©´ì "ê³ ì "íìê² ìµëê¹?

ëª¨ë  íë¡ê·¸ë¨ì´ ì¼ì ì ì§í´ì ììì ì¸ íë¡ê·¸ë¨ì´
ì´ì ê¸ ìë ¥ì ì¿ë£ì§ ëª»íê² í©ëë¤. <big><b>ìµìì´ë ì¸ìê° ììµëë¤</b></big>

--descriptionì´ë --message ìµìì ì¬ì©í´ì¼ í©ëë¤. <big><b>ì¤íí  íë¡ê·¸ë¨ì ì ì ììµëë¤.</b></big>

ì íí í­ëª©ì ê´ë¦¬ì ê¶íì¼ë¡ ì´ ì ììµëë¤. ì¬ë°ë¥¸ íë¡ê·¸ë¨ì ì ì ììµëë¤. ê³ ê¸ ìµì ë¤ì ì¬ì©ìë¡: GKsu ë²ì  %s

 ì¤íí  ëªë ¹ì´ê° ììµëë¤. ê´ë¦¬ìë¡ ì´ê¸° ë£¨í¸ ì¬ì©ìë¡ í°ë¯¸ëì ì´ê³ , GKSUë¡ ì´ì ê¸ì ë¬¼ì´ë´ëë¤ íì¼ì ê´ë¦¬ì ê¶íì¼ë¡ ì½ëë¤ --disable-grabìì ì¸ ì ìë ì¶ê° ìµììëë¤: %s
 --promptìì ì¸ ì ìë ì¶ê° ìµììëë¤: %s
 ë£¨í¸ í°ë¯¸ë íë¡ê·¸ë¨ ì¤í ì¤í: ì¬ì©ë²: %s [-u <ì¬ì©ì>] [ìµì] <ëªë ¹ì´>

 %s ì¬ì©ìê° ììµëë¤. ê³ ê¸(_A) ë¡ê·¸ì¸ ì(_L) íê²½ ì ì§(_P) 