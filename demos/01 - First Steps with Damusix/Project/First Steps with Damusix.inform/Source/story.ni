"First Steps with Damusix" by Eliuk Blau.

The story headline is "A quick and dirty demo of Damusix Sound Manager".
Use full-length room descriptions.

[------------------------------------------------------------------------------]

Include Damusix Sound Manager by Eliuk Blau.
Include Glulx Entry Points by Emily Short.

[------------------------------------------------------------------------------]

Sound of Intro is the file "fxintro.ogg".
Sound of Music is the file "bgmusic.mod".
Sound of Beep is the file "fxbeep.aiff".
Sound of Virtual is the file "fxvirtual.ogg".

Sound of Playlist-1 is the file "fxlist1.ogg".
Sound of Playlist-2 is the file "fxlist2.ogg".
Sound of Playlist-3 is the file "fxlist3.ogg".
Sound of Playlist-4 is the file "fxlist4.ogg".
Sound of Playlist-5 is the file "fxlist5.ogg".

[------------------------------------------------------------------------------]

Understand "beep" as do-beep-demo.
Do-beep-demo is an action applying to nothing.
Carry out do-beep-demo:
	say "Beep Beep! :D[paragraph break]";
	assign the sound of Beep to channel 1;
	dplay the sound of Beep.

[------------------------------------------------------------------------------]

Understand "virtual" as do-virtual-demo.
Do-virtual-demo is an action applying to nothing.
Carry out do-virtual-demo:
	say "If you try to do it quickly, all sounds overlap thanks to the virtual channel :P[paragraph break]";
	vplay the sound of Virtual.

[------------------------------------------------------------------------------]

Table of Playlist
item		duration
sound of Playlist-1		1000
sound of Playlist-2		1000
sound of Playlist-3		1000
sound of Playlist-4		1000
sound of Playlist-5		1000

Understand "playlist" as do-playlist-demo.
Do-playlist-demo is an action applying to nothing.
Carry out do-playlist-demo:
	say "Run playlist in random order! :D[paragraph break]";
	[
		let playlist-items be {Sound of Playlist-1, Sound of Playlist-2, Sound of Playlist-3, Sound of Playlist-4, Sound of Playlist-5};
		sort playlist-items in random order;
		repeat with playlist-item running through playlist-items:
			add playlist-item to the playlist with a time of 1000 ms;
	]
	sort the table of Playlist in random order;
	repeat through the table of Playlist:
		add item entry to the playlist with a time of duration entry ms;
		say "Item: [item entry] - Duration: [duration entry]ms[line break]";
	dplay the playlist.

[------------------------------------------------------------------------------]

When play begins:
	assign the sound of Intro to channel 9;
	dplay the sound of Intro, notifying when finished;
	now the command prompt is "[fixed letter spacing]|DAMUSIX v[damusix-version]|>[variable letter spacing] ".

A glulx sound notification rule (this is the start game music rule):
	assign the sound of Music to channel 0 with 50% volume, endless loop;
	dplay the sound of Music.

[------------------------------------------------------------------------------]

Musical Zone is a room.
"Commands:
[line break]    - [fixed letter spacing][quotation mark]beep[quotation mark][variable letter spacing] to play a sound on a normal channel
[line break]    - [fixed letter spacing][quotation mark]virtual[quotation mark][variable letter spacing] to play a sound on the virtual channel (try it repeatedly!)
[line break]    - [fixed letter spacing][quotation mark]playlist[quotation mark][variable letter spacing] to start the playlist
[paragraph break]More commands are coming... Stay tuned!"
