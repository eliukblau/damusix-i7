Version 4.0.0 of Damusix Sound Manager (for Glulx only) by Eliuk Blau begins here.

"Damusix is a powerful Unified Sound Manager for Glulx that can manage all functions necessary for play music and sounds through a simply and easy way."

[==============================================================================]
[==============================================================================]

Part 0 - Damusix I7 Header Comment (in Spanish) - Unindexed

[===============================================================================
!  DREAMBYTES ADVENTURES: AD(M)INISTRADOR (U)NIFICADO DE (S)ON(I)DO EN GLUL(X)
!  Codigo Fuente
!===============================================================================
!
!  Archivo :  Damusix.i7x
!  Fecha   :  2024/12/23
!  Version :  4.0.0 (based on lastest Inform6 version 3/090103)
!  Autor   :  Eliuk Blau
!  e-Mail  :  eliukblau (AT) gmail.com
!
!  Descripcion: Extension usada por DreamBytes Adventures para la programacion
!               de juegos de Ficcion Interactiva en Inform6, que proporciona un
!               Administrador Unificado de Sonido en Glulx capaz de gestionar
!               todas las funciones necesarias para la reproduccion de musica
!               y efectos de sonido en esta grandiosa maquina virtual. El
!               Gestor Avanzado de Damusix encapsula todo el codigo necesario
!               para el trabajo con el audio, permitiendo al programador hacer
!               uso de estas funcionalidades mediante una interface de
!               manejo sencilla.
!
!               El Gestor Avanzado de Audio de Damusix implementa 10 canales
!               "normales" para la reproduccion de sonidos con CONTROL TOTAL
!               (tocarlos, detenerlos, volumen individual, repeticion, etc.);
!               10 canales "virtuales" para una reproduccion de sonidos mas
!               limitada, pero con la ventaja de no tener que "asignar un
!               canal" previamente a un sonido concreto, permitiendo asi que
!               varios sonidos puedan tocarse al mismo tiempo sin interrumpirse
!               mutuamente ni tener que "asignarlos" cada vez a un canal
!               "normal" (el Gestor asignara los canales automaticamente);
!               y 1 canal especialmente dedicado al trabajo con la "lista de
!               reprod. de sonidos" que facilita Damusix. Esta "lista" tiene
!               espacio suficiente para 10 sonidos que luego tocara en el orden
!               en que hayan sido agregados, uno por uno. La "lista" puede ser
!               util para reproducir cadenas de sonidos.
!
!               Adicionalmente, los sonidos asignados a canales "normales"
!               pueden generar eventos de notificacion Glk cuando terminen de
!               reproducirse. Estas notificaciones pueden ser "capturadas" por
!               el programador y ser utilizadas como mejor le parezca ocupando
!               para ello el mecanismo de reglas que la extension Glulx Entry
!               Points pone a su disposicion.
!
!               La extension Damusix tambien permite realizar efectos de FadeIn
!               y FadeOut con los sonidos asignados a un canal "normal". Estos
!               efectos de Fade pueden ser o no en "tiempo-real". Un Fade en
!               "tiempo-real" transcurrira de fondo mientras el juego corre
!               normalmente. Un Fade en "tiempo-no-real" hara primero el efecto
!               y una vez haya finalizado, recien entonces devolvera el control
!               de la ejecucion al codigo a continuacion. Los Fades en "tiempo
!               real" pueden ser abortados en cualquier momento si el
!               programador lo necesita.
!
!               Resumen de Caracteristicas de la extension Damusix:
!               ---------------------------------------------------
!               * 10 Canales "Normales" con Control Total del Audio
!               * 10 Canales "Virtuales" para sonidos sin "canal asignado"
!               * Lista de Reproduccion de Sonidos (con espacio para 10 items)
!               * Control de Volumen Global del Gestor
!               * Control de Volumen Individual de cada Sonido
!               * Utilizacion con Abstraccion por Sonidos o por Canales
!               * Efectos de FadeIn y FadeOut en "tiempo-real/tiempo-no-real"
!               * Activar/Desactivar el Audio limpiamente (sin cambiar volumen)
!               * Comprobacion Automatica de Soporte de Audio a nivel de Glk
!               * Mecanismo de "Proteccion de Sonidos" ante UNDO/RESTORE
!               * Muchas caracteristicas mas... =D
!
!               Esta extension esta inspirada profundamente en el modulo
!               "efectos.h" de Jose Luis Diaz [aka Zak] (para la libreria
!               InformATE!); y en el manual Gull y el codigo fuente del juego
!               Jukebox, de Adam Cadre. Se les da el debido reconocimiento a
!               estos autores por su excelente trabajo.
!
!               Damusix requiere para funcionar correctamente:
!                 - Sistema de Autoria Inform 7 (build 5U92 o superior)
!                 - Extension Glulx Entry Points (version 6 o superior)
!
!               Si modificas la extension Damusix, estare muy agradecido si
!               me mandas el codigo fuente por e-Mail.
!
!               If you modify the Damusix extension, I would be grateful if
!               you send me the source code by e-Mail.
!
!               Copyright (c) 2008, 2009, 2024
!               Nicolas Merino Quezada (aka Eliuk Blau).
!
!               This program is distributed in the hope that it will be useful,
!               but WITHOUT ANY WARRANTY; without even the implied warranty of
!               MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
!
!               o-------------------------------------------------------------o
!               | WARNING:                                                    |
!               | THIS COPY OF THE DAMUSIX EXTENSION IS ONLY FOR BETATESTERS. |
!               | YOU CAN NOT REDISTRIBUTE IT AND/OR MODIFY IT WITHOUT THE    |
!               | EXPLICIT PERMISSION OF THE AUTHOR.                          |
!               o-------------------------------------------------------------o
!
!===============================================================================
!
!  COMPATIBILIDAD - Lista de Cambios efectuados en Damusix I7 respecto
!  del codigo original en Damusix I6 (buscar comentarios '***I7-COMP'):
!
!  (01) En constantes de "Warning Texts" se deben "codificar" a la Inform6
!       todos los acentos, los signos y caracteres "no anglosajones" pues
!       Inform7 siempre intenta representarlos en formato Unicode, obteniendo
!       con ello resultados incorrectos (los transforma en "sustituciones de
!       texto" Unicode, pero estas no se pueden aplicar al interior de
!       "constantes de texto").
!
!  (02) Se programa el "mini-wrapper" DmxAPI__ErrorEval() [02b]. El wrapper se
!       utiliza, concretamente, para capturar los valores retorno de algunas
!       rutinas del Gestor de Damusix y, en caso que devuelvan con error,
!       mostrar mensajes de aviso [02a] especificos para cada caso. (Cuando
!       el soporte de sonido de I7 este totalmente implementado en todos los
!       sistemas operativos, entonces se mostraran los mensaje de aviso solo
!       en el modo DEBUG. Mientras tanto, los mensajes se mostraran tambien
!       en una compilacion final, para facilitar la deteccion de errores a
!       los autores que necesiten probar sus trabajos en un interprete
!       ajeno al IDE de I7, que si soporte apropiadamente el audio.)
!
!         Rutinas del Gestor Envueltas por el Wrapper DmxAPI__ErrorEval():
!         ------------------------------------------------------------
!           > DmxAPI__AssignChannel()
!           > DmxAPI__VirtualPlaySound()
!           > DmxAPI__AddToPlaylist()
!           > DmxAPI__PlayChannel()
!           > DmxAPI__StopChannel()
!           > DmxAPI__SetChannelRepetition()
!           > DmxAPI__SetChannelVolume()
!           > DmxAPI__FindSound()
!           > DmxAPI__GetSoundRepetition()
!           > DmxAPI__GetSoundVolume()
!           > DmxAPI__GetChannelRepetition()
!           > DmxAPI__GetChannelVolume()
!           > DmxAPI__IsChannelPIB()
!
!  (03) La rutina DmxAPI__Glk_FadeNotifyHandler() se ha modificado levemente para
!       hacerla compatible con la extension Glulx Entry Points. Concretamente,
!       se ha eliminado la comprobacion del evento que se queria gestionar (en
!       este caso, un 'tick' del Timer) ya que ahora es la propia Glulx Entry
!       Points la que se encarga de reconocer el tipo de evento generado.
!
!===============================================================================
!
!  VERSIONES DEL GESTOR - Listado de los Gestores de Audio de Damusix I6
!  que utiliza cada una de las versiones de Damusix I7:
!
!  v4.0.0       - Refactorizacion del codigo I6 de la v3/090103.
!  v3/090103    - Potenciada por Damusix I6 v3/090103.
!
!===============================================================================
!
!  Log:
!  2024/12/23  Eliuk Blau - IMPORTANTE!! Beta-Release: ** Damusix v4.0.0 **
!                         - Primera version compatible con Inform7 v10.1.
!                         - Se refactoriza completamente el codigo I6 del motor
!                           para eliminar codigo orientado a objetos, que por
!                           alguna razon desconocida no le gusta al toolchain
!                           de Inform7. El antiguo codigo orientado a objetos
!                           se reescribio como codigo procedural y todas las
!                           propiedades de objetos se pasaron a variables
!                           globales con una nomenclatura apropiada.
!                         - Se actualizan frases de I7 deprecadas estilo
!                           `if A then B...` a nuevas frases `if A, B...`.
!  2009/01/03  Eliuk Blau - IMPORTANTE!! Beta-Release: ** Damusix v3/090103 **
!                         - Se actualiza la extension con el Gestor de Damusix
!                           I6 version 3/090103 (solo por motivos menores de
!                           cambio de versionado).
!  2008/12/23  Eliuk Blau - IMPORTANTE!! Beta-Release: ** Damusix v3/081104 **
!  2008/12/04  Eliuk Blau - Se actualiza la extension con el Gestor de Damusix
!                           I6 version 3/081104. Ahora se soportan efectos de
!                           Fade a volumenes arbitrarios y el nuevo sistema
!                           de 'proteccion de sonidos' ante UNDO/RESTORE.
!  2008/09/27  Eliuk Blau - Se corrigen todas las frases de lenguaje natural
!                           ingles de acuerdo a las sugerencias de Aaron Reed.
!  2008/09/22  Eliuk Blau - Se pasa todo el wrapper a una version nativa en
!                           ingles. La traduccion al español (y otros idiomas)
!                           debera hacerse "reemplazando" algunas secciones
!                           especificas de la Damusix original, mediante una
!                           extension de soporte (ver Damusix SP).
!  2008/09/21  Eliuk Blau - Se terminan de programar la totalidad de frases
!                           de lenguaje natural del wrapper (100% completado).
!                         - Se inicia el proceso de pre-betatesteo y la
!                           redaccion de minima documentacion para testers.
!  2008/09/20  Eliuk Blau - Se terminan de seleccionar las frases de lenguaje
!                           natural basicas para el funcionamiento de Damusix.
!  2008/05/14  Eliuk Blau - Se crea el archivo.
]

[==============================================================================]
[==============================================================================]

Part 1 - Damusix Glulx Entry Points - Unindexed

Include Glulx Entry Points by Emily Short.

The zeroing sound-references of Damusix rule is listed first in the glulx zeroing-reference rules.
The update sound-objects of Damusix rule is listed first in the glulx object-updating rules.
The notify sound-fading of Damusix rule is listed first in the glulx timed activity rules.

A glulx zeroing-reference rule (this is the zeroing sound-references of Damusix rule):
  damusix-zeroing-sound-references.

A glulx object-updating rule (this is the update sound-objects of Damusix rule):
  damusix-update-sound-objects.

A glulx timed activity rule (this is the notify sound-fading of Damusix rule):
  damusix-notify-sound-fading.

To damusix-zeroing-sound-references:
  (- DmxAPI__Glk_IdentifySounds(0); -)

To damusix-update-sound-objects:
  (- DmxAPI__Glk_IdentifySounds(2); -)

To damusix-notify-sound-fading:
  (- DmxAPI__Glk_FadeNotifyHandler(); -)

[==============================================================================]
[==============================================================================]

Part 2 - Damusix Startup Process - Unindexed

The Damusix startup rule is listed before initialise memory rule in the startup rules.

This is the Damusix startup rule:
  damusix-initialise.

To damusix-initialise:
  (- DmxAPI__Glk_Init(); -)

[==============================================================================]
[==============================================================================]

Part 3 - Damusix Natural Language Wrapper

Section 3.0 - Use Options

Use no sound protection translates as (- Constant DAMUSIX_NO_SOUND_PROTECTION; -).

[==============================================================================]

Section 3.1 - Sound-volume Kind

Sound-volume is a kind of value. 100% specifies a sound-volume.
The specification of sound-volume is "A percentage value between 0% and 100%, corresponding to the volume of a sound."

[Sound-volume is a kind of value. -100% specifies a sound-volume.] [ELIUK BLAU: VEREMOS SI REALMENTE ES NECESARIO PERMITIR EL ACCESO AL VALOR -1% EN ALGUNA CONFIGURACION... NO LO CREO]
[The specification of sound-volume is "A percentage value between 0% and 100%, corresponding to the volume of a sound; and the especial value -1%, representing the global volume of Damusix Sound Manager."]

[==============================================================================]

Section 3.2 - Non-Technical Audio Functions

To assign (SND - sound-name) to channel (CHN - number) with (VOL - sound-volume) volume/-- and (REP - number) repetition/repetitions:
  (- DmxAPI__ErrorEval(DmxAPI__AssignChannel(ResourceIDsOfSounds-->{SND}, {CHN}, {VOL}, {REP})); -)

To assign (SND - sound-name) to channel (CHN - number) with (VOL - sound-volume) volume/--, endless loop:
  if endless loop, assign SND to channel CHN with VOL volume and -1 repetition;
  otherwise assign SND to channel CHN with VOL volume and 1 repetition.

To assign (SND - sound-name) to channel (CHN - number) with global/-- volume/-- and/-- (REP - number) repetition/repetitions:
  (- DmxAPI__ErrorEval(DmxAPI__AssignChannel(ResourceIDsOfSounds-->{SND}, {CHN}, -1, {REP})); -)

To assign (SND - sound-name) to channel (CHN - number) with/-- global/-- volume/--, endless loop:
  if endless loop, assign SND to channel CHN with global volume and -1 repetition;
  otherwise assign SND to channel CHN with global volume and 1 repetition.

[------------------------------------------------------------------------------]

To free the/-- channel of (SND - sound-name):
  (- DmxAPI__FreeChannel(ResourceIDsOfSounds-->{SND}); -)

[------------------------------------------------------------------------------]

To enable audio:
  (- DmxAPI__EnableAudio(); -)

[------------------------------------------------------------------------------]

To disable audio:
  (- DmxAPI__DisableAudio(); -)

[------------------------------------------------------------------------------]

To dplay (SND - sound-name), notifying when finished:
  (- DmxAPI__PlaySound(ResourceIDsOfSounds-->{SND}, {phrase options}); -)

[------------------------------------------------------------------------------]

To dstop (SND - sound-name):
  (- DmxAPI__StopSound(ResourceIDsOfSounds-->{SND}); -)

[------------------------------------------------------------------------------]

[DEBATE: Aaron Reed sugiere "trigger SND". Yo, personalmente, no estoy muy
convencido con la sugerencia. Aaron tiene razon en su argumentacion, pero
sigue pareciendome que "vplay" ("virtual play") tiene mucho mas sentido.
Ademas, combina esteticamente con "dplay" y "dstop" :D]

To vplay (SND - sound-name) with (VOL - sound-volume) volume/--:
  (- DmxAPI__ErrorEval(DmxAPI__VirtualPlaySound(ResourceIDsOfSounds-->{SND}, {VOL})); -)

To vplay (SND - sound-name) with global volume:
  (- DmxAPI__ErrorEval(DmxAPI__VirtualPlaySound(ResourceIDsOfSounds-->{SND}, -1)); -)

To vplay (SND - sound-name):
  (- DmxAPI__ErrorEval(DmxAPI__VirtualPlaySound(ResourceIDsOfSounds-->{SND})); -)

[------------------------------------------------------------------------------]

[DEBATE: Aaron Reed sugiere "a time" en vez de "a duration". ¿Opiniones?]

To add (SND - sound-name) to the/-- playlist with a/-- time of (TIM - number) ms/milliseconds:
  (- DmxAPI__ErrorEval(DmxAPI__AddToPlaylist(ResourceIDsOfSounds-->{SND}, {TIM})); -)

[------------------------------------------------------------------------------]

To clear the/-- playlist:
  (- DmxAPI__ClearPlaylist(); -)

[------------------------------------------------------------------------------]

To dplay the/-- playlist with (VOL - sound-volume) volume/--:
  (- DmxAPI__RunPlaylist({VOL}); -)

To dplay the/-- playlist with global volume:
  (- DmxAPI__RunPlaylist(-1); -)

To dplay the/-- playlist:
  (- DmxAPI__RunPlaylist(); -)

[------------------------------------------------------------------------------]

To change the/-- repetition count of (SND - sound-name) to (REP - number):
  (- DmxAPI__SetSoundRepetition(ResourceIDsOfSounds-->{SND}, {REP}); -)

To change the/-- repetition count of (SND - sound-name) to endless loop:
  (- DmxAPI__SetSoundRepetition(ResourceIDsOfSounds-->{SND}, -1); -)

[------------------------------------------------------------------------------]

To change the/-- volume of (SND - sound-name) to (VOL - sound-volume):
  (- DmxAPI__SetSoundVolume(ResourceIDsOfSounds-->{SND}, {VOL}); -)

To change the/-- volume of (SND - sound-name) to global volume:
  (- DmxAPI__SetSoundVolume(ResourceIDsOfSounds-->{SND}, -1); -)

[------------------------------------------------------------------------------]

To change the/-- volume of the/-- virtual channels to (VOL - sound-volume):
  (- DmxAPI__SetVirtualVolume({VOL}); -)

To change the/-- volume of the/-- virtual channels to global volume:
  (- DmxAPI__SetVirtualVolume(-1); -)

