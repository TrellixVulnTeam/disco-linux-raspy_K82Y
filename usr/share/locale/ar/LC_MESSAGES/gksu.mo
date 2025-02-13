��    %      D  5   l      @     A  s   C    �  �   �  �   U  �     k   �  �   7  k   �  N   \  _   �  E   	  &   Q	  '   x	  '   �	  (   �	  �   �	  _   �
  �   )     �     �     �            E   3  ,   y  +   �  %   �     �            +        C  	   [     e     r  �  �     @  �   B  M  �  �     �   �    �  �   �    �  �   �  L   .  c   {  S   �  3   3  9   g  3   �  C   �      x   '  �   �     �     �     �  !   �      �  g     6   n  6   �  /   �          $  	   :  8   D  '   }     �     �     �                          	      !      $                                       "                               %                                    
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

 User %s does not exist. _Advanced _login shell _preserve environment Project-Id-Version: gksu-2.0.0
Report-Msgid-Bugs-To: 
POT-Creation-Date: 2007-03-25 14:52-0300
PO-Revision-Date: 2007-01-19 16:47+0200
Last-Translator: Khaled Hosny <khaledhosny@eglug.org>
Language-Team: Arabic <doc@arabeyes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Generator: KBabel 1.11.4
Plural-Forms: Plural-Forms: nplurals=4; plural=n==1 ? 0 : n==2 ? 1 : n>=3 && n<=10 ? 2 : 3

 
   --debug, -d
    اطبع على الشاشة معلومات قد تكون مفيدة في تشخيص
    و/أو حل المشاكل.
   --description <description|file>, -D <description|file>
    وفّر اسما واصِفا للأمر ليُستخدم في الرسالة الإفتراضيّة
    جاعلا إياها أفضل. يَمكنك إعطاء المسار المطلق لملف .desktop
    سيُستخدم مفتاح "name" في هذه الحالة.
   --disable-grab, -g
    عطِّل "قفل" لوحة المفاتيح، و الفأرة،
    و البؤرة التي يقوم بها البرنامج أثناء السؤال
    عن كلمة السر.
   --login, -l
    اجعل هذه صدفة ولوج. اعلم أن هذا قد يُسبب
    مشاكل مع سحر Xauthority. شغّل xhost
    لتسمح للمستخدم المستهدف بفتح نوافذ على جهاز عرضك.
   --message <message>, -m <message>
    استبدل الرسالة الإفتراضيّة المعرضة عند السُؤال على كلمة السر
    بالمعامل المرر للخيار. استعملها فقط إذا لم يُكن
    خيار  --description كافياً.
   --preserve-env, -k
    حافظ على البيئة الحالية، لا تضبط $HOME
    ولا $PATH، على سبيل المثال.
   --print-pass, -p
    اطلب من gksu أن يطبع كلمة السر في الخرج القياسي، شبيه
    بـ ssh-askpass. مفيد مع النصوص الشفرية التي تقبل استقبال
    كلمة السر من الدخل القياسي.
   --prompt, -P
    اسأل المستخدم إن كان يرغب في أن "تُلتقط" لوحة
    المفاتيح والفأرة قبل عمل هذا.
   --su-mode, -w
    استخدم su، بدلا من افتراضي libgksu.
   --sudo-mode, -S
    استخدم sudo بدلا من su، كما لو شُغِّل كـ "gksudo".
   --user <user>, -u <user>
    نادِ <command> كالمستخدم المحدد.
 <b>فشلت في طلب كلمة السرّ</b>

%s <b>فشلت في تشغيل %s كمستخدم %s.</b>

%s <b>كلمة سر خطأ... حاول ثانية.</b> <b>خيارات تستخدم عند تغيير المستخدم</b> <b>أترغب بأن "تُلتقط" شاشُتك بينما تُدخِل كلمة السرّ؟</b>

يعنى هذا إيقاف كل التطبيقات مؤقتا لتجنّب
تنصُّت التطبيقات الخبيثة على كلمة سرّك وأنت تكتبها. <big><b>خيارات أو مُعاملات مفقودة</b></big>

تحتاج لإعطاء --description أو --message. <big><b>لم أستطع تحديد برنامج لتشغيله.</b></big>

العنصر الذي اخترته لا يمكن فتحه بصلاحيات المدير لعدم إمكانية تحديد البرنامج الصحيح خيارات متقدّمة كمستخدم: نسخة GKsu %s

 لا برنامج لتشغيله. افتح كمدير النظام يفتح طرفيّة كمستخدم جذر، مستخدماً gksu للسؤال عن كلمة السر يفتح ملف بصلاحيات مدير النظام لم يُقبل الخيار لـ  --disable-grab: %s
 لم يُقبل الخيار لـ --prompt: %s
 طرفيّة الجذر شغّل برنامج شغّل: الإستخدام: %s [-u <user>] [options] <command>

 المستخدم %s لا وجود له. م_تقدّم صدفة _ولوج _حافظ على البيئة 