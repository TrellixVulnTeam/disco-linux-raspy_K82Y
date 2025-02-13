��          �   %   �      `     a     h     {     �     �     �     �  #   �      �  #        8     ;  $   P     u     x     �     �     �     �    �     �     	     5	  =   ;	     y	     �	  {  �	  	             5     J     _  #   w     �  6   �  !   �  .   �     )     .  )   G     q  !   t     �     �     �     �  V  �  7   H  6   �     �  E   �  !        %                                             
               	                                                                Cancel Checking source... Copy From Device: Copy To Device: Copy complete. Copying partition %d of %d... Help Insufficient space. Backup aborted. Internal SD card  (/dev/mmcblk0) Make a copy of the Raspbian SD card No No devices available Non-MSDOS partition table on source. OK Preparing partitions... Preparing target... Reading partitions... SD Card Copier SD Card Copier Help SD Card Copier v1.0

This is an application to copy and back up SD cards. To use it, you will need a USB SD card writer.

To back up your Raspberry Pi's internal SD card, insert a blank SD card into a USB card writer and connect it to your Pi. Then start the application, choose your card writer from the “Copy To Device” drop-down box and press “Start”. The copy process will take 10-15 minutes depending on the size of your card.

The resulting card should be a bootable copy of your existing card; to restore, simply place the backup card into the onboard SD card slot, put the card to restore onto into the USB writer and repeat the copy process above.

You can also back up to a standard USB stick, and then restore from the USB stick to an SD card by setting the “Copy From Device” drop-down to the USB stick and the “Copy To Device” to a USB card writer containing the card to restore onto.

Note that you cannot copy onto the SD card from which your Pi is currently booted, which is why it does not appear in the “Copy To Device” dropdown.

Note also that the destination card doesn’t need to be the same size as the source card, but it must have enough space to hold all the data that is on it. The application will warn you if there is insufficient space on the destination.
 Select the device to copy from Select the device to copy to Start This will erase all content on the device '%s'. Are you sure? Unable to read source. Yes Project-Id-Version: piclone 0.1
Report-Msgid-Bugs-To: 
POT-Creation-Date: 2016-02-22 16:07+0000
PO-Revision-Date: 2016-05-14 16:20+0200
Last-Translator: Benjamin Weis <benjamin.weis@gmx.com>
Language-Team: 
Language: de
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Plural-Forms: nplurals=2; plural=(n != 1);
X-Generator: Poedit 1.8.7
 Abbrechen Quelle wird überprüft... Von Gerät kopieren: Auf Gerät kopieren: Kopieren abgeschlossen. Partition %d von %d wird kopiert... Hilfe Nicht genügend Speicherplatz . Sicherung abgebrochen. Interne  SD-Karte  (/dev/mmcblk0) Erstellen Sie eine Kopie der Raspbian SD-Karte Nein Keine Geräte verfügbar Nicht-MSDOS-Partitionstabelle auf Quelle. OK Partitionen werden vorbereitet... Ziel wird vorbereitet... Partitionen werden gelesen... SD Card Copier SD Card Copier Hilfe SD Card Copier v1.0

Dies ist eine Anwendung zum Kopieren und Sichern von SD-Karten. Sie benötigen einen USB-SD-Kartenschreiber, um sie verwenden zu können.

Um die interne SD-Karte Ihres Raspberry Pis zu sichern, legen Sie eine leere SD-Karte in einen USB-Kartenschreiber ein und verbinden Sie ihn mit Ihrem Pi. Anschließend starten Sie die Anwendung, wählen Sie Ihren Kartenschreiber aus der Dropdown-Liste “Auf Gerät kopieren” aus und drücken Sie auf “Start”. Der Kopiervorgang wird 10-15 Minuten dauern, je nach Größe Ihrer Karte.

Die hierdurch entstandene Karte sollte eine bootbare Kopie Ihrer vorhandenen Karte sein; zum Wiederherstellen legen Sie einfach die Sicherungskarte in den sich auf der Platine befindlichen SD-Kartensteckplatz ein, legen Sie zum Wiederherstellen der Karte diese in den USB-Kartenschreiber ein und wiederholen sie den obigen Kopiervorgang.

Sie können auch auf einen Standard-USB-Stick sichern und anschließend von dem USB-Stick auf eine SD-Karte durch die Auswahl “Von Gerät kopieren” in der Dropdown-Liste wiederherstellen und zu einem USB-Kartenschreiber, der die Karte enthält, mit “Auf Gerät kopieren” wiederherstellen.

Beachten Sie, dass Sie nicht auf die SD-Karte kopieren können, von denen Ihr Pi gebootet wurde, welche deshalb auch nicht in der Dropdown-Liste “Auf Gerät kopieren” erscheint.

Beachten Sie auch, dass die Zielkarte nicht die gleiche Größe wie die Quellkarte haben muss, aber sie muss genügend Speicherplatz für alle Daten haben. Die Anwendung wird Sie warnen, wenn nicht genügend Speicherplatz auf dem Ziel vorhanden ist.
 Wählen Sie das Gerät aus, von dem kopiert werden soll Wählen Sie das Gerät aus, zu dem kopiert werden soll Start Dies wird alle Inhalte auf dem Gerät '%s' löschen. Sind Sie sicher? Quelle kann nicht gelesen werden. Ja 