[------------------------------------------------------------------------------]

To change the/-- volume of the/-- playlist to (VOL - sound-volume):
  (- DmxAPI__SetPlaylistVolume({VOL}); -)

To change the/-- volume of the/-- playlist to global volume:
  (- DmxAPI__SetPlaylistVolume(-1); -)

[------------------------------------------------------------------------------]

[DEBATE: Aaron Reed sugiere "global volume", a secas, en lugar de "global
volume of audio". A mi me parece que es mas clara la segunda forma, porque
el autor podria ya haber declarado antes una variable llamada "global volume".
En todo caso, he decidido ocupar la forma sugerida por Aaron. ¿Opiniones?]

To change the/-- global volume to (VOL - sound-volume):
  (- DmxAPI__SetGlobalVolume({VOL}); -)

[------------------------------------------------------------------------------]

To fade in (SND - sound-name) to (VOL - sound-volume) volume/-- over (TIM - number) ms/milliseconds:
  (- DmxAPI__FadeIn(ResourceIDsOfSounds-->{SND}, {TIM}, {VOL}); -)

To fade in (SND - sound-name) to/-- global/-- volume/-- over (TIM - number) ms/milliseconds:
  (- DmxAPI__FadeIn(ResourceIDsOfSounds-->{SND}, {TIM}); -)

[------------------------------------------------------------------------------]

To fade out (SND - sound-name) to (VOL - sound-volume) volume/-- over (TIM - number) ms/milliseconds and then dplay (PFSND - sound-name), notifying when finished:
  (- DmxAPI__FadeOut(ResourceIDsOfSounds-->{SND}, {TIM}, {VOL}, {PFSND}, {phrase options}); -)

To fade out (SND - sound-name) over (TIM - number) ms/milliseconds and then dplay (PFSND - sound-name), notifying when finished:
  (- DmxAPI__FadeOut(ResourceIDsOfSounds-->{SND}, {TIM}, 0, {PFSND}, {phrase options}); -)

To fade out (SND - sound-name) to (VOL - sound-volume) volume/-- over (TIM - number) ms/milliseconds:
  (- DmxAPI__FadeOut(ResourceIDsOfSounds-->{SND}, {TIM}, {VOL}); -)

To fade out (SND - sound-name) over (TIM - number) ms/milliseconds:
  (- DmxAPI__FadeOut(ResourceIDsOfSounds-->{SND}, {TIM}); -)

[------------------------------------------------------------------------------]

[DEBATE: Aaron Reed sugiere "fading" en lugar de "sound fading". ¿Podria esto
ser poco claro para el autor? ¿Un fading de que? ¿De una imagen, de un color?
Pienso que "sound fading" es mas claro, pero he decidido ocupar la forma
sugerida por Aaron. ¿Opiniones? (He agregado "sound" como alternativo)]

To abort the/-- sound/-- fading:
  (- DmxAPI__AbortFade(); -)

[------------------------------------------------------------------------------]

To simple fade in (SND - sound-name) to (VOL - sound-volume) volume/-- over (TIM - number) ms/milliseconds:
  (- DmxAPI__SimpleFadeIn(ResourceIDsOfSounds-->{SND}, {TIM}, {VOL}); -)

To simple fade in (SND - sound-name) to/-- global/-- volume/-- over (TIM - number) ms/milliseconds:
  (- DmxAPI__SimpleFadeIn(ResourceIDsOfSounds-->{SND}, {TIM}); -)

[------------------------------------------------------------------------------]

To simple fade out (SND - sound-name) to (VOL - sound-volume) volume/-- over (TIM - number) ms/milliseconds:
  (- DmxAPI__SimpleFadeOut(ResourceIDsOfSounds-->{SND}, {TIM}, {VOL}); -)

To simple fade out (SND - sound-name) over (TIM - number) ms/milliseconds:
  (- DmxAPI__SimpleFadeOut(ResourceIDsOfSounds-->{SND}, {TIM}); -)

[==============================================================================]

Section 3.3 - Technical Audio Functions

To dplay channel (CHN - number), notifying when finished:
  (- DmxAPI__ErrorEval(DmxAPI__PlayChannel({CHN}, {phrase options})); -)

[------------------------------------------------------------------------------]

To dstop channel (CHN - number):
  (- DmxAPI__ErrorEval(DmxAPI__StopChannel({CHN})); -)

[------------------------------------------------------------------------------]

[OBSERVACION: 'canales extra' se refiere a todos los canales virtuales + el canal para la playlist]

To dstop the/-- extra channels:
  (- DmxAPI__StopExtraChannels(); -)

[------------------------------------------------------------------------------]

To dstop all sounds:
  (- DmxAPI__StopAll(); -)

[------------------------------------------------------------------------------]

To change the/-- repetition count of channel (CHN - number) to (REP - number):
  (- DmxAPI__ErrorEval(DmxAPI__SetChannelRepetition({CHN}, {REP})); -)

To change the/-- repetition count of channel (CHN - number) to endless loop:
  (- DmxAPI__ErrorEval(DmxAPI__SetChannelRepetition({CHN}, -1)); -)

[------------------------------------------------------------------------------]

To change the/-- volume of channel (CHN - number) to (VOL - sound-volume):
  (- DmxAPI__ErrorEval(DmxAPI__SetChannelVolume({CHN}, {VOL})); -)

To change the/-- volume of channel (CHN - number) to global volume:
  (- DmxAPI__ErrorEval(DmxAPI__SetChannelVolume({CHN}, -1)); -)

[==============================================================================]

Section 3.4 - Audio Information Functions

To say damusix-version:
  (- print (string)_DAMUSIX_VERSION_; -)

[------------------------------------------------------------------------------]

To decide what number is the/-- channel assigned to (SND - sound-name):
  (- (DmxAPI__FindChannel(ResourceIDsOfSounds-->{SND})) -)

[------------------------------------------------------------------------------]

To decide what sound-name is the/-- sound assigned to channel (CHN - number):
  (- (DmxAPI__ErrorEval(DmxAPI__FindSound({CHN}))) -)

[------------------------------------------------------------------------------]

To decide if full audio is supported:
  (- (DmxAPI__IsAudioSupported()) -)

[DEBATE: ¿Que es mejor aqui: "is unsupported" o "is not supported"? ¿Opiniones?]

To decide if full audio is unsupported:
  (- (DmxAPI__IsAudioSupported()==0) -)

[------------------------------------------------------------------------------]

To decide if audio is enabled:
  (- (DmxAPI__IsAudioEnabled()) -)

To decide if audio is disabled:
  (- (DmxAPI__IsAudioEnabled()==0) -)

[------------------------------------------------------------------------------]

To decide what number is the/-- number of sounds in the/-- playlist:
  (- (DmxAPI__CountPlaylistItems()) -)

[------------------------------------------------------------------------------]

To decide what number is the/-- repetition count of (SND - sound-name):
  (- (DmxAPI__ErrorEval(DmxAPI__GetSoundRepetition(ResourceIDsOfSounds-->{SND}))) -)

[------------------------------------------------------------------------------]

To decide what sound-volume is the/-- volume of (SND - sound-name):
  (- (DmxAPI__ErrorEval(DmxAPI__GetSoundVolume(ResourceIDsOfSounds-->{SND}))) -)

[------------------------------------------------------------------------------]

To decide what sound-volume is the/-- volume of the/-- virtual channels:
  (- (DmxAPI__GetVirtualVolume()) -)

[------------------------------------------------------------------------------]

To decide what sound-volume is the/-- volume of the/-- playlist:
  (- (DmxAPI__GetPlaylistVolume()) -)

[------------------------------------------------------------------------------]

[DEBATE: Aaron Reed sugiere "global volume", a secas, en lugar de "global
volume of audio". A mi me parece que es mas clara la segunda forma, porque
el autor podria ya haber declarado antes una variable llamada "global volume".
En todo caso, he dedicido ocupar la forma sugerida por Aaron. ¿Opiniones?]

To decide what sound-volume is the/-- global volume:
  (- (DmxAPI__GetGlobalVolume()) -)

[------------------------------------------------------------------------------]

To decide if (SND - sound-name) is playing in the/-- background:
  (- (DmxAPI__IsSoundPIB(ResourceIDsOfSounds-->{SND})) -)

To decide if (SND - sound-name) is not playing in the/-- background:
  (- (DmxAPI__IsSoundPIB(ResourceIDsOfSounds-->{SND})==0) -)

[------------------------------------------------------------------------------]

[DEBATE: Aaron Reed sugiere "fading" en lugar de "sound fading". ¿Podria esto
ser poco claro para el autor? ¿Un fading de que? ¿De una imagen, de un color?
Pienso que "sound fading" es mas claro, pero he decidido ocupar la forma
sugerida por Aaron. ¿Opiniones? (He agregado "sound" como opcional)]

To decide if sound/-- fading is in progress:
  (- (DmxAPI__IsFadeInProgress()) -)

To decide if sound/-- fading is not in progress:
  (- (DmxAPI__IsFadeInProgress()==0) -)

[------------------------------------------------------------------------------]

To decide what number is the/-- repetition count of channel (CHN - number):
  (- (DmxAPI__ErrorEval(DmxAPI__GetChannelRepetition({CHN}))) -)

[------------------------------------------------------------------------------]

To decide what sound-volume is the/-- volume of channel (CHN - number):
  (- (DmxAPI__ErrorEval(DmxAPI__GetChannelVolume({CHN}))) -)

[------------------------------------------------------------------------------]

To decide if channel (CHN - number) is playing in the/-- background:
  (- (DmxAPI__ErrorEval(DmxAPI__IsChannelPIB({CHN}))) -)

To decide if channel (CHN - number) is not playing in the/-- background:
  (- (DmxAPI__ErrorEval(DmxAPI__IsChannelPIB({CHN}))==0) -)

[==============================================================================]
[==============================================================================]

Part 4 - All Beautiful I6 Code - Unindexed

Section 4.0 - Warning Texts

Include (-

#ifdef DEBUG;
  ! CONSTANTES PARA INTERNACIONALIZACION DE MENSAJES DE AVISO/ADVERTENCIA
  ! ***I7-COMP-(01): SE DEBEN 'CODIFICAR' TODOS LOS CARACTERES 'NO-ANGLOSAJONES'
  Constant DMX_ERRMSG__GLK_NO_FULL_AUDIO =
             "[WARNING: Your interpreter does not completely support audio!]^
              [-Sounds and music may not be played-]^";

  Constant DMX_ERRMSG__PLAYLIST_IS_FULL =
             "[ERROR: The playlist is filled up!]^
              [-Cannot add another sound if the playlist is already full-]^";

  Constant DMX_ERRMSG__PLAYLIST_DURING_FADE =
             "[ERROR: Currently in the process of fading!]^
              [-Cannot play the playlist during a fade-]^";

  Constant DMX_ERRMSG__FADE_DURING_FADE =
             "[ERROR: Currently in the process of fading!]^
              [-Cannot begin a new fade until the current fade is finished-]^";
#endif; ! DEBUG

!-------------------------------------------------------------------------------

! ***I7-COMP-(02a): MENSAJE DE ERROR PARA EL WRAPPER DmxAPI__ErrorEval()
Constant DMX_ERRMSG__WRAPPER_BAD_SOUND =
           "[ERROR: Bad Sound! (Blorb-ID for this resource is incorrect)]^
            [-Returned a value of 0 (FALSE), but this is not correct-]^";

! ***I7-COMP-(02a): MENSAJE DE ERROR PARA EL WRAPPER DmxAPI__ErrorEval()
Constant DMX_ERRMSG__WRAPPER_BAD_CHANNEL =
           "[ERROR: Bad Channel! (requires a value between 0 and 9)]^
            [-Returned a value of 0 (FALSE), but this is not correct-]^";

-) after "Glulx.i6t".

[==============================================================================]

Section 4.1 - Damusix I6 Engine - Unindexed

Include (-

! ***I7-COMP-(02b): WRAPPER PARA EVALUAR UN RETORNO CON ERROR Y MOSTRAR AVISO
[ DmxAPI__ErrorEval aux msg;
  switch (aux) {
    DAMUSIX_ERROR_SND: msg = DMX_ERRMSG__WRAPPER_BAD_SOUND;   ! los mensaje de aviso en
    DAMUSIX_ERROR_CNL: msg = DMX_ERRMSG__WRAPPER_BAD_CHANNEL; ! caso de error; si no...
    default: return aux; ! ... devolvemos valor de retorno y terminamos aqui
  }
  ! En caso de error, mostramos el mensaje de aviso pertinente
  glk_set_style(style_Preformatted);
  new_line;
  print (string) msg; ! texto del mensaje de aviso
  new_line;
  glk_set_style(style_Normal);
  return 0;
];

!===============================================================================

! LA VERSION DE LA EXTENSION DAMUSIX
Constant _DAMUSIX_VERSION_ = "4.0.0";

!===============================================================================

! CONSTANTES DE UTILIDAD PARA DAMUSIX
Constant DAMUSIX_ERROR_SND    = -99;            ! SONIDO INCORRECTO (SIN GESTION/ERRONEO)
Constant DAMUSIX_ERROR_CNL    = -66;            ! CANAL INCORRECTO (EL NUMERO ES ERRONEO)
Constant DAMUSIX_GG_ROCK      = 510;            ! ROCK CANAL CERO (en siguientes, sumar 1)
Constant DAMUSIX_VOLMAX       = $10000/100;     ! EL VOLUMEN MAXIMO (para los porcentajes)
Constant DAMUSIX_NCANALMAX    = 10;             ! MAX. DE CANALES NORMALES QUE SE CREARAN  (gg_ncnl)
Constant DAMUSIX_VCANALMAX    = 10;             ! MAX. DE CANALES VIRTUALES QUE SE CREARAN (gg_vcnl)
Constant DAMUSIX_SNDLSTMAX    = 10;             ! MAX. DE SONIDOS DISPONIBLES EN 'LISTA DE REPROD.'

!===============================================================================

!=============================================================================
!-----------------------------------------------------------------------------
! *** RUTINAS Y VARIABLES PRIVADAS RELACIONADAS CON EL TRABAJO DEL KERNEL ***
!-----------------------------------------------------------------------------
!=============================================================================
Global    DmxSTM__glk_sin_audio      = false;                       ! la Glk del interprete no puede reproducir audio? (sonido sampleado y MODs)
Global    DmxSTM__audio_activado     = true;                        ! esta ACTIVADA la salida de audio de Damusix? (por defecto siempre activada)
Global    DmxSTM__que_vcnl           = 0;                           ! que numero de canal virtual sera usado para el siguente sonido? (0 al inicio)
Global    DmxSTM__que_fade           = 0;                           ! que tipo de Fade esta haciendo un canal normal? ( 0==Ninguno; 1==FadeIn; 2==FadeOut )
Array     DmxSTM__vol_fade           --> 0 0 0;                     ! datos de volumen para Fades ( -->0==vol.inicial; -->1==vol.final; -->2==vol.original )
Global    DmxSTM__cnl_fade           = -1;                          ! canal normal asignado al sonido que esta haciendo el Fade [ -1=='sin canal' ]
Global    DmxSTM__tick_fade          = 0;                           ! guarda calculo del tiempo de cada tick del Fade actual (truco UNDO/RESTORE/RESTART)
Array     DmxSTM__snd_pfadeout       --> 0 0;                       ! sonido que debe tocarse luego del Fade [ -->0==sonido; -->1==notificar? ]
Global    DmxSTM__vol_global         = 100;                         ! porcentaje de volumen global actual (valor entre 0%-100% [por defecto 100%])
Global    DmxSTM__vol_vcnl           = 100;                         ! porcentaje de volumen comun actual para canales 'virtuales' (por defecto 100%)
Global    DmxSTM__vol_lcnl           = 100;                         ! porcentaje de volumen comun actual para 'lista de reprod.' (por defecto 100%)
Global    DmxSTM__gg_lcnl            = 0;                           ! la referencia interna del canal para 'lista de reprod. de sonidos'
Array     DmxSTM__gg_ncnl            --> DAMUSIX_NCANALMAX;         ! las referencias internas de los 'canales normales'
Array     DmxSTM__gg_vcnl            --> DAMUSIX_VCANALMAX;         ! las referencias internas de los 'canales virtuales'
Array     DmxSTM__snd_cnl            --> DAMUSIX_NCANALMAX;         ! el sonido que se toca en cada canal normal
Array     DmxSTM__vol_cnl            --> DAMUSIX_NCANALMAX;         ! el volumen de cada canal normal (en porcentajes)
Array     DmxSTM__rep_cnl            --> DAMUSIX_NCANALMAX;         ! el modo de repeticion de cada canal normal ('LOOP' se indica con -1)
Array     DmxSTM__est_cnl            --> DAMUSIX_NCANALMAX;         ! estado del sonido de cada canal normal ( 0==det./'rep.finita'; 1==reprod. )
Array     DmxSTM__pib_reg            --> (DAMUSIX_NCANALMAX+1);     ! registro del estado PIB (UNDO/RESTORE/RESTART) [ -->10==audio_activado? ]
Array     DmxSTM__snd_lst            --> (DAMUSIX_SNDLSTMAX*2);     ! array de 'lista de reprod. de sonidos' ( slots==DAMUSIX_SNDLSTMAX*2 )
                                                                    ! (... la columna par guarda sonidos; la impar, los tiempos de espera)

! [KERNEL-1] ACTUALIZA TODO LO RELACIONADO CON UN CANAL NORMAL ESPECIFICO
! (estado de reproduccion, volumen, sonido inexistente, audio desactivado, etc.)
[ DmxAPI__Kernel_UpdateChannel nc esn ! nc: num. canal; esn: arg. oscuro, SoundNotify? (0==no; 1==si)
  pib ! arg. osc., actualizar estado PIB? [usado en Kernel_UpdateAllChannels() desde DmxAPI__Glk_IdentifySounds()]
  flag_ok_play; ! reproducir el canal? (cuando el estado PIB indique que no, valdra FALSE)
  !-------------------------------------------------------------------------
  ! si el audio no esta soportado, no se hace nada mas
  if (DmxSTM__glk_sin_audio) { return; }
  !-------------------------------------------------------------------------
  ! detiene el canal si no posee sonido asignado o si el estado del
  ! sonido es cero (detenido o 'lanzado con reproduccion finita')
  if ((DmxSTM__snd_cnl-->nc == 0) || (DmxSTM__est_cnl-->nc == 0)) {
    ! detenemos el canal actual y retornamos sin hacer nada mas
    glk_schannel_stop(DmxSTM__gg_ncnl-->nc);
    DmxAPI__Kernel_UpdatePIB(nc, pib); ! MUY IMPORTANTE: ACTUALIZAMOS ESTADO PIB
    return;
  }
  !-------------------------------------------------------------------------
  ! solo en el caso de que sonido NO DEBA TOCARSE INFINITAMENTE [rep ~= -1]
  ! ponemos el 'estado del sonido'==0 ('lanzado con reproduccion finita')
  if (DmxSTM__rep_cnl-->nc ~= -1) { DmxSTM__est_cnl-->nc = 0; }
  !-------------------------------------------------------------------------
  ! MUY IMPORTANTE: ACTUALIZAMOS AHORA REGISTRO DEL ESTADO PIB Y AVISAMOS...
  flag_ok_play = DmxAPI__Kernel_UpdatePIB(nc, pib); ! SI SE DEBE 'RE-LANZAR' CANAL
  !-------------------------------------------------------------------------
  ! SI SALIDA DE AUDIO ESTA DESACTIVADA: DETENEMOS CANAL Y EVITAMOS REPROD.
  ! **** NOTA: NO CAMBIAR ESTE TROZO DE CODIGO DE POSICION!!!! ****
  if (~~DmxSTM__audio_activado) {
    ! detenemos el canal actual y retornamos sin hacer nada mas
    glk_schannel_stop(DmxSTM__gg_ncnl-->nc);
    return;
  }
  !-------------------------------------------------------------------------
  ! SI TODO LO ANTERIOR SE HA SUPERADO, INICIAMOS AHORA LA REPRODUCCION
  !-------------------------------------------------------------------------
  ! el interprete puede cambiar el volumen? Si es asi: cambialo ahora
  if (glk_gestalt(gestalt_SoundVolume,0)) {
    glk_schannel_set_volume(DmxSTM__gg_ncnl-->nc, (DmxSTM__vol_cnl-->nc) * DAMUSIX_VOLMAX);
  }
  ! y ahora tocamos ahora el sonido efectivamente...
  if (flag_ok_play) { ! siempre y cuando la actualizacion PIB no lo haya negado!!
    glk_schannel_play_ext(
      DmxSTM__gg_ncnl-->nc, ! el canal
      DmxSTM__snd_cnl-->nc, ! el sonido
      DmxSTM__rep_cnl-->nc, ! las repeticiones
      esn);               ! generar ev. SoundNotify al terminar? (0==no; 1==si)
  }
];

! [KERNEL-2] REALIZA UNA ACTUALIZACION MASIVA DE TODOS LOS CANALES NORMALES
! Ademas se invocara la actualizacion del registro del estado PIB, en el caso
! que sea llamada con 'pib'==1 [uso exclusivo en rutina DmxAPI__Glk_IdentifySounds()]
[ DmxAPI__Kernel_UpdateAllChannels pib ! arg. oscuro, actualizar el registro del estado PIB?
  i; ! para iteraciones
  !-------------------------------------------------------------------------
  ! NOTA: aqui no comprobamos si la Glk soporta sonido o si la salida de
  ! audio esta activada, porque ya lo hace la propia rutina de abajo
  !-------------------------------------------------------------------------
  ! recorre todos los canales normales y los actualiza (con su registro PIB)
  for (i=0 : i<DAMUSIX_NCANALMAX : i=i+1) { DmxAPI__Kernel_UpdateChannel(i,0,pib); }
  !-------------------------------------------------------------------------
  ! MUY IMPORTANTE: Guarda estado actual de activacion del audio. Esto es
  ! necesario que se haga aqui cuando se ha invocado una actualizacion PIB
  ! [*** EVITA UN POTENCIAL BUG ***] - NO MODIFICAR NI CAMBIAR DE POSICION
  #ifndef DAMUSIX_NO_SOUND_PROTECTION;
  if (pib == 1) { DmxSTM__pib_reg-->DAMUSIX_NCANALMAX = DmxSTM__audio_activado; }
  #endif; ! DAMUSIX_NO_SOUND_PROTECTION
];

! [KERNEL-3] ACTUALIZA REGISTRO DEL ESTADO PIB DE UN CANAL NORMAL ESPECIFICO
! [usado exclusivamente en la rutina interna del Kernel-1 Kernel_UpdateChannel()]
! El registro del estado PIB de los canales normales de Damusix es un truco
! complejo para lograr que los sonidos no sean re-lanzados si actualmente
! estan 'sonando de fondo' (es decir, reproduciendose con 'rep. infinitas'
! [est_cnl==1]) y el jugador hace UNDO/RESTORE/RESTART en el juego. La Glk
! no tiene un sistema para conservar el 'estado de reproduccion' de los
! sonidos, asi que cuando se recuperan referencias [en IdentifyGlkObject()]
! es preciso 'volver a lanzar' la reproduccion de todos los sonidos que lo
! necesiten. El 'Registro del Estado PIB' es un array que se 'sincroniza'
! con los datos de los canales (concretamente, con los sonidos del canal y
! con su 'estado de reproduccion', si actualmente esta 'sonando de fondo').
! Gracias a una llamada en ensamblador de Glulx, se pueden "proteger" los
! datos del registro PIB ante los comandos UNDO/RESTORE/RESTART a fin de
! poder "compararlos" con los datos del kernel de Damusix recuperados luego
! de cambiar el "estado del juego". Esta "comparacion" logra la "magia" de
! hacer que si los sonidos estan actualmente 'sonando de fondo' (segun el
! Kernel de Damusix) y si esos mismos sonidos "ya estaban sonando de fondo"
! antes del UNDO/RESTORE/RESTART, significa que todavia estan "sonando"
! y no se debe volver a lanzarlos. Y se aprovecha para actualizar el PIB.
! [La llamada para proteger el registro PIB esta en DmxAPI__Glk_IdentifySounds()]
! [Si Kernel_UpdatePIB() devuelve TRUE, Kernel_UpdateChannel() no debe re-lanzar]
! ['PIB' quiere decir: "Playing in the Background" (Sonando de Fondo) =P]
[ DmxAPI__Kernel_UpdatePIB nc pib ! nc: num. canal; pib: calc. re-lanzamiento canal?
  ok_play; ! flag val. de ret. que indica si se debe "re-lanzar" el canal
  !=========================================================================
  ! ** LO SIGUIENTE ES SIMPLEMENTE PARA EVITAR UN WARNING SI SE COMPILA **
  ! ** NO UTILIZANDO LA "PROTECCION DE SONIDOS" QUE PROPORCIONA DAMUSIX **
  !-------------------------------------------------------------------------
    #ifdef DAMUSIX_NO_SOUND_PROTECTION;
    nc = nc; pib = pib; ! esto evita un warning de variables no usadas
    #endif; ! DAMUSIX_NO_SOUND_PROTECTION
  !=========================================================================
  ok_play = true; ! idealmente, siempre se deberia re-lanzar el canal
  #ifndef DAMUSIX_NO_SOUND_PROTECTION;
  !-------------------------------------------------------------------------
  ! PARTE 1: ANALIZAMOS SI SE DEBE 'RE-LANZAR' CANAL INDICADO (SEGUN PIB)
  !-------------------------------------------------------------------------
  !** 'pib' VALE 1 SOLO CUANDO se llama desde rutina DmxAPI__Glk_IdentifySounds()**
  if (pib == 1) { ! '1' INDICA QUE SE DEBE "CALCULAR" SI HAY QUE RE-LANZAR
    ! si el sonido asignado actualmente al canal es igual que el sonido
    ! "previo-al-cambio-de-estado-del-juego" (registrado en el PIB)...
    if (DmxSTM__snd_cnl-->nc == DmxSTM__pib_reg-->nc) {
      ! y si el PIB indica que antes del "cambio-de-estado" el audio
      ! SI ESTABA ACTIVADO (porque podemos 'recuperar' con el audio
      ! desactivado, caso en el que no hay que 're-lanzar' canales)
      if (DmxSTM__pib_reg-->DAMUSIX_NCANALMAX == true) { ! NO BORRAR!!
        ok_play = false; ! indicamos que no se debe "re-lanzar" el canal
      }
    }
  }
  else {
    !** 'pib' NO VALE 1 CUANDO se llama fuera de DmxAPI__Glk_IdentifySounds()**
    ! (el resto de rutinas del Gestor SIEMPRE DEBERIAN RE-LANZAR CANAL)
    ! [ahora aprovechamos de guardar el estado de activacion del audio]
    ! [si 'pib'==1, activ. se guarda desde la rut. Kernel_UpdateAllChannels()]
    DmxSTM__pib_reg-->DAMUSIX_NCANALMAX = DmxSTM__audio_activado; ! NO BORRAR!!
  }
  !-------------------------------------------------------------------------
  ! PARTE 2: ACTUALIZAMOS AHORA REGISTRO DEL ESTADO PIB DEL CANAL INDICADO
  !-------------------------------------------------------------------------
  if (DmxSTM__est_cnl-->nc == 1) { ! si canal actual ESTA 'SONANDO DE FONDO'
    DmxSTM__pib_reg-->nc = DmxSTM__snd_cnl-->nc; ! guardamos ese dato en el PIB
  }
  else { ! si el canal actual NO ESTA 'SONANDO DE FONDO', guardamos...
    DmxSTM__pib_reg-->nc = 0; ! un valor nulo en el PIB (MUY IMPORTANTE!!)
    !-----------------------------------------------------------------------
    ! Este sistema lo unico que hace es "recordar" solamente aquellos
    ! canales que estan 'sonando de fondo' y "calcular", en consecuencia,
    ! sus "potenciales re-lanzamientos". Si un canal no esta 'sonando de
    ! fondo', no tiene motivo de ser "recordado" por el registro PIB. =P
    !-----------------------------------------------------------------------
  }
  #endif; ! DAMUSIX_NO_SOUND_PROTECTION
  !-------------------------------------------------------------------------
  ! MUY IMPORTANTE: Finalmente retornamos indicando si se permite o no...
  return ok_play; ! 're-lanzar' el canal [Kernel_UpdateChannel() usa este valor]
];

! Realiza una pausa con ayuda del Timer [usada por DmxAPI__RunPlaylist() y DmxAPI__Fade***X()]
[ DmxAPI__Helper_Sleep ms; ! los milisegundos que durara la pausa temporizada
  ! provocamos un 'tick' del Timer cada 'ms' milisegundos
  glk_request_timer_events(ms);
  for (::) { ! un bucle infinito
    glk_select(gg_event); ! averiguamos el evento generado
    switch (gg_event-->0) {
      evtype_Timer: ! se genero un 'tick' del Timer?
        jump DmxAPI__HacerPausaFin; ! entonces debemos salir del bucle
      !---------------------------------------------------------------------
      evtype_Arrange,evtype_Redraw: ! se produjo cambio en las Ventanas?
        DrawStatusLine(); ! entonces debemos redibujar la barra de estado...
        HandleGlkEvent(gg_event,1,gg_arguments); ! y actualizar las ventanas
    }
  }
  .DmxAPI__HacerPausaFin; ! etiqueta auxiliar para salir del bucle
  ! finalmente detenemos los 'ticks' del Timer
  glk_request_timer_events(0);
];

! Esta rutina se llama automaticamente luego de hacer UNDO/RESTORE/RESTART
! [es llamada desde DmxAPI__Glk_IdentifySounds()] y simplemente sirve para comprobar
! si en el "nuevo estado del juego" existe un Fade activo. De ser asi, se
! reinicia el Timer (podria estar desprogramado) para continuar el Fade
[ DmxAPI__Helper_RestoreFade ;
  ! el interprete puede manejar el Timer? Si no: no hacemos nada mas
  if (glk_gestalt(gestalt_Timer,0) == 0) { return; }
  !-------------------------------------------------------------------------
  ! hay en proceso algun trabajo de Fade? Si no: no hacemos nada mas
  if (~~DmxAPI__IsFadeInProgress()) { return; }
  !-------------------------------------------------------------------------
  ! SI EL CANAL EN FADE ESTA 'SONANDO DE FONDO' ACTUALMENTE...
  if (DmxSTM__est_cnl-->(DmxSTM__cnl_fade) == 1) {
    glk_request_timer_events(DmxSTM__tick_fade); ! reiniciamos el Timer
  }
  else { ! SI EL CANAL EN FADE NO ESTA 'SONANDO DE FONDO' ACTUALMENTE...
    DmxAPI__AbortFade(); ! acabamos con el efecto de Fade totalmente!!
  }
];

! Hace efecto de Fade (1==FadeIn o 2==FadeOut) [es llamada por DmxAPI__Glk_FadeNotifyHandler()]
[ DmxAPI__Helper_DoFade ;
  ! que tipo de Fade? (segun tipo: subimos/bajamos porcentaje de volumen)
  switch (DmxSTM__que_fade) {
    1: ! en FadeIn
        DmxSTM__vol_fade-->0 = (DmxSTM__vol_fade-->0)+1; ! subimos 1 unidad vol.
        !--------------------------------------------------------------------
        ! mientras 'volumen inicial' sea menor o igual al 'volumen final'
        if ((DmxSTM__vol_fade-->0) <= (DmxSTM__vol_fade-->1)) {
          ! cambiamos % de volumen que corresponde en este 'tick' del Timer
          DmxAPI__SetChannelVolume(DmxSTM__cnl_fade, DmxSTM__vol_fade-->0);
          !------------------------------------------------------------------
          ! si llegamos al 'volumen final', es momento de terminar el Fade
          if ((DmxSTM__vol_fade-->0) >= (DmxSTM__vol_fade-->1)) {
            DmxAPI__AbortFade(); ! abortamos el efecto de Fade
            return; ! y terminamos aqui
          }
        }

    2: ! en FadeOut
        DmxSTM__vol_fade-->0 = (DmxSTM__vol_fade-->0)-1; ! bajamos 1 unidad vol.
        !--------------------------------------------------------------------
        ! mientras 'volumen inicial' sea mayor o igual al 'volumen final'
        if ((DmxSTM__vol_fade-->0) >= (DmxSTM__vol_fade-->1)) {
          ! cambiamos % de volumen que corresponde en este 'tick' del Timer
          DmxAPI__SetChannelVolume(DmxSTM__cnl_fade, DmxSTM__vol_fade-->0);
          !------------------------------------------------------------------
          ! si llegamos al 'volumen final', es momento de terminar el Fade
          if ((DmxSTM__vol_fade-->0) <= (DmxSTM__vol_fade-->1)) {
            DmxAPI__AbortFade(); ! abortamos el efecto de Fade
            !----------------------------------------------------------------
            ! ademas, si tenemos un sonido post-fadeout lo tocamos
            if (DmxSTM__snd_pfadeout ~= 0) {
              ! tocamos el sonido y si tiene que notificar eventos lo hacemos constar
              DmxAPI__PlaySound(DmxSTM__snd_pfadeout-->0, DmxSTM__snd_pfadeout-->1);
            }
            !----------------------------------------------------------------
            return; ! y terminamos aqui
          }
        }
  }
];

! Comprueba si el interprete tiene soporte completo de audio; si no lo tiene,
! activa el valor del flag 'glk_sin_audio' para reportarlo al kernel de Damusix
[ DmxAPI__Helper_CheckGlkAudio
  aux; ! se deben mostrar avisos textuales (1==si, 0==no)
  ! Comprobamos si interprete tiene SOPORTE COMPLETO de audio y avisamos al Kernel
  if (DmxAPI__IsAudioSupported()) { DmxSTM__glk_sin_audio = false; } ! tiene soporte completo
  else { DmxSTM__glk_sin_audio = true; } ! no tiene soporte completo de audio
  !-------------------------------------------------------------------------
  #ifdef DEBUG;
    ! si el audio no esta soportado, avisa de la situacion
    if ((aux==1) && (DmxSTM__glk_sin_audio)) {
      glk_set_style(style_Preformatted);
      new_line;
      print (string) DMX_ERRMSG__GLK_NO_FULL_AUDIO; ! mensaje de aviso
      new_line;
      glk_set_style(style_Normal);
    }
  #endif; ! DEBUG
  !-------------------------------------------------------------------------
  aux = aux; ! simplemente para evitar un warning del compilador
];

!=============================================================================
!-----------------------------------------------------------------------------
! *** INICIALIZAR DAMUSIX (EL PROGRAMADOR JAMAS DEBE LLAMAR A ESTA RUTINA)***
!-----------------------------------------------------------------------------
!=============================================================================

! [AUX. KERNEL] INICIALIZA EL GESTOR DE AUDIO DE DAMUSIX Y TODOS SUS CANALES
! (NORMALES/VIRTUALES) *NOTA: EL PROGRAMADOR JAMAS DEBE LLAMAR A ESTA RUTINA
[ DmxAPI__Glk_Init
  i;  ! para iteraciones
  !-------------------------------------------------------------------------
  ! si el audio no esta soportado, no se hace nada mas...
  DmxAPI__Helper_CheckGlkAudio(1); if (DmxSTM__glk_sin_audio) { return; } ! (1==mostrar avisos)
  !-------------------------------------------------------------------------
  ! MUY IMPORTANTE: BORRAMOS COMPLETAMENTE EL REGISTRO DEL ESTADO PIB...
  ! [esto es vital para obtener un inicio de juego limpio en un 'RESTART']
  #ifndef DAMUSIX_NO_SOUND_PROTECTION;
  for (i=0 : i<=DAMUSIX_NCANALMAX : i=i+1) { DmxSTM__pib_reg-->i = 0; }
  #endif; ! DAMUSIX_NO_SOUND_PROTECTION
  !-------------------------------------------------------------------------
  ! creamos los canales normales, efectivamente, en array Damusix.gg_ncnl
  for (i=0 : i<DAMUSIX_NCANALMAX : i=i+1) {
    ! solo si el canal no existe tiene sentido crearlo
    if (DmxSTM__gg_ncnl-->i == 0) {
      ! rock_inicial+i = rocks para canales 'normales'
      DmxSTM__gg_ncnl-->i = glk_schannel_create(DAMUSIX_GG_ROCK+i); ! 510+i
    }
  }
  !-------------------------------------------------------------------------
  ! creamos los canales virtuales, efectivamente, en array Damusix.gg_vcnl
  for (i=0 : i<DAMUSIX_VCANALMAX : i=i+1) {
    ! solo si el canal no existe tiene sentido crearlo
    if (DmxSTM__gg_vcnl-->i == 0) {
      ! rock_inicial+canales_normales+i = rocks para canales 'virtuales'
      DmxSTM__gg_vcnl-->i = glk_schannel_create(DAMUSIX_GG_ROCK+DAMUSIX_NCANALMAX+i);
    }
  }
  !-------------------------------------------------------------------------
  ! creamos el canal para la 'lista de reproduccion de sonidos' en gg_lcnl
    if (DmxSTM__gg_lcnl == 0) { ! solo si el canal no existe tiene sentido crearlo
      ! rock_inicial+canales_normales+canales_virtuales = rock para canal 'lista de reprod.'
      DmxSTM__gg_lcnl = glk_schannel_create(DAMUSIX_GG_ROCK+DAMUSIX_NCANALMAX+DAMUSIX_VCANALMAX);
    }
];

!=============================================================================
!-----------------------------------------------------------------------------
! *** RUTINAS GANCHO DE DAMUSIX RELACIONADAS CON LOS PUNTOS DE ENTRADA GLK ***
!-----------------------------------------------------------------------------
!=============================================================================

! IDENTIFICA LOS OBJETOS GLK QUE SON SONIDOS [para IdentifyGlkObject()]
[ DmxAPI__Glk_IdentifySounds fase ! la fase actual
  id i; ! id: el canal identificado; i: para iteraciones
  !-------------------------------------------------------------------------
  ! IMPORTANTE: si el audio no esta soportado, no se hace nada mas...
  DmxAPI__Helper_CheckGlkAudio(0); if (DmxSTM__glk_sin_audio) { return; } ! (0==no mostrar avisos)
  !=========================================================================
  ! MUY IMPORTANTE: PROTEGEMOS AREA DE MEMORIA DEL REGISTRO DEL ESTADO PIB
  !-------------------------------------------------------------------------
    #ifndef DAMUSIX_NO_SOUND_PROTECTION;
    i = DmxSTM__pib_reg;  ! usamos variable local 'i' solo por comodidad
    ! id = DmxSTM__#pib_reg; ! usamos variable local 'id' solo por comodidad
    id = DAMUSIX_NCANALMAX+1; ! usamos variable local 'id' solo por comodidad
    @protect i id;      ! ahora invocamos la proteccion del registro (asm)
    #endif; ! DAMUSIX_NO_SOUND_PROTECTION
  !=========================================================================
  ! FASE 0: Elimina las referencias a los canales de sonido (objetos gg_*)
  ! [las pone todas a cero]
  if (fase == 0) {
    !-----------------------------------------------------------------------
    ! NOTA: 'DAMUSIX_NCANALMAX' Y 'DAMUSIX_VCANALMAX' SON ABSOLUTAMENTE
    ! NECESARIOS PARA RECORRER TODOS LOS CANALES, NO IMPORTA SI NO SE HAN
    ! CREADO EFECTIVAMENTE TODOS (SI NO, NO ELIMINA BIEN SUS REFERENCIAS)
    !-----------------------------------------------------------------------
    ! recorre todos los canales 'normales' creados y borra sus referencias
    for (i=0 : i<DAMUSIX_NCANALMAX : i=i+1) { DmxSTM__gg_ncnl-->i = 0; }
    ! recorre todos los canales 'virtuales' creados y borra sus referencias
    for (i=0 : i<DAMUSIX_VCANALMAX : i=i+1) { DmxSTM__gg_vcnl-->i = 0; }
    ! borra la referencia del canal para la 'lista de reprod. de sonidos'
    DmxSTM__gg_lcnl = 0;
    ! y retornamos porque no hay nada mas que hacer aqui
    return;
  }
  !
  !=========================================================================
  ! OBSERVACION: Damusix no utiliza la FASE 1 porque no es necesaria
  !              para las funciones de audio en Inform-Glulx.
  !=========================================================================
  !
  !-------------------------------------------------------------------------
  ! FASE 2: Se inicializan los objetos gg_* que apuntan a los canales de
  ! sonido (afecta a 'gg_ncnl', 'gg_vcnl' y 'gg_lcnl')
  if (fase == 2) {
    ! itera en los canales de sonido para identificar
    ! el primer objeto de sonido y guarda su referencia
    ! en el array de la libreria Inform 'gg_arguments'
    id = glk_schannel_iterate(0, gg_arguments);
    ! ahora comienza la busqueda efectiva y la asignacion de
    ! referencias actuales a cada uno de los distintos canales
    while (id) {
      !---------------------------------------------------------------------
      ! NOTA: 'DAMUSIX_NCANALMAX' Y 'DAMUSIX_VCANALMAX' SON ABSOLUTAMENTE
      ! NECESARIOS PARA RECORRER TODOS LOS CANALES, NO IMPORTA SI NO SE HAN
      ! CREADO EFECTIVAMENTE TODOS (SI NO, NO RECUPERA BIEN SUS REFERENCIAS)
      !---------------------------------------------------------------------
      ! si son los canales 'normales' de Damusix, asigna sus referencias
      !---------------------------------------------------------------------
      for (i=0 : i<DAMUSIX_NCANALMAX : i=i+1) {
        ! rock_inicial+i = rocks para canales 'normales'
        if (gg_arguments-->0 == DAMUSIX_GG_ROCK+i) { ! 510+i
          DmxSTM__gg_ncnl-->i = id;
        }
      }
      !---------------------------------------------------------------------
      ! si son los canales 'virtuales' de Damusix, asigna sus referencias
      !---------------------------------------------------------------------
      for (i=0 : i<DAMUSIX_VCANALMAX : i=i+1) {
        ! rock_inicial+canales_normales+i = rocks para canales 'virtuales'
        if (gg_arguments-->0 == DAMUSIX_GG_ROCK+DAMUSIX_NCANALMAX+i) {
          DmxSTM__gg_vcnl-->i = id;
        }
      }
      !---------------------------------------------------------------------
      ! si es canal para 'lista de reprod.' de Damusix, asigna su referencia
      !---------------------------------------------------------------------
      ! rock_inicial+canales_normales+canales_virtuales = rock para canal 'lista de reprod.'
      if (gg_arguments-->0 == DAMUSIX_GG_ROCK+DAMUSIX_NCANALMAX+DAMUSIX_VCANALMAX) {
        DmxSTM__gg_lcnl = id;
      }
      ! volver a iterar para encontrar mas objetos de sonido
      id = glk_schannel_iterate(id, gg_arguments);
    }
    !-----------------------------------------------------------------------
    ! == FINALMENTE ==
    ! IMPORTANTE: SI NO SE USAN LAS SIGUIENTES RUTINAS, LOS SONIDOS DE
    ! LOS CANALES USADOS POR DAMUSIX SEGUIRAN REPRODUCIENDOSE SIN CONTROL
    !-----------------------------------------------------------------------
    ! actualiza el estado de todos canales normales de sonido (reprod., detener, etc.)
    DmxAPI__Kernel_UpdateAllChannels(1); ! IMPORTANTE: 1==arg.osc. [ver NOTA en Kernel_UpdatePIB()]
    ! detiene reproduccion en todos los canales virtuales y en el canal de la 'lista'
    DmxAPI__StopExtraChannels();
    ! comprobamos si en el "nuevo-estado-del-juego" existe un efecto de Fade activo
    DmxAPI__Helper_RestoreFade(); ! en tal caso, timer sera reiniciado, recuperando el Fade
    ! y retornamos porque ya no hay nada mas que hacer aqui...
    return;
  }
];

! IMPLEMENTA LO NECESARIO EN HandleGlkEvent() PARA HACER LOS FADES EN "TIEMPO-REAL"
! ***I7-COMP-(03): MODIFICADA PARA SER COMPATIBLE CON EXTENSION GLULX ENTRY POINTS
[ DmxAPI__Glk_FadeNotifyHandler ;
  if (DmxAPI__IsFadeInProgress()) { DmxAPI__Helper_DoFade(); } ! si hay Fade activo, hacemos el efecto
];

!=============================================================================
!-----------------------------------------------------------------------------
! ** RUTINAS 'NO TECNICAS' RELACIONADAS CON LA REPROD. DE AUDIO DE DAMUSIX **
!-----------------------------------------------------------------------------
!=============================================================================

! Asigna sonido, porcentaje de volumen y modo de repeticion a un canal especifico
[ DmxAPI__AssignChannel snd nc vol rep; ! snd: sonido; nc: canal; vol: volumen [-1==Global]; rep: repet.
  ! si el sonido no existe o tiene valor incorrecto, no puede ser asigando
  if (snd < 1) { return DAMUSIX_ERROR_SND; } ! devuelve con error
  ! si el canal es menor a 0, o es mayor que la cantidad inicializada, no hace nada mas
  if ((nc < 0) || (nc > DAMUSIX_NCANALMAX-1)) { return DAMUSIX_ERROR_CNL; } ! devuelve con error
  ! si el volumen es menor a 0% o mayor a 100%, lo deja en el valor del volumen global
  if ((vol < 0) || (vol > 100)) { vol = DmxSTM__vol_global; }
  ! si la cantidad de repeticiones es 0 o es menor a -1, la deja en 1 rep.
  if ((rep == 0) || (rep < -1)) { rep = 1; }
  !-------------------------------------------------------------------------
  ! IMPORTANTE: si esta en proceso un trabajo de Fade a un sonido cuyo
  ! canal es el mismo con el que vamos a trabajar en este momento
    if (DmxSTM__cnl_fade == nc) { DmxAPI__AbortFade(); } ! abortamos el Fade
  !-------------------------------------------------------------------------
  ! asigna el sonido al canal indicado (si nc==0, se asume canal 0)
  DmxSTM__snd_cnl-->nc = snd;
  ! asigna el porcentaje de volumen del canal
  DmxSTM__vol_cnl-->nc = vol;
  ! asigna el modo de repeticion del canal
  DmxSTM__rep_cnl-->nc = rep;
  ! pone el estado de reproduccion del canal en cero (detenido)
  DmxSTM__est_cnl-->nc = 0;
  ! finalmente actualiza el canal
  DmxAPI__Kernel_UpdateChannel(nc);
];

! Libera la asignacion de un sonido a un canal especifico
[ DmxAPI__FreeChannel snd ! snd: el sonido
  nc; ! variable auxiliar (numero de canal)
  ! buscar el canal
  nc = DmxAPI__FindChannel(snd);
  ! si el sonido no tiene canal asignado, no hace nada mas
  if (nc == DAMUSIX_ERROR_SND) { return DAMUSIX_ERROR_SND; } ! devuelve con error
  !-------------------------------------------------------------------------
  ! IMPORTANTE: si esta en proceso un trabajo de Fade a un sonido cuyo
  ! canal es el mismo con el que vamos a trabajar en este momento
    if (DmxSTM__cnl_fade == nc) { DmxAPI__AbortFade(); } ! abortamos el Fade
  !-------------------------------------------------------------------------
  ! libera el sonido asignado al canal indicado (con valor cero)
  DmxSTM__snd_cnl-->nc = 0;
  ! limpia el porcentaje de volumen del canal
  DmxSTM__vol_cnl-->nc = 0;
  ! limpia el modo de repeticion del canal
  DmxSTM__rep_cnl-->nc = 0;
  ! pone el estado de reproduccion del canal en cero (detenido)
  DmxSTM__est_cnl-->nc = 0;
  ! finalmente actualiza el canal
  DmxAPI__Kernel_UpdateChannel(nc);
];

! Activa la salida de audio de Damusix
[ DmxAPI__EnableAudio ;
  ! activa el modo bullicioso
  DmxSTM__audio_activado = true;
  ! actualiza el estado de todos canales normales de sonido
  DmxAPI__Kernel_UpdateAllChannels();
];

! Desactiva la salida de audio de Damusix
[ DmxAPI__DisableAudio ;
  ! activa el modo silencioso
  DmxSTM__audio_activado = false;
  ! actualiza el estado de todos canales normales de sonido
  DmxAPI__Kernel_UpdateAllChannels();
  ! detiene reproduccion en todos los canales virtuales y en canal de la 'lista'
  DmxAPI__StopExtraChannels();
];

! Reproduce el sonido previamente asignado a un canal
[ DmxAPI__PlaySound snd esn ! snd: el sonido a tocar; esn (1=='generar eventos SoundNotify')
  nc; ! variable auxiliar (numero de canal)
  nc = DmxAPI__FindChannel(snd);
  ! si el sonido no tiene canal asignado, no hace nada mas
  if (nc == DAMUSIX_ERROR_SND) { return DAMUSIX_ERROR_SND; } ! devuelve con error
  !-------------------------------------------------------------------------
  ! IMPORTANTE: si esta en proceso un trabajo de Fade a un sonido cuyo
  ! canal es el mismo con el que vamos a trabajar en este momento
    if (DmxSTM__cnl_fade == nc) { DmxAPI__AbortFade(); } ! abortamos el Fade
  !-------------------------------------------------------------------------
  ! pone el estado de reproduccion en uno (reproduciendo)
  DmxSTM__est_cnl-->nc = 1;
  ! finalmente actualiza el canal
  DmxAPI__Kernel_UpdateChannel(nc, esn); ! llamado con arg. oscuro 'esn' (si es 1, notificar)
];

! Detiene el sonido previamente asignado a un canal
[ DmxAPI__StopSound snd ! snd: el sonido a parar
  nc; ! variable auxiliar (numero de canal)
  ! buscar el canal de ese sonido
  nc = DmxAPI__FindChannel(snd);
  ! si el sonido no tiene canal asignado, no hace nada mas
  if (nc == DAMUSIX_ERROR_SND) { return DAMUSIX_ERROR_SND; } ! devuelve con error
  !-------------------------------------------------------------------------
  ! IMPORTANTE: si esta en proceso un trabajo de Fade a un sonido cuyo
  ! canal es el mismo con el que vamos a trabajar en este momento
    if (DmxSTM__cnl_fade == nc) { DmxAPI__AbortFade(); } ! abortamos el Fade
  !-------------------------------------------------------------------------
  ! pone el estado de reproduccion en cero (detenido)
  DmxSTM__est_cnl-->nc = 0;
  ! finalmente actualiza el canal
  DmxAPI__Kernel_UpdateChannel(nc);
];

! Reproduce un sonido en alguno de los canales virtuales
[ DmxAPI__VirtualPlaySound snd vol; ! snd: sonido; vol: porcent. de volumen (por omision Vol.Comun, -1==Global)
  ! si el sonido no existe o tiene valor incorrecto, no puede ser reprod. 'virtualmente'
  if (snd < 1) { return DAMUSIX_ERROR_SND; } ! devuelve con error
  ! si el audio no esta soportado, no se hace nada mas
  if (DmxSTM__glk_sin_audio) { return; }
  ! si la salida de audio esta desactivada, no se hace nada mas
  if (~~DmxSTM__audio_activado) { return; }
  ! si el volumen es menor a 1% o mayor a 100%, hay que corregir su valor...
  if ((vol < 1) || (vol > 100)) {
    if (vol == -1) { vol = DmxSTM__vol_global; } ! si vale -1 usamos Vol.Global, si no...
    else { vol = DmxSTM__vol_vcnl; } ! usamos Vol.Comun actual para canales 'virtuales'
  }
  ! el interprete puede cambiar el volumen? Si es asi: cambialo ahora
  if (glk_gestalt(gestalt_SoundVolume,0)) {
    glk_schannel_set_volume(DmxSTM__gg_vcnl-->DmxSTM__que_vcnl, vol * DAMUSIX_VOLMAX);
  }
  ! y ahora tocamos el sonido efectivamente (en alguno de los canales virtuales)
  ! [NOTA: sonido solo tocara 1 vez y no generara ningun evento de notificacion]
  glk_schannel_play_ext(DmxSTM__gg_vcnl-->(DmxSTM__que_vcnl), snd, 1, 0);
  !-------------------------------------------------------------------------
  ! IMPORTANTE: incrementamos el numero de la variable que indica cual
  ! de todos los canales virtuales se usara para la siguiente reproduccion
  DmxSTM__que_vcnl++;
  !-------------------------------------------------------------------------
  ! IMPORTANTE: si llegamos al ultimo canal virtual de la lista, regresamos  y...
  if (DmxSTM__que_vcnl > DAMUSIX_VCANALMAX-1) { DmxSTM__que_vcnl = 0; } ! usamos el 1ro
];

! Agrega un sonido y su tiempo de duracion a 'lista de reproduccion de sonidos'
[ DmxAPI__AddToPlaylist snd ms ! snd: el sonido; ms: milisegundos que dura el sonido (para espera)
  i; ! para iteraciones
  ! si el sonido no existe o tiene valor incorrecto, no puede ser agregado a la lista
  if (snd < 1) { return DAMUSIX_ERROR_SND; } ! devuelve con error
  ! si la cantidad de milisegundos es menor a 1, la deja en 1000ms (1 segundo)
  if (ms < 1) { ms = 1000; }
  ! ahora 'construimos' la lista de reproduccion de sonidos
  for (i=0 : i<(DAMUSIX_SNDLSTMAX*2) : i=i+2) { ! recorremos cada una de las filas de la lista
    if (DmxSTM__snd_lst-->i == 0) {  ! siempre que exista una fila disponible ('1er slot'==0)
      DmxSTM__snd_lst-->i = snd;     ! se agrega el sonido concreto... (en 1er slot)
      DmxSTM__snd_lst-->(i+1) = ms;  ! ... su tiempo de duracion... (en 2do slot)
      return;                      ! y terminamos aqui
    }
  }
  !-------------------------------------------------------------------------
  #ifdef DEBUG;
    ! si la lista de reproduccion de sonidos ya no tiene slots libres
    ! (se ha llenado) se debe lanzar un aviso de error en el modo DEBUG
    glk_set_style(style_Preformatted);
    new_line;
    print (string) DMX_ERRMSG__PLAYLIST_IS_FULL; ! mensaje de aviso
    new_line;
    glk_set_style(style_Normal);
  #endif; ! DEBUG
  !-------------------------------------------------------------------------
];

! Limpia la 'lista de reproduccion de sonidos', eliminando todo su contenido
[ DmxAPI__ClearPlaylist
  i; ! para iteraciones
  ! recorremos la lista completa y ponemos a cero cada uno de sus slots
  for (i=0 : i<(DAMUSIX_SNDLSTMAX*2) : i=i+1) { DmxSTM__snd_lst-->i = 0; }
];

! Reproduce el contenido previamente agregado a la 'lista de reprod. de sonidos'
[ DmxAPI__RunPlaylist vol ! vol: porcentaje de volumen (por omision Vol.Comun, -1==Global)
  i; ! para iteraciones
  ! si el audio no esta soportado, no se hace nada mas
  if (DmxSTM__glk_sin_audio) { jump DmxAPI__TocarListaFin; }
  ! si la salida de audio esta desactivada, no se hace nada mas
  if (~~DmxSTM__audio_activado) { jump DmxAPI__TocarListaFin; }
  ! el interprete puede manejar el Timer? Si no: no hacemos nada mas
  if (glk_gestalt(gestalt_Timer,0) == 0) { jump DmxAPI__TocarListaFin; }
  !-------------------------------------------------------------------------
  ! si ya esta en proceso un trabajo de Fade, no se permite tocar la 'lista'
  if (DmxAPI__IsFadeInProgress()) {
    #ifdef DEBUG;
      glk_set_style(style_Preformatted);
      new_line;
      print (string) DMX_ERRMSG__PLAYLIST_DURING_FADE; ! mensaje de aviso
      new_line;
      glk_set_style(style_Normal);
    #endif; ! DEBUG
    jump DmxAPI__TocarListaFin;
  }
  !-------------------------------------------------------------------------
  ! si el volumen es menor a 1% o mayor a 100%, hay que corregir su valor...
  if ((vol < 1) || (vol > 100)) {
    if (vol == -1) { vol = DmxSTM__vol_global; } ! si vale -1 usamos Vol.Global, si no...
    else { vol = DmxSTM__vol_lcnl; } ! usamos Vol.Comun actual para 'lista de reproduccion'
  }
  ! el interprete puede cambiar el volumen? Si es asi: cambialo ahora
  if (glk_gestalt(gestalt_SoundVolume,0)) {
    glk_schannel_set_volume(DmxSTM__gg_lcnl, vol * DAMUSIX_VOLMAX);
  }
  ! ahora comenzamos a tocar los sonidos de la 'lista de reprod.' en orden, uno a uno
  for (i=0 : i<(DAMUSIX_SNDLSTMAX*2) : i=i+2) { ! recorremos cada una de las filas de la lista
    if (DmxSTM__snd_lst-->i ~= 0) { ! siempre que la fila actual no este vacia ('1er slot'~=0)
      glk_schannel_play_ext(DmxSTM__gg_lcnl, DmxSTM__snd_lst-->i, 1, 0); ! tocamos el sonido
      DmxAPI__Helper_Sleep(DmxSTM__snd_lst-->(i+1));                       ! hacemos la pausa
    }
  }
  !-------------------------------------------------------------------------
  .DmxAPI__TocarListaFin; ! ETIQUETA ESPECIAL PARA SITUACIONES DE ERROR
  !-------------------------------------------------------------------------
  ! finalmente limpiamos toda la lista de reprod. de sonidos (slots a cero)
  DmxAPI__ClearPlaylist();
];

! Establece el modo de repeticion de un sonido (cuantas veces se tocara)
[ DmxAPI__SetSoundRepetition snd rep ! snd: el sonido; rep: el numero de repeticiones
  nc; ! variable auxiliar (numero de canal)
  ! buscar el canal de ese sonido
  nc = DmxAPI__FindChannel(snd);
  ! si el sonido no tiene canal asignado, no hace nada mas
  if (nc == DAMUSIX_ERROR_SND) { return DAMUSIX_ERROR_SND; } ! devuelve con error
  ! si la cantidad de repeticiones es 0 o es menor a -1, la deja en 1 rep.
  if ((rep == 0) || (rep < -1)) { rep = 1; }
  ! establece el modo de repeticion del canal especificado
  DmxSTM__rep_cnl-->nc = rep;
];

! Establece el volumen de un sonido
[ DmxAPI__SetSoundVolume snd vol ! snd: el sonido; vol: porcentaje de volumen [-1==Vol.Global]
  nc; ! variable auxiliar (numero de canal)
  ! buscar el canal de ese sonido
  nc = DmxAPI__FindChannel(snd);
  ! si el sonido no tiene canal asignado, no hace nada mas
  if (nc == DAMUSIX_ERROR_SND) { return DAMUSIX_ERROR_SND; } ! devuelve con error
  ! si el volumen es menor a 0% o mayor a 100%, lo deja en el valor del volumen global
  if ((vol < 0) || (vol > 100)) { vol = DmxSTM__vol_global; }
  ! establece el volumen del canal especificado
  DmxSTM__vol_cnl-->nc = vol;
  ! si el audio no esta soportado, no se hace nada mas
  if (DmxSTM__glk_sin_audio) { return; }
  !-------------------------------------------------------------------------
  ! el interprete puede cambiar el volumen? Si es asi: cambialo ahora
  if (glk_gestalt(gestalt_SoundVolume,0)) {
    ! finalmente actualiza el volumen
    glk_schannel_set_volume(DmxSTM__gg_ncnl-->nc, (DmxSTM__vol_cnl-->nc) * DAMUSIX_VOLMAX);
  }
];

! Establece el volumen comun para todos los canales 'virtuales'
[ DmxAPI__SetVirtualVolume vol ! vol: porcentaje de volumen [-1==Vol.Global]
  i; ! para iteraciones
  ! si el volumen es menor a 0% o mayor a 100%, lo deja en el valor del volumen global
  if ((vol < 0) || (vol > 100)) { vol = DmxSTM__vol_global; }
  ! recuerda el nuevo volumen comun para los canales 'virtuales'
  DmxSTM__vol_vcnl = vol;
  ! si el audio no esta soportado, no se hace nada mas
  if (DmxSTM__glk_sin_audio) { return; }
  !-------------------------------------------------------------------------
  ! el interprete puede cambiar el volumen? Si es asi: cambialo ahora
  if (glk_gestalt(gestalt_SoundVolume,0)) {
    ! finalmente actualiza el volumen
    for (i=0 : i<DAMUSIX_VCANALMAX : i=i+1) {
      glk_schannel_set_volume(DmxSTM__gg_vcnl-->i, DmxSTM__vol_vcnl * DAMUSIX_VOLMAX);
    }
  }
];

! Establece el volumen comun para la 'lista de reproduccion de sonidos'
[ DmxAPI__SetPlaylistVolume vol; ! vol: porcentaje de volumen [-1==Vol.Global]
  ! si el volumen es menor a 0% o mayor a 100%, lo deja en el valor del volumen global
  if ((vol < 0) || (vol > 100)) { vol = DmxSTM__vol_global; }
  ! recuerda el nuevo volumen comun para la 'lista de reproduccion'
  DmxSTM__vol_lcnl = vol;
  ! si el audio no esta soportado, no se hace nada mas
  if (DmxSTM__glk_sin_audio) { return; }
  !-------------------------------------------------------------------------
  ! el interprete puede cambiar el volumen? Si es asi: cambialo ahora
  if (glk_gestalt(gestalt_SoundVolume,0)) {
    ! finalmente actualiza el volumen
    glk_schannel_set_volume(DmxSTM__gg_lcnl, DmxSTM__vol_lcnl * DAMUSIX_VOLMAX);
  }
];

! Establece el volumen global para todos los sonidos gestionados por Damusix
[ DmxAPI__SetGlobalVolume vol ! el porcentaje de volumen global
  i; ! para iteraciones
  ! si el volumen es menor a 0% o mayor a 100%, lo deja justo en 100%
  if ((vol < 0) || (vol > 100)) { vol = 100; }
  ! recuerda el nuevo valor de volumen global
  DmxSTM__vol_global = vol;
  !-------------------------------------------------------------------------
  ! NOTA: aqui no comprobamos si la Glk soporta sonido o si la salida de
  ! audio esta activada, porque ya lo hacen las propias rutinas de abajo
  !-------------------------------------------------------------------------
  ! actualizamos todos los canales de sonido 'normales' con su nuevo volumen
  for (i=0 : i<DAMUSIX_NCANALMAX : i=i+1) { DmxAPI__SetChannelVolume(i, DmxSTM__vol_global); }
  ! actualizamos todos los canales de sonido 'virtuales' con su nuevo volumen
  DmxAPI__SetVirtualVolume(DmxSTM__vol_global);
  ! finalmente actualizamos el canal de la 'lista de reprod.' con su nuevo volumen
  DmxAPI__SetPlaylistVolume(DmxSTM__vol_global);
];

! Hace FadeIn a un sonido en "tiempo-real"
[ DmxAPI__FadeIn snd ms volfinal ! snd: sonido; ms: duracion; volfinal: vol. final
  nc; ! variable auxiliar (numero de canal)
  ! el interprete puede manejar el Timer? Si no: no hacemos nada mas
  if (glk_gestalt(gestalt_Timer,0) == 0) { return; }
  !-------------------------------------------------------------------------
  ! si ya esta en proceso un trabajo de Fade, no se permite lanzar otro
  if (DmxAPI__IsFadeInProgress()) {
    #ifdef DEBUG;
      glk_set_style(style_Preformatted);
      new_line;
      print (string) DMX_ERRMSG__FADE_DURING_FADE; ! mensaje de aviso
      new_line;
      glk_set_style(style_Normal);
    #endif; ! DEBUG
    return;
  }
  !-------------------------------------------------------------------------
  ! buscar el canal de ese sonido
  nc = DmxAPI__FindChannel(snd);
  ! si el sonido no tiene canal asignado, no hace nada mas
  if (nc == DAMUSIX_ERROR_SND) { return DAMUSIX_ERROR_SND; } ! devuelve con error
  !-------------------------------------------------------------------------
  ! si Vol.Final es menor a 1% o mayor a 100%, fijar valor segun Vol.Global
  if ((volfinal < 1) || (volfinal > 100)) { volfinal = DmxSTM__vol_global; }
  !-------------------------------------------------------------------------
  ! *** COMPROB. DE SEGURIDAD: EVITAR DIV. POR CERO EN CODIGO POSTERIOR ***
  ! SI EL VOLUMEN ACTUAL DEL CANAL ES IGUAL O SUPERIOR A VOLUMEN GLOBAL,
  ! ENTONCES ESTA AL MAXIMO Y NO ES NECESARIO REALIZAR EFECTO DE FadeIn
  ! EN 'TIEMPO-REAL' [ADEMAS EVITA UN POTENCIAL BUG (DIVISION POR CERO)]
  if (DmxAPI__GetChannelVolume(nc) >= volfinal) { return; } ! **terminar aqui!!
  !-------------------------------------------------------------------------
  ! ajusta el modo de Fade (FadeIn==1)
  DmxSTM__que_fade = 1;
  ! recuerda el canal asignado al sonido al que se le va a hacer Fade
  DmxSTM__cnl_fade = nc;
  ! hacemos una copia del volumen inicial
  DmxSTM__vol_fade-->0 = DmxAPI__GetChannelVolume(nc);
  ! hacemos una copia del volumen final
  DmxSTM__vol_fade-->1 = volfinal;
  ! si duracion en msegs. es menor a 100, la deja en 100ms (1ms * 1% vol.)
  if (ms < 100) { ms = 100; }
  ! calculamos tiempo de cada 'tick' y lo recordamos (truco UNDO/RESTORE/RESTART)
  DmxSTM__tick_fade = ms / ((DmxSTM__vol_fade-->1) - (DmxSTM__vol_fade-->0));
  ! finalmente activamos el timer para que comience el Fade de "tiempo-real"
  glk_request_timer_events(DmxSTM__tick_fade);
];

! Hace FadeOut a un sonido en "tiempo-real"
[ DmxAPI__FadeOut snd ms volfinal sndpfo sndpesn ! snd: sonido; ms: duracion; volfinal: vol. final
  ! sndpfo: sonido Post-FadeOut; sndpesn: (1=='generar SoundNotify' el sonido Post-FadeOut)
  nc; ! variable auxiliar (numero de canal)
  ! el interprete puede manejar el Timer? Si no: no hacemos nada mas
  if (glk_gestalt(gestalt_Timer,0) == 0) { return; }
  !-------------------------------------------------------------------------
  ! si ya esta en proceso un trabajo de Fade, no se permite lanzar otro
  if (DmxAPI__IsFadeInProgress()) {
    #ifdef DEBUG;
      glk_set_style(style_Preformatted);
      new_line;
      print (string) DMX_ERRMSG__FADE_DURING_FADE; ! mensaje de aviso
      new_line;
      glk_set_style(style_Normal);
    #endif; ! DEBUG
    return;
  }
  !-------------------------------------------------------------------------
  ! buscar el canal de ese sonido
  nc = DmxAPI__FindChannel(snd);
  ! si el sonido no tiene canal asignado, no hace nada mas
  if (nc == DAMUSIX_ERROR_SND) { return DAMUSIX_ERROR_SND; } ! devuelve con error
  !-------------------------------------------------------------------------
  ! si Vol.Final es menor a 1% o mayor a 100%, fijar 0% de volumen (minimo)
  if ((volfinal < 1) || (volfinal > 100)) { volfinal = 0; } ! vol. minimo
  !-------------------------------------------------------------------------
  ! *** COMPROB. DE SEGURIDAD: EVITAR DIV. POR CERO EN CODIGO POSTERIOR ***
  ! SI EL VOLUMEN ACTUAL DEL CANAL ES MENOR O IGUAL 0%, ENTONCES ESTA AL
  ! MINIMO Y NO ES NECESARIO REALIZAR EFECTO DE FadeOut EN 'TIEMPO-REAL'
  ! [ADEMAS EVITA UN POTENCIAL BUG (DIVISION POR CERO)]
  if (DmxAPI__GetChannelVolume(nc) <= volfinal) { return; } ! **terminar aqui!!
  !-------------------------------------------------------------------------
  ! ajusta el modo de Fade (FadeOut==2)
  DmxSTM__que_fade = 2;
  ! recuerda el canal asignado al sonido al que se le va a hacer Fade
  DmxSTM__cnl_fade = nc;
  ! hacemos una copia del volumen inicial
  DmxSTM__vol_fade-->0 = DmxAPI__GetChannelVolume(nc);
  ! hacemos una copia del volumen final
  DmxSTM__vol_fade-->1 = volfinal;
  ! guardamos una copia del volumen inicial como 'volumen original'
  DmxSTM__vol_fade-->2 = DmxSTM__vol_fade-->0;
  ! si duracion en msegs. es menor a 100, la deja en 100ms (1ms * 1% vol.)
  if (ms < 100) { ms = 100; }
  ! si 'volumen final' no es cero, entonces NO DEBE USARSE sonido post-fadeout
  if (DmxSTM__vol_fade-->1 ~= 0) { sndpfo = 0; sndpesn = 0; }
  ! guardamos el sonido post-fadeout (si es cero, es que no hay sonido posterior)
  ! y si ese sonido debe notificar eventos cuando termine de reproducirse
  DmxSTM__snd_pfadeout-->0 = sndpfo;
  DmxSTM__snd_pfadeout-->1 = sndpesn;
  ! calculamos tiempo de cada 'tick' y lo recordamos (truco UNDO/RESTORE/RESTART)
  DmxSTM__tick_fade = ms / ((DmxSTM__vol_fade-->0) - (DmxSTM__vol_fade-->1));
  ! finalmente activamos el timer para que comience el Fade de "tiempo-real"
  glk_request_timer_events(DmxSTM__tick_fade);
];

! Aborta cualquier efecto de Fade en "tiempo-real" que pudiera estar en proceso
!---------------------------------------------------------------------------
! [IMPORTANTE: esta rutina detendra los 'ticks' del Timer SOLAMENTE cuando
! este EN PROCESO un efecto de Fade. Debido a limitaciones de la Glk, se
! sabe que DmxAPI__AbortFade() no detendra los 'ticks' correctamente ante un
! comando RESTART o RESTORE/UNDO (si se carga una posicion en la cual no
! existia ningun efecto de Fade en proceso). Esta simple 'irregularidad'
! en el comportamiento de la rutina puede corregirse con un breve truco,
! pero se ha decido no hacerlo, porque la correccion podria traer 'efectos
! colaterales' en el codigo ajeno a Damusix implementado por el programador
! (la solucion es detener el Timer SIEMPRE, pero... ¿y si el juego lo esta
! usando para una funcion propia? Mejor NO DETENERLO injustificadamente)
! A pesar de todo, DmxAPI__AbortFade() SIEMPRE DETIENE CORRECTAMENTE los Fades
! activos, incluso si el Timer sige produciendo 'ticks' sin control]
[ DmxAPI__AbortFade
  nc; ! variable auxiliar (numero de canal)
  ! el interprete puede manejar el Timer? Si no: no hacemos nada mas
  if (glk_gestalt(gestalt_Timer,0) == 0) { return; }
  !-------------------------------------------------------------------------
  ! hay en proceso algun trabajo de Fade? Si no: no hacemos nada mas
  if (~~DmxAPI__IsFadeInProgress()) { return; }
  !-------------------------------------------------------------------------
  glk_request_timer_events(0); ! detenemos los 'ticks' del Timer...
  DmxSTM__tick_fade = 0;          ! y borramos el calculo de 'ticks' guardado
  !-------------------------------------------------------------------------
  ! recordamos temporalmente el numero del canal en Fade (se usa mas abajo)
  ! [IMPORTANTE: asi evitamos una llamada recursiva perpetua en DmxAPI__StopChannel()]
  nc = DmxSTM__cnl_fade;
  ! reseteamos ahora la variable que guardaba el numero del canal en Fade
  DmxSTM__cnl_fade = -1; ! -1=='sin canal' (no hay canal en Fade)
  !-------------------------------------------------------------------------
  ! si es FadeOut, adicionalmente paramos el canal que estaba en Fade
  ! si su volumen actual ha llegado al % minimo (0%) luego del efecto
  if ((DmxSTM__que_fade == 2) && (DmxSTM__vol_fade-->1 <= 0)) {
    DmxAPI__StopChannel(nc); ! detenemos la reproduccion del canal y...
    ! aprovechamos de hacer un truquito para que se recupere volumen...
    DmxSTM__vol_fade-->1 = DmxSTM__vol_fade-->2; ! original antes del FadeOut
  }
  !-------------------------------------------------------------------------
  ! establecemos ahora el volumen final para el sonido que estaba en Fade
  DmxAPI__SetChannelVolume(nc,DmxSTM__vol_fade-->1); ! usamos copia del Vol.Final
  ! limpiamos la copia del volumen inicial
  DmxSTM__vol_fade-->0 = 0;
  ! limpiamos la copia del volumen final
  DmxSTM__vol_fade-->1 = 0;
  ! borramos la copia del 'volumen original'...
  DmxSTM__vol_fade-->2 = 0; ! ... solo usada en FadeOut
  ! y finalmente ponemos el modo de Fade en cero (sin Fades)
  DmxSTM__que_fade = 0;
];

! Hace FadeIn a un sonido en "tiempo-no-real" (devuelve control al finalizar efecto)
[ DmxAPI__SimpleFadeIn snd ms volfinal ! snd: sonido; ms: duracion; volfinal: vol. final
  nc vol i; ! nc: aux. (num. canal); vol: aux. (vol. inicial) i: para iteraciones
  ! el interprete puede manejar el Timer? Si no: no hacemos nada mas
  if (glk_gestalt(gestalt_Timer,0) == 0) { return; }
  !-------------------------------------------------------------------------
  ! si ya esta en proceso un trabajo de Fade, no se permite lanzar otro
  if (DmxAPI__IsFadeInProgress()) {
    #ifdef DEBUG;
      glk_set_style(style_Preformatted);
      new_line;
      print (string) DMX_ERRMSG__FADE_DURING_FADE; ! mensaje de aviso
      new_line;
      glk_set_style(style_Normal);
    #endif; ! DEBUG
    return;
  }
  !-------------------------------------------------------------------------
  ! buscar el canal de ese sonido
  nc = DmxAPI__FindChannel(snd);
  ! si el sonido no tiene canal asignado, no hace nada mas
  if (nc == DAMUSIX_ERROR_SND) { return DAMUSIX_ERROR_SND; } ! devuelve con error
  !-------------------------------------------------------------------------
  ! si Vol.Final es menor a 1% o mayor a 100%, fijar valor segun Vol.Global
  if ((volfinal < 1) || (volfinal > 100)) { volfinal = DmxSTM__vol_global; }
  !-------------------------------------------------------------------------
  ! si duracion en msegs. es menor a 1, la deja en 100ms (1ms * 1% volumen)
  if (ms < 1) { ms = 100; }
  !-------------------------------------------------------------------------
  ! averiguamos vol. actual del sonido y lo recordamos como 'vol. inicial'
  vol = DmxAPI__GetChannelVolume(nc);
  !-------------------------------------------------------------------------
  ! == NOTA: ELECCION DEL ALGORITMO ==
  ! El volumen en Damusix siempre se mide en porcentajes, con un maximo de
  ! 100%. Por lo tanto, el tiempo de duracion para un Fade debe ser de al
  ! menos 100ms (porque se cambia 1% por cada 1ms). En este primer caso,
  ! se utilizara un 'algoritmo sencillo' que simplemente cambia 1 unidad
  ! de volumen en cada iteracion y luego realiza una espera calculada. Por
  ! el contrario, si el tiempo de duracion para el Fade es menor a 100ms,
  ! entonces debera utilizarse un 'algoritmo complejo' que hace justamente
  ! lo contrario al anterior: cambia X unidades de volumen calculadas segun
  ! un nuevo maximo de volumen, luego espera 1ms y todo el proceso se repite
  ! tantas veces como msegs. de duracion deba tener el efecto de Fade.
  !-------------------------------------------------------------------------
  ! ALGORITMO SENCILLO
  !-------------------------------------------------------------------------
  if (ms >= 100) {
    ! Se va a subir volumen poco a poco desde 'vol.inicial' hasta 'vol.final'
    ! NOTA: 'vol+1' hace que la iteracion comience en % de volumen directamente
    ! superior al % de 'vol.inicial': asi no se itera 2 veces con el mismo valor
    for (i=vol+1 : i<=volfinal : i=i+1) {
      ! cambiamos en 1 unidad el porcentaje de volumen
      DmxAPI__SetChannelVolume(nc, i);
      !---------------------------------------------------------------------
      ! finalmente hacemos una pausa durante un 'intervalo de tiempo' que se
      ! calcula segun la duracion total especificada para el efecto de Fade.
      ! Nunca hay division por cero, porque 'vol' no llega a valer 'volfinal';
      ! es la propia comprobacion inicial del bucle 'for' la que se encarga de
      DmxAPI__Helper_Sleep(ms/(volfinal-vol)); ! evitar un posible error de calculo
    }
  }
  !-------------------------------------------------------------------------
  ! ALGORITMO COMPLEJO
  !-------------------------------------------------------------------------
  else {
    ! si el volumen actual del sonido al que se le va a hacer el efecto
    ! de Fade es mayor o igual que el 'volumen final', terminamos la
    ! rutina porque el efecto es totalmente inaplicable en este caso...
    if (vol >= volfinal) { return; } ! terminamos aqui sin hacer nada mas
    !-----------------------------------------------------------------------
    ! iteramos tantas veces como numero de msegs. de duracion para el Fade
    ! (con pausa de 1ms, asi que efecto siempre durara el tiempo indicado)
    ! NOTA: 'i=1' sirve para evitar una iteracion extra, de otro modo el
    ! efecto de Fade tendria una duracion total erronea con 1ms adicional
    for (i=1 : i<=ms : i=i+1) {
      ! tomamos como 'valor base' para el volumen, la cantidad de msegs. de
      ! duracion total del efecto de Fade y a partir de este valor calculamos
      ! las unidades de volumen que corresponde cambiar en cada iteracion...
      DmxAPI__SetChannelVolume(nc,(i*(volfinal-vol)/ms)+vol); ! no cambiar formula
      !---------------------------------------------------------------------
      ! y finalmente hacemos una pausa durante 1ms que se repetira...
      DmxAPI__Helper_Sleep(1); ! ...tantas veces como msegs. dure el efecto
    }
  }
];

! Hace FadeOut a un sonido en "tiempo-no-real" (devuelve control al finalizar efecto)
[ DmxAPI__SimpleFadeOut snd ms volfinal ! snd: sonido; ms: duracion; volfinal: vol. final
  nc vol i; ! nc: aux. (num. canal); vol: aux. (vol. inicial) i: para iteraciones
  ! el interprete puede manejar el Timer? Si no: no hacemos nada mas
  if (glk_gestalt(gestalt_Timer,0) == 0) { return; }
  !-------------------------------------------------------------------------
  ! si ya esta en proceso un trabajo de Fade, no se permite lanzar otro
  if (DmxAPI__IsFadeInProgress()) {
    #ifdef DEBUG;
      glk_set_style(style_Preformatted);
      new_line;
      print (string) DMX_ERRMSG__FADE_DURING_FADE; ! mensaje de aviso
      new_line;
      glk_set_style(style_Normal);
    #endif; ! DEBUG
    return;
  }
  !-------------------------------------------------------------------------
  ! buscar el canal de ese sonido
  nc = DmxAPI__FindChannel(snd);
  ! si el sonido no tiene canal asignado, no hace nada mas
  if (nc == DAMUSIX_ERROR_SND) { return DAMUSIX_ERROR_SND; } ! devuelve con error
  !-------------------------------------------------------------------------
  ! si Vol.Final es menor a 1% o mayor a 100%, fijar 0% de volumen (minimo)
  if ((volfinal < 1) || (volfinal > 100)) { volfinal = 0; } ! vol. minimo
  !-------------------------------------------------------------------------
  ! si duracion en msegs. es menor a 1, la deja en 100ms (1ms * 1% volumen)
  if (ms < 1) { ms = 100; }
  !-------------------------------------------------------------------------
  ! averiguamos vol. actual del sonido y lo recordamos como 'vol. inicial'
  vol = DmxAPI__GetChannelVolume(nc);
  !-------------------------------------------------------------------------
  ! == NOTA: ELECCION DEL ALGORITMO ==
  ! El volumen en Damusix siempre se mide en porcentajes, con un maximo de
  ! 100%. Por lo tanto, el tiempo de duracion para un Fade debe ser de al
  ! menos 100ms (porque se cambia 1% por cada 1ms). En este primer caso,
  ! se utilizara un 'algoritmo sencillo' que simplemente cambia 1 unidad
  ! de volumen en cada iteracion y luego realiza una espera calculada. Por
  ! el contrario, si el tiempo de duracion para el Fade es menor a 100ms,
  ! entonces debera utilizarse un 'algoritmo complejo' que hace justamente
  ! lo contrario al anterior: cambia X unidades de volumen calculadas segun
  ! un nuevo maximo de volumen, luego espera 1ms y todo el proceso se repite
  ! tantas veces como msegs. de duracion deba tener el efecto de Fade.
  !-------------------------------------------------------------------------
  ! ALGORITMO SENCILLO
  !-------------------------------------------------------------------------
  if (ms >= 100) {
    ! Se va a bajar volumen poco a poco desde 'vol.inicial' hasta 'vol.final'
    ! NOTA: 'vol-1' hace que la iteracion comience en % de volumen directamente
    ! inferior al % de 'vol.inicial': asi no se itera 2 veces con el mismo valor
    for (i=vol-1 : i>=volfinal : i=i-1) {
      ! cambiamos en 1 unidad el porcentaje de volumen
      DmxAPI__SetChannelVolume(nc, i);
      !---------------------------------------------------------------------
      ! finalmente hacemos una pausa durante un 'intervalo de tiempo' que se
      ! calcula segun la duracion total especificada para el efecto de Fade.
      ! Nunca hay division por cero, porque 'vol' no llega a valer 'volfinal';
      ! es la propia comprobacion inicial del bucle 'for' la que se encarga de
      DmxAPI__Helper_Sleep(ms/(vol-volfinal)); ! evitar un posible error de calculo
    }
  }
  !-------------------------------------------------------------------------
  ! ALGORITMO COMPLEJO
  !-------------------------------------------------------------------------
  else {
    ! si el volumen actual del sonido al que se le va a hacer el efecto
    ! de Fade es menor o igual que el 'volumen final', terminamos la
    ! rutina porque el efecto es totalmente inaplicable en este caso...
    if (vol <= volfinal) { return; } ! terminamos aqui sin hacer nada mas
    !-----------------------------------------------------------------------
    ! iteramos tantas veces como numero de msegs. de duracion para el Fade
    ! (con pausa de 1ms, asi que efecto siempre durara el tiempo indicado)
    ! NOTA: 'i=1' sirve para evitar una iteracion extra, de otro modo el
    ! efecto de Fade tendria una duracion total erronea con 1ms adicional
    for (i=1 : i<=ms : i=i+1) {
      ! tomamos como 'valor base' para el volumen, la cantidad de msegs. de
      ! duracion total del efecto de Fade y a partir de este valor calculamos
      ! las unidades de volumen que corresponde cambiar en cada iteracion...
      DmxAPI__SetChannelVolume(nc,(i*(volfinal-vol)/ms)+vol); ! no cambiar formula
      !---------------------------------------------------------------------
      ! y finalmente hacemos una pausa durante 1ms que se repetira...
      DmxAPI__Helper_Sleep(1); ! ...tantas veces como msegs. dure el efecto
    }
  }
  !-------------------------------------------------------------------------
  ! NOTA: aqui no detenemos el sonido ni reestablecemos su volumen con Vol.
  ! Global actual: esta rutina no es de "tiempo-real" asi que estos ajustes
  ! finales se dejan en manos del programador en el propio codigo del juego
  !-------------------------------------------------------------------------
];

!=============================================================================
!-----------------------------------------------------------------------------
! ** RUTINAS 'TECNICAS' RELACIONADAS CON LA REPRODUCC. DE AUDIO DE DAMUSIX **
!-----------------------------------------------------------------------------
!=============================================================================

! [TECNICO] REPRODUCE CUALQUIER SONIDO ASIGNADO AL CANAL ESPECIFICADO
! (no considera los sonidos, solo importan los canales)
[ DmxAPI__PlayChannel nc esn; ! nc: numero de canal; esn (1=='generar eventos SoundNotify')
  ! si el canal es menor a 0, o es mayor que la cantidad inicializada, no hace nada mas
  if ((nc < 0) || (nc > DAMUSIX_NCANALMAX-1)) { return DAMUSIX_ERROR_CNL; } ! devuelve con error
  !-------------------------------------------------------------------------
  ! IMPORTANTE: si esta en proceso un trabajo de Fade a un sonido cuyo
  ! canal es el mismo con el que vamos a trabajar en este momento
    if (DmxSTM__cnl_fade == nc) { DmxAPI__AbortFade(); } ! abortamos el Fade
  !-------------------------------------------------------------------------
  ! pone el estado de reproduccion en uno (reproduciendo)
  DmxSTM__est_cnl-->nc = 1;
  ! finalmente actualiza el canal
  DmxAPI__Kernel_UpdateChannel(nc, esn); ! llamado con arg. oscuro 'esn' (si es 1, notificar)
];

! [TECNICO] DETIENE CUALQUIER SONIDO ASIGNADO AL CANAL ESPECIFICADO
! (no considera el sonido, solo importa el canal)
[ DmxAPI__StopChannel nc; ! numero de canal
  ! si el canal es menor a 0, o es mayor que la cantidad inicializada, no hace nada mas
  if ((nc < 0) || (nc > DAMUSIX_NCANALMAX-1)) { return DAMUSIX_ERROR_CNL; } ! devuelve con error
  !-------------------------------------------------------------------------
  ! IMPORTANTE: si esta en proceso un trabajo de Fade a un sonido cuyo
  ! canal es el mismo con el que vamos a trabajar en este momento
    if (DmxSTM__cnl_fade == nc) { DmxAPI__AbortFade(); } ! abortamos el Fade
  !-------------------------------------------------------------------------
  ! pone el estado de reproduccion en cero (detenido)
  DmxSTM__est_cnl-->nc = 0;
  ! finalmente actualiza el canal
  DmxAPI__Kernel_UpdateChannel(nc);
];

! [TECNICO] DETIENE LA REPRODUCCION EN TODOS CANALES VIRTUALES Y TAMBIEN EN EL
! EL CANAL DE LA 'LISTA DE REPRODUCCION DE SONIDOS' [usado por varias rutinas]
[ DmxAPI__StopExtraChannels
  i; ! para iteraciones
  ! si el audio no esta soportado, no se hace nada mas
  if (DmxSTM__glk_sin_audio) { return; }
  ! recorre todos los canales virtuales y los detiene correctamente
  for (i=0 : i<DAMUSIX_VCANALMAX : i=i+1) { glk_schannel_stop(DmxSTM__gg_vcnl-->i); }
  ! tambien detenemos el canal de 'lista de reproduccion de sonidos' (por si acaso)
  glk_schannel_stop(DmxSTM__gg_lcnl);
];

! [TECNICO] DETIENE TODOS LOS CANALES INICIALIZADOS
! (no considera los sonidos, solo importan los canales)
[ DmxAPI__StopAll
  i; ! para iteraciones
  ! abortar cualquier efecto de Fade que este en proceso actualmente
  DmxAPI__AbortFade();
  ! recorre todos los canales normales y los detiene correctamente
  for (i=0 : i<DAMUSIX_NCANALMAX : i=i+1) { DmxAPI__StopChannel(i); }
  ! detiene reprod. en todos los canales virtuales y en canal de la 'lista'
  DmxAPI__StopExtraChannels();
];

! [TECNICO] ESTABLECE EL MODO DE REPETICION DE UN CANAL (CUANTAS VECES SE TOCARA)
! (no considera los sonidos, solo importan los canales)
[ DmxAPI__SetChannelRepetition nc rep; ! nc: numero de canal; rep: el numero de repeticiones
  ! si el canal es menor a 0, o es mayor que la cantidad inicializada, no hace nada mas
  if ((nc < 0) || (nc > DAMUSIX_NCANALMAX-1)) { return DAMUSIX_ERROR_CNL; } ! devuelve con error
  ! si la cantidad de repeticiones es 0 o es menor a -1, la deja en 1 rep.
  if ((rep == 0) || (rep < -1)) { rep = 1; }
  ! establece el modo de repeticion del canal especificado
  DmxSTM__rep_cnl-->nc = rep;
];

! [TECNICO] ESTABLECE EL VOLUMEN DE UN CANAL
! (no considera los sonidos, solo importan los canales)
[ DmxAPI__SetChannelVolume nc vol; ! nc: numero de canal; vol: porcentaje de volumen [-1==Vol.Global]
  ! si el canal es menor a 0, o es mayor que la cantidad inicializada, no hace nada mas
  if ((nc < 0) || (nc > DAMUSIX_NCANALMAX-1)) { return DAMUSIX_ERROR_CNL; } ! devuelve con error
  ! si el volumen es menor a 0% o mayor a 100%, lo deja en el valor del volumen global
  if ((vol < 0) || (vol > 100)) { vol = DmxSTM__vol_global; }
  ! establece el volumen del canal especificado
  DmxSTM__vol_cnl-->nc = vol;
  ! si el audio no esta soportado, no se hace nada mas
  if (DmxSTM__glk_sin_audio) { return; }
  !-------------------------------------------------------------------------
  ! el interprete puede cambiar el volumen? Si es asi: cambialo ahora
  if (glk_gestalt(gestalt_SoundVolume,0)) {
    ! finalmente actualiza el volumen
    glk_schannel_set_volume(DmxSTM__gg_ncnl-->nc, (DmxSTM__vol_cnl-->nc) * DAMUSIX_VOLMAX);
  }
];

!=============================================================================
!-----------------------------------------------------------------------------
! ** RUTINAS DE CONSULTA SOBRE EL ESTADO DEL KERNEL QUE DEVUELVEN UN VALOR **
!-----------------------------------------------------------------------------
!=============================================================================

! [TECNICO] AVERIGUA EL CANAL QUE SE LA HA ASIGNADO A UN SONIDO ESPECIFICO
[ DmxAPI__FindChannel snd ! snd: el sonido
  i; ! para iteraciones
  for (i=0 : i<DAMUSIX_NCANALMAX : i=i+1) {
    ! si el sonido es distinto de cero (es decir, si existe)
    if (snd ~= 0) {
      ! si lo encuentra devuelve el numero de canal
      if (DmxSTM__snd_cnl-->i == snd) { return i; }
    }
  }
  ! si no, es porque el sonido no ha sido asignado a ningun
  ! canal; se devuelve valor especial 'DAMUSIX_ERROR_SND'
  return DAMUSIX_ERROR_SND;
];

! [TECNICO] AVERIGUA EL SONIDO QUE SE LA HA ASIGNADO A UN CANAL ESPECIFICO
[ DmxAPI__FindSound nc; ! nc: numero de canal
  ! si el canal es menor a 0, o es mayor que la cantidad inicializada, no hace nada mas
  if ((nc < 0) || (nc > DAMUSIX_NCANALMAX-1)) { return DAMUSIX_ERROR_CNL; } ! devuelve con error
  ! devuelve el valor establecido en las variables del kernel de Damusix
  return DmxSTM__snd_cnl-->nc; ! devuelve el sonido asignado a canal especificado
];

! [UTILITARIA] Comprueba si el interprete tiene SOPORTE COMPLETO de audio
! (implica la reproduccion de sonidos sampleados y de modulos musicales)
[ DmxAPI__IsAudioSupported ;
  ! si el interprete PUEDE REPRODUCIR sonidos sampleados y modulos musicales
  if (glk_gestalt(gestalt_Sound,0) && glk_gestalt(gestalt_SoundMusic,0)) {
    return 1;
  }
  ! si alguna de las comprobaciones fallo, no hay soporte completo de audio
  else { return 0; }
];

! Comprueba el estado actual de la salida de audio de Damusix
! [segun se haya llamado o no a DmxAPI__EnableAudio()/DmxAPI__DisableAudio()]
[ DmxAPI__IsAudioEnabled ;
  ! devuelve 1 si la salida de audio esta activada
  if (DmxSTM__audio_activado) { return 1; }
  ! devuelve 0 si la salida de audio esta desactivada (modo silencioso)
  else { return 0; }
];

! Averigua la cantidad de sonidos agregados actualmente a 'lista de reproduccion'
[ DmxAPI__CountPlaylistItems
  cont i; ! cont: var.aux. (contador de sonidos); i: para iteraciones
  cont = 0; ! limpiamos el valor inicial del contador, 'por si acaso'
  ! comenzamos a contar la cantidad de sonidos agregados a 'lista de reproduccion'
  for (i=0 : i<(DAMUSIX_SNDLSTMAX*2) : i=i+2) { ! recorremos cada una de las filas de la lista
    ! siempre que la fila actual no este vacia ('1er slot'~=0), incrementamos el contador
    if (DmxSTM__snd_lst-->i ~= 0) { cont++; }
  }
  return cont; ! devolvemos el total de sonidos contados en la lista
];

! Averigua el modo de repeticion de un sonido (cuantas veces se tocara)
[ DmxAPI__GetSoundRepetition snd ! snd: el sonido
  nc; ! variable auxiliar (numero de canal)
  ! buscar el canal de ese sonido
  nc = DmxAPI__FindChannel(snd);
  ! si el sonido no tiene canal asignado, no hace nada mas
  if (nc == DAMUSIX_ERROR_SND) { return DAMUSIX_ERROR_SND; } ! devuelve con error
  ! devuelve el valor establecido en las variables del kernel de Damusix
  return DmxSTM__rep_cnl-->nc; ! el modo de rep. asignado al canal del sonido
];

! Averigua el volumen de un sonido
[ DmxAPI__GetSoundVolume snd ! snd: el sonido
  nc; ! variable auxiliar (numero de canal)
  ! buscar el canal de ese sonido
  nc = DmxAPI__FindChannel(snd);
  ! si el sonido no tiene canal asignado, no hace nada mas
  if (nc == DAMUSIX_ERROR_SND) { return DAMUSIX_ERROR_SND; } ! devuelve con error
  ! devuelve el valor establecido en las variables del kernel de Damusix
  return DmxSTM__vol_cnl-->nc; ! el vol. asignado al canal del sonido
];

! Averigua el volumen comun actual para todos los canales 'virtuales'
[ DmxAPI__GetVirtualVolume ;
  ! devuelve el valor establecido en las variables del kernel de Damusix
  return DmxSTM__vol_vcnl;
];

! Averigua el volumen comun actual para la 'lista de reproduccion de sonidos'
[ DmxAPI__GetPlaylistVolume ;
  ! devuelve el valor establecido en las variables del kernel de Damusix
  return DmxSTM__vol_lcnl;
];

! Averigua el volumen global actual de todos los sonidos gestionados por Damusix
[ DmxAPI__GetGlobalVolume ;
  ! devuelve el valor establecido en las variables del kernel de Damusix
  return DmxSTM__vol_global;
];

! Comprueba si actualmente esta sonando de fondo el sonido-musica especificado
! (es decir, reproduciendolo con 'repeticiones infinitas' [est_cnl==1])
[ DmxAPI__IsSoundPIB snd ! el sonido a comprobar
  nc; ! variable auxiliar (numero de canal)
  ! buscar el canal de ese sonido
  nc = DmxAPI__FindChannel(snd);
  ! IMPORTANTE: si el sonido no tiene canal asignado, significa que NO ESTA SONANDO
  if (nc == DAMUSIX_ERROR_SND) { return 0; } ! ... y devuelve 0: no sonando de fondo
  ! devuelve el estado del sonido en ese canal (0==det. o 'rep. finita'; 1==reprod.)
  return DmxSTM__est_cnl-->nc;
];

! Comprueba si actualmente esta en proceso un efecto de Fade en "tiempo-real"
[ DmxAPI__IsFadeInProgress ;
  ! devuelve 1 si se esta haciendo un Fade actualmente
  if (DmxSTM__que_fade == 1 or 2) { return 1; }
  ! devuelve 0 si no hay ningun Fade en proceso
  else { return 0;}
];

! [TECNICO] AVERIGUA EL MODO DE REPETICION DE UN CANAL (CUANTAS VECES SE TOCARA)
[ DmxAPI__GetChannelRepetition nc; ! nc: numero de canal
  ! si el canal es menor a 0, o es mayor que la cantidad inicializada, no hace nada mas
  if ((nc < 0) || (nc > DAMUSIX_NCANALMAX-1)) { return DAMUSIX_ERROR_CNL; } ! devuelve con error
  ! devuelve el valor establecido en las variables del kernel de Damusix
  return DmxSTM__rep_cnl-->nc; ! devuelve el modo de repeticion del canal especificado
];

! [TECNICO] AVERIGUA EL VOLUMEN DE UN CANAL
[ DmxAPI__GetChannelVolume nc; ! nc: numero de canal
  ! si el canal es menor a 0, o es mayor que la cantidad inicializada, no hace nada mas
  if ((nc < 0) || (nc > DAMUSIX_NCANALMAX-1)) { return DAMUSIX_ERROR_CNL; } ! devuelve con error
  ! devuelve el valor establecido en las variables del kernel de Damusix
  return DmxSTM__vol_cnl-->nc; ! devuelve el volumen del canal especificado
];

! [TECNICO] COMPRUEBA SI ACTUALMENTE EL CANAL ESPECIFICADO ESTA SONANDO DE FONDO
! CUALQUIER SONIDO-MUSICA (es decir, reprod. con 'rep. infinitas' [est_cnl==1])
[ DmxAPI__IsChannelPIB nc; ! numero de canal
  ! si el canal es menor a 0, o es mayor que la cantidad inicializada, no hace nada mas
  if ((nc < 0) || (nc > DAMUSIX_NCANALMAX-1)) { return DAMUSIX_ERROR_CNL; } ! devuelve con error
  ! devuelve estado de reproduccion del canal (0==det. o 'rep. finita'; 1==reprod.)
  return DmxSTM__est_cnl-->nc;
];

-) after "Glulx.i6t".

Damusix Sound Manager ends here.

[==============================================================================]
[==============================================================================]


---- DOCUMENTATION ----



Chapter: Introduction


Section: Introduction

The present documentation is provisional. It has been written to be concise without giving too many esoteric details on the operation of the Damusix extension. It is not definitive and is only a technical manual for the Beta testers of Damusix. If you are reading this, you are one of them. Thank you very much for your help and support in the development of Damusix! =)

-- Eliuk Blau and Aaron Reed (translator)

P.S. I'd like to extend special gratefulness to my friend Aaron A. Reed. He has been in charge of helping with the translation of much related Damusix material to English, including this documentation. In addition, many of the natural language phrases have been translated or corrected by him. For the above, thank you very much, Aaron. =)

NOTE from Aaron: I have simplified and summarized much of Eliuk's provisional documentation with the goal of getting Damusix into the hands of English-speaking testers as soon as possible. If I have made anything unclear or removed important points in the process, I apologize in advance!


Section: About Damusix

Damusix is a powerful Unified Sound Administrator for Glulx, able to manage everything related to the playback of music and sounds in a simple and easy-to-use form.

The Damusix Audio Manager implements 10 normal channels for the playback of sound, with total control over playback, volume, repetition, and so on; 10 "virtual" channels for the playback of simple sounds without needing to assign channels (which allows one sound to be played overlapping with itself); and a "playlist" with slots for up to ten sounds to be played in sequence.

Additionally, the sounds assigned to normal channels can generate Glk notification events when they finish playing, which can be captured by the author via the Glulx Entry Points extension.

Damusix also allows fade-in and fade-out effects with sounds assigned to a normal channel. These can be in real-time (meaning gameplay will continue while the sound fades) or simple fades (where execution of the game will stop until the fade has concluded). Real-time fades can be aborted at any time by the author.

To summarize the features of Damusix:

	- 10 Normal Channels with complete control over audio
	- 10 Virtual Channels for sounds without an assigned channel
	- Playlist (with space for 10 items)
	- Global volume control
	- Individual volume control for each sound
	- Abstract control by Sound or by Channel
	- Fade-in and Fade-out effects in real-time or as simple fades
	- Enable or Disable audio globally (without affecting any individual volumes)
	- Automatic verification of an interpreter's audio support
	- A mechanism to protect sounds after UNDO/RESTORE
	- Much much more... =D

Damusix requires the following to function correctly:

	- The Inform 7 system (version 10.1 or higher)
	- The extension Glulx Entry Points (version 10.0 or higher)


Section: License

If you modify the Damusix extension, I would be grateful if you send me the source code by e-mail.

Copyright (c) 2008, 2009, 2024 Nicolas Merino Quezada (aka Eliuk Blau).

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

	WARNING:
	THIS COPY OF THE DAMUSIX EXTENSION IS ONLY FOR BETATESTERS. YOU CAN NOT REDISTRIBUTE IT AND/OR MODIFY IT WITHOUT THE EXPLICIT PERMISSION OF THE AUTHOR.



Chapter: Using Damusix


Section: Before you Begin (IMPORTANT; PLEASE READ!)

Currently the Inform 7 IDE does not include a sufficiently robust Glulx interpreter to suitably test games that use multimedia. This is true for all three supported platforms: Windows, Linux, and Mac OS X. It is advised that authors test their multimedia games in external interpreters to obtain reliable results. For Windows I recommend Windows Glulxe or Gargoyle; for Linux, Gargoyle; and for Mac OS X, Spatterlight. I have reports that Damusix works without problems in these three interpreters.

We hope that in the future the interpreters integrated into the IDE will be more complete in their multimedia support.


Section: Including the Extension in Your Game

Simply write:

	*: Include Damusix Sound Manager by Eliuk Blau.


Section: Understanding Audio Channels

All sounds that the Glk and Glulx APIs reproduce must be assigned to a channel of audio. A channel is like a loudspeaker: a sound must be playing through some speaker, so before we play any sound we must assign a speaker (or "channel") to it.

Damusix automatically creates and administers up to 21 channels of audio. The first ten are "normal channels" that can use the full range of audio effects supported by Glk. The second ten are "virtual channels" that have specific and limited functionality. The final channel exists for the "playlist" feature.


Section: Determining if an Interpreter Supports Audio

Damusix automatically verifies if the player's interpreter has full audio support or not. "Full audio support" for Damusix means the ability to play sound in the MOD, AIFF, and Ogg Vorbis formats.

If Damusix concludes that the interpreter does not have full audio support, the extension will halt its own further operations. The game will proceed normally, but without playing sounds.

An author can determine whether the player's interpreter supports audio with the following phrases:

	if full audio is supported...
	if full audio is unsupported...

As an example:

	*: if full audio is unsupported:
		say "WARNING: Your interpreter does not completely support audio!".


Section: Working with the Sound Manager

Damusix implements a complete workflow for handling audio in Glulx, sufficiently powerful to handle simple operations like finding out the volume of a sound channel or whether a sound has finished playing, to more advanced functions like fade-outs. In order to achieve this, it implements an Audio Manager (called "the Manager" from here on out). The Manager also takes care of audio system stability, and deals with all the ugly work such as updating the status of sounds after an UNDO or RESTORE.

For the Damusix Manager to deal fully with a sound, it must be assigned to one of the 10 normal channels. We call them "normal" only to differentiate between the "virtual" channels. We can work directly only with normal channels, so from now on we will refer to them simply as "channels."

When we assign a sound to a channel, the Manager also create an associated group of data that describes aspects of its behavior: initial volume, how many times it should repeat, whether it is currently playing or not, and so on.

It's not necessary for a sound to be assigned to a channel at all times; we just have to make sure it's assigned to a channel before we need to work with it. The channels can be assigned at any time, so if you have only a few you might choose to assign them all in a "When play begins" rule. For a more complicated game, you could assign them on the fly as you go along.

To assign a sound to a channel, say:

	*: assign the sound of Beep to channel 1 with 100% volume and 2 repetitions

To explain the parts of this phrase in more detail:

* the sound of Beep: This is the sound we're assigning a channel to, and can be any "sound-name" created previously in the game.

* to channel 1: This is the number of the channel to use. The ten channels are numbered from 0 to 9.

* with 100% volume: This shows the initial volume of the sound, from 0% to 100%. Each sound can have its own volume, but the Manager also has a global volume which starts at 100%. Changing the global volume will change the volume of all normal channels to that value. This is useful if we need to modify the volume of all sounds at once.

To create a sound at the same volume as the present global volume:

	assign the sound of Beep to channel 1 with global volume and 2 repetitions

* 2 repetitions: How many times to repeat the sound upon playing. This number must be greater than 0, and is 1 by default.

It is also possible to create a sound that loops continuously, perhaps for something like background music. To do so, use the "endless loop" phrase option instead of specifying a repetition count:

	*: assign the sound of Beep to channel 1 with 100% volume, endless loop

In any "assign" phrase, the volume can be omitted (in which case Damusix uses the current global volume) as well as the repetition count (in which case the sound will be played exactly once).

Damusix allows for a few short variations on this phrase:

- To quickly assign a sound to a channel with default volume and repetition:

	assign the sound of Beep to channel 1

- To assign a sound with a specified volume and no repetitions:

	assign the sound of Beep to channel 1 with 100% volume
	assign the sound of Beep to channel 1 with global volume

- To assign a sound with default volume but specified repetitions:

	assign the sound of Beep to channel 1 with 2 repetitions
	assign the sound of Beep to channel 1, endless loop

- The word "volume" can also be omitted:

	assign the sound of Beep to channel 1 with 100%

- As noted above, omitting mention of volume entirely creates a sound at the current global volume, so the following two phrases are equivalent:

	assign the sound of Beep to channel 1 with global volume
	assign the sound of Beep to channel 1

	A NOTE ABOUT VOLUME: Damusix creates a new "kind" to keep track of the volume percentage, called "sound-volume". If we need to use a variable to keep track of sound volumes, it must be of this kind.

	An example:
		TV Volume is a sound-volume that varies.

A final but important point about sound: EACH SOUND CAN ONLY BE ASSIGNED TO ONE NORMAL CHANNEL AT A TIME. If we need the same sound to overlap with itself, we must use "virtual channels" as detailed below.

We'll next take a look at how you would use "assign" and further Damusix functionality to play sounds in a sample game.


Section: Playing Sounds

In a multimedia Glulx game, it's common to have both music and sound effects. For example, suppose we have a music file called "Sound of Music" and a sound effect called "sound of Beep". Since we have only two sounds, we can assign them to channels in the "When play begins" rule to save future effort. Furthermore, we can start the music playing as the game begins.

	(For instructions on defining Sound objects, refer to section 23.7 of the Inform 7 manual.)

Here is a basic game set up as described above:

	*: "First Steps with Damusix"

	Include Damusix Sound Manager by Eliuk Blau.

	Sound of Music is the file "music.ogg".
	Sound of Beep is the file "beep.ogg".

	When play begins:
		assign the Sound of Music to channel 0 with global volume, endless loop;
		assign the sound of Beep to channel 1 with 100% volume;
		dplay the sound of Music;
		dplay the sound of Beep.

	Musical Zone is a room. "Damusix version: [damusix-version]."

Note that since we have omitted any repetition info in the second "assign" phrase, the sound of Beep will play just once.

Since the global volume is by default 100%, both sounds would seem to be using the same volume. What, then, is the difference? Only that if we had previously changed global volume to 50%, then the sound of Music would now be initialized at a volume of 50%.

The phrase "dplay the sound of Music" is what actually starts playing the music. (Note that the phrase is "dplay", for "Damusic play.") We don't have to mention anything about volume or repetitions here since we have already established those settings in the "assign" phrase.

Whenever a sound finishes playing, the Manager generates a "notification event." This is a special ability of the Glk/Glulx API, and we take advantage of it with functionality from the Glulx Entry Points extension (which the Damusix code already includes). If we were interested in learning when our music track ended, we could use this phrase instead:

	dplay the sound of Music, notifying when finished

This indicates a notification event should be generated when this sound naturally finishes playing (but not if it is stopped by hand). Refer to the Glulx Entry Points documentation for information on how to catch and process notification events.

Here are the other useful phrases for dealing with playing audio:

- To stop playing a sound...

	dstop the sound of Beep

- To change the repetition count of a sound...

	change the repetition count of the sound of Beep to 3
	change the repetition count of the sound of Beep to endless loop

- To change the volume of a sound...

	change the volume of the sound of Beep to 50%
	change the volume of the sound of Beep to global volume

And the Manager also allows us to free up a channel for use by another sound:

	free the channel of the sound of Beep

After this last phrase has been reached, we can no longer refer to this sound with Damusix, and its associated data (volume, repetitions, etcetera) is discarded. Usually this doesn't need to be done by hand, but it can be useful in certain cases. For example, imagine the sound of Beep was meant to be played on every turn up to a certain point of the game. Rather than complicate your code with checks to see if the sound should play or not, you can simply unassign this channel at the proper point. From that moment on, attempts to play the sound will silently fail, since Damusix produces no error message when trying to play an unassigned sound. Damusix always ignores any attempts to work with sounds that aren't assigned to a channel. (The only two exceptions to this are the virtual channels and the playlist functionality, which we turn to next.)


Section: "Virtual Channels" of Sound

Sometimes we want to play a short sound just a single time and don't want to be bothered with assigning channels. For these cases Damusix provides 10 "virtual channels" of audio. The programmer cannot and doesn't need to work with these channels directly; they exist internally to play these "one-off" sounds. Sounds played on virtual channels do not interrupt other sounds, and we can play the same sound overlapping with itself.

To play a sound on a virtual channel, use the following phrase:

	vplay the sound of Beep

(Note that "vplay" is for "virtual play".)

We can also play a sound on a virtual channel with a set volume:

	vplay the sound of Beep with 50% volume
	vplay the sound of Beep with global volume

All virtual channels share a single volume level. The virtual channel volume level is usually the same as the global volume, unless explicitly changed by the programmer (see the "phrases of Damusix" section in the "Index > Phrases" tab).

A few restrictions exist in the use of virtual channels:

	1) The sounds cannot be set to loop or play more than one time

	2) The sounds do not generate notification events when they are through playing

	3) The rest of the functionality described above for normal channels cannot be used in virtual channels


Section: Using the Damusix Playlist

Another useful function of Damusix is its "playlist." Imagine we have a series of sounds that represent a cannon attack on a pirate ship and its later destruction. We might have defined a sound for "cannon fuse igniting," another for "cannon fire," and another for "destruction of the enemy ship." We could create and play all these sounds individually, but the more natural thing is to consider them one "playlist" of sounds that should be played back in a specific order, one by one.

For these situations, Damusix implements a "playlist." Use of the playlist is simple. As with virtual channels, sounds added to the playlist do not need to be assigned to channels beforehand.

We'll continue with the example of the attack on the pirate ship to demonstrate the playlist in action:

	*: "The Sunken Ship"

	Include Damusix Sound Manager by Eliuk Blau.

	Sound of Fuse is the file "fuse.ogg".
	Sound of Firing is the file "boom.ogg".
	Sound of Sinking is the file "sinking.ogg".

	When play begins:
		add the sound of Fuse to the playlist with a time of 5000 ms;
		add the sound of Firing to the playlist with a time of 1000 ms;
		add the sound of Firing to the playlist with a time of 1000 ms;
		add the sound of Sinking to the playlist with a time of 3500 ms;
		dplay the playlist.

	Blast Zone is a room. "Let's give these dogs a taste of the cannons of Spain!"

Each of the four "add" phrases adds a new sound to the playlist, each time appending it to the end of the list; they will later be played back in the same order. In addition, we must give each sound a duration in milliseconds; since no notification events are generated for the playback of these sounds, we need to explicitly tell the Manager when to play the next one.

We've now created a playlist with 4 items. There is space for 10 items in the playlist. Attempts to add sounds to a full playlist will silently fail (although compiling with DEBUG will generate a message indicating what has happened).

The phrase "dplay the playlist" above begins playing back our playlist, playing each sound in the order we added them and waiting for the duration indicated before playing the next sound. After the last sound in the playlist is created, Damusix automatically clears the playlist of all contents, leaving it empty and ready for its next usage. Attempts to dplay an empty playlist produce no result, nor do they cause any error.

As with other sounds, we can start the playlist playing at a certain volume level:

	dplay the playlist with with 50% volume
	dplay the playlist with global volume

The playlist has a single volume level that works the same way as the virtual channel volume level (see above).

If we want to manually clear the contents of the playlist, we can write:

	clear the playlist

This happens by default after a playlist is finished playing, but the phrase is available if we need to do it by hand for any reason.


Section: Enabling and Disabling Audio

The Damusix Manager can enable and disable all audio independently from the way it handles playback or volume. This is useful in that we can turn audio on and off without worry about resetting the proper volume levels or playback status for each specific channel of sound.

If audio is globally disabled, all phrases to control the Damusix Manager continue working normally, but no further sounds are actually played. Playback of audio will continue programmatically behind the scenes, but no audio will actually be heard by the user. So, for instance, if you disabled audio, started a sound fading in, then enabled audio again halfway through, you would hear the sound suddenly start playing at 50% volume and then fade the rest of the way in. (For more on fading, see the next section.)

An advantage of this approach is that you need never write verification code for specific sounds to check whether audio is on or off: the Damusix Manager deals with that on a global level.

The following two phrases control the status of global audio:

	enable audio
	disable audio

Additionally, we can also test the present state of global audio:

	if audio is enabled...
	if audio is disabled...


Section: Other Useful Phrases

To change the global volume:

	change the global volume to 50%

... This phrase sets the volume of all sounds set to global volume, as well as the virtual channel volume and the playlist volume. Remember that all sounds without an explicitly defined volume will use the global volume. It is also worth noting that we cannot "change the global volume to the global volume" since this doesn't make sense.

To halt the playback of all sounds:

	dstop all sounds

... This immediately stops playback of all sounds without exception: everything playing on a normal channel, a virtual channel, or the playlist.

To stop only the sounds that aren't assigned to channels:

	dstop the extra channels

... This stops playback of all sounds in virtual channels and the playlist. Sounds explicitly assigned to normal channels will be unchanged.

To test whether a specific sound is currently playing:***

	if the sound of Beep is playing in the background...
	if the sound of Beep is not playing in the background...

"Playing in the background" means that this sound's repetition value is set to "endless loop." These phrases are useful to make sure we only start playing some sound (say, a piece of background music) if it is not playing already. For example, we could define a rule as follows:

	*: To background music play (SND - sound-name):
		if SND is not playing in the background:
			assign SND to channel 0, endless loop;
			dplay SND.


Section: Real Time Fade Effects

Damusix can apply a fade-in or fade-out effect to any normal channel. Fade-in gradually raises the volume of the channel from its present value to the given final value, while fade-out naturally does the opposite.

These effects are "real-time" because the game continues execution while the fades are being carried out: the player can continue issuing commands and the game advancing during the fade.

The fade effects work even if the player uses the UNDO/RESTORE/RESTART commands. If a game is saved while a fade is in progress, the fade's present state is saved; when the game is restored, the fade will continue correctly from the proper point. This also works in the case of UNDO.

The only exception is if a fade is happening on a sound that is NOT set to "endless loop" (i.e. a finite number of repetitions). In this case the fade is intentionally not recovered, because due to technical reasons Damusix is forced to restart sounds that are not playing on an endless loop after an UNDO/RESTORE. Because of this, it is recommended not to use fades on sounds that are not looping.

Other than the above exception, the fade effects work very well and have been exhaustively tested. You can use them without fear of causing crashes or other non-recoverable errors. Before any unexpected situation, the Manager will abort the fade rather than risk crashing the interpreter.

Before using the real-time fade effects, two important points: 1) only one fade effect can be in progress at a time, and 2) a Glulx interpreter playing your game must support real-time effects (Glk Timer Events). If a fade is attempted in an interpreter that does not support Timer Events, it will silently fail. (Again, this will cause no errors; the fade will just simply not happen.)

Here are some examples of how to use the real-time fading phrases:

	fade in the sound of Beep to 50% volume over 5000 ms
	fade in the sound of Beep to global volume over 5000 ms

	... and again, if we do not specify a volume then "global volume" is assumed, so the third phrase below is equivalent to the second phrase:

	fade in the sound of Beep over 5000 ms

5000 ms (milliseconds) is equal to five seconds. The minimum time duration for a fade is 100 ms.

To fade out, a similar phrase is used:

	fade out the sound of Beep to 25% volume over 5000 ms
	fade out the sound of Beep to 0% volume over 5000 ms

	... or...

	fade out the sound of Beep over 5000 ms

Again, real-time fading only works with normal channels, and only ones that are currently being played. For example:

	dplay the sound of Beep;
	fade out the sound of Beep over 5000 ms;

Sometimes, we want to play another sound immediately after a sound has finished fading out. For that purpose, we can use a slightly more complex version of the above phrase:

	fade out the sound of Intro over 3000 ms and then dplay the sound of Melody
	fade out the sound of Intro over 3000 ms and then dplay the sound of Melody, notifying when finished

... the extra bit here is "and then dplay". When the fade-out finishes (in this case, when the volume of the sound arrives at 0%) then the sound of Melody would begin to play. We can optionally indicate that the new sound should issue a notification event when it finishes, via the second phrase.

Two more useful routines for real-time fading in Damusix...

The fade effects are a little abusive of Glk's Timer. They occupy it completely for their duration, and would fail if the Timer is reprogrammed to some code foreign to Damusix while the effect is in progress. Other extensions exist that use Timer Events for their own purposes; even the Inform library provides routines for using the Timer. Damusix cannot anticipate these situations, but it provides a method of testing whether its own routines are using the Timer:

	if fading is in progress...
	if fading is not in progress...

... these two phrases verify whether a fade effect is currently happening. If we had any code that used the Timer for its own purposes, we could modify it to check with this phrase whether any fades were happening, to avoid spoiling our fade.

On the other hand:

	abort the fading

... immediately halts any real-time fade in progress. If a fade-in is aborted, the sound's volume is immediately set to the final level specified in the fade command. If a fade-out is aborted, one of two things can happen: 1) if the fade specified a final volume greater than 0%, the sound's volume is immediately adjusted to that; 2) otherwise the sound stops playing. If this phrase is called when no real-time fades are in progress, it simply does nothing.

	NOTE: The Damusix Manager deals with other conflicts between issues commands and the current state of real-time fades: for instance, if a sound's volume is changed during a fade, the Manager will automatically abort the fade and set the sound to the instructed volume.


Section: Fade Effects Not in Real Time (Simple Fades)

Damusix provides an alternative to real-time fades that we can use if we can't risk mingling Damusix's control of the Glk Timer with other extensions or our own code. These are called "simple fades" and they are much simpler and easy to use than real-time fades. Using simple fades avoids the need to make verifications like "if fading is in progress".

A simple fade pauses execution of the rest of the game while the fade is in progress, only resuming once it has completed. For this reason it's likely to be most useful for fade effects with short durations. In fact, these fades can have durations less than 100 ms.

Since simple fades are not real-time, they cannot be aborted, nor is it possible to verify whether a simple fade is in progress. (Neither command could be reached while the fade is still happening.) Therefore we need only two phrases to control them:

	For a simple fade-in:

	... with an explicit final volume...
	simple fade in the sound of Beep to 75% volume over 5000 ms

	... with the global volume...
	simple fade in the sound of Beep to global volume over 5000 ms

	... or the shorter version of the above phrase...
	simple fade in the sound of Beep over 5000 ms

	And for a simple fade-out:

	... with an explicit final volume...
	simple fade out the sound of Beep to 25% volume over 5000 ms

	... to fade a sound completely to silence...
	simple fade out the sound of Beep to 0% volume over 5000 ms

	... or a shorter version of the above phrase...
	simple fade out the sound of Beep over 5000 ms

These work just as they do for real-time fades, except that simple fade outs cannot start another sound playing upon completion, and do not stop the sound playing when the volume reaches 0%. Since the execution of code continues immediately after the fade out concludes, we can simply stop the sound ourselves on the next line, or start playing another sound there too.

Let's give a quick example using simple fades:

	*: assign the sound of Melody to channel 0 with 100% volume, endless loop;

	say "Doing a SimpleFadeOut...[line break]";
	simple fade out the sound of Melody to 50% volume over 500 ms;

	say "Doing a SimpleFadeIn...[line break]";
	simple fade in the sound of Melody to 100% volume over 500 ms;

	say "Doing a SimpleFadeOut...[line break]";
	simple fade out the sound of Melody to 0% volume over 1000 ms;

	say "Stopping the Music...[line break]";
	dstop the sound of Melody;

This simple example starts playing the sound of Melody at 100% volume; lowers that volume to 50% over half a second, raises it back to 100% over another half-second, then lowers to 0% volume over one full second. The sound then is stopped.


Section: Technical Functions and Audio Information Functions

The Damusix Manager has several other tools useful for authors.

First, it provides a suite of phrases grouped in the code under "Technical Functions". These provide the same abilities as the phrases to work with normal channels, but are keyed by channel, not by sound-name. To use them, we indicate the number of the channel we wish to apply that phrase to. By convention, these phrases are identical to their above counterparts, except the word "sound" should be replaced with "channel".

For instance, for the phrase "dplay the sound of Beep", the counterpart phrase would be "dplay channel 1".

These phrases are not all fully documented here, but can be seen in the Phrases tab of the Index pane, under "Damusix Phrases."

Secondly, Damusix provides a suite of "Audio Information Functions". These are designed to return information on the state of the Damusix Manager and its channels.

For instance, we could discover the present volume of a sound with the phrase "the volume of the sound of Beep". Again, a counterpart channel-based phrase also exists: "the volume of channel 1".

Again, these phrases are not all detailed here, but can be seen in the Index pane.

	SPECIAL NOTE ON REPETITIONS: If requesting the repetition count of a sound with infinite repetitions (defined with "endless loop"), the value returned is -1.


Section: Protecting Sounds after UNDO/RESTORE

Damusix automatically deals with changes in the sound state after an UNDO or RESTORE command. For technical reasons, the layout of Glk audio channels must be recreated whenever either of these commands are issued, and any sounds playing in them restarted, because otherwise the programmer loses controls over the existing channels.

This is not the ideal behavior since, for example, if we were playing a piece of background music and type UNDO, the music would have to start playing from the beginning again. If we use UNDO often, this behavior becomes very annoying.

Damusix is the first extension for Glulx audio that incorporates a mechanism to avoid this problem when changing game states. The Manager uses a complex system of verifications to determine if it needs to restart a sound that was playing at the time of an UNDO or RESTORE. If a sound with "endless loop" is playing at the moment the command is issued, and that same sound was playing at the same state at the moment the prior command was issued, Damusix is able to recover control of that channel and does not need to restart the sound.

Internally, the extension uses for these purposes a call to a special Glulx assember opcode: @protect. This call only works in interpreters that support the COMPLETE Glulx spec (such as Windows Glulxe, and the current version of Gargoyle). However, in interpreters which do not implement this opcode it is possible that the mechanism will fail. For example, Git implements a very fast Glulx, but does so by omitting certain features of the Glulx spec which are not normally used in Inform games. Unfortunately, @protect appears to be one of them; running Damusix in Git produces unstable behavior and non-recoverable hangs or crashes.

To deal with non-standard interpreters, Damusix provides a use option that will disable the sound protection functionality. In this case, sounds will always be restarted after a RESTORE/UNDO:

	Use no sound protection.

Thus it would be possible to release a seperate version of your game customized for non-standard interpreters. However, the author (and translator) encourage authors to avoid this method; the more people avoid this line, the more motivation interpreter authors will have to update their programs to use the full capabilities of the Glulx spec. (Just a little bit of friendly pressure.)


Section: Epilogue

	If you've made it to here, you've successfully finished the audacious and laborious adventure of reading this extensive documentation comnpletely.

	*** You Have Won ***
