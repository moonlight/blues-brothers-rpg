/*
    The Moonlight Engine - An extendable, portable, RPG-focused game engine.
    Project Home: http://moeng.sourceforge.net/
    Copyright (C) 2003  Bjørn Lindeijer

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.
*/



#include <allegro.h>
#include "shared/console.h"
#include "sound.h"
#include "rpg.h"
#include "script.h"
#include "common.h"

#ifdef ENABLE_MUSIC
#include <alogg/alogg.h>
#endif


int sound_enabled = 1;
int sfx_enabled = 1;

#ifdef ENABLE_MUSIC
// Currently playing OGG file
struct {
	SAMPLE *sample;
	int voice;
	struct alogg_stream *stream;
	AUDIOSTREAM *ass;
	char filename[128];
} channels[CHANNELS];
#endif

char *error;



void init_sound() {
	// Read config variables
	//ChunkSize = (get_config_int("Sound", "StreamChunkSize", 1<<15));
	//BufferSize = (get_config_int("Sound", "BufferSize", 1<<16));

	// To achieve the max possible volume
	set_volume_per_voice(0);

	// Initialize alogg
#ifdef ENABLE_MUSIC
	alogg_init();
#endif

	// Install sound driver
	if (install_sound(DIGI_AUTODETECT, MIDI_NONE, NULL) != 0) {
		console.log(CON_LOG, CON_ALWAYS, "Error initialising sound system: %s", allegro_error);
		return;
	}

#ifdef ENABLE_MUSIC
	// Initialize channels to NULL
	for (int i = 0; i < CHANNELS; i++) {
		channels[i].voice = 0;
		channels[i].sample = NULL;
		channels[i].stream = NULL;
		channels[i].ass = NULL;
	}
#endif
}


#ifdef ENABLE_MUSIC

/* play_music(filename, channel)
 */
int l_play_music(lua_State *L)
{
	char* filename;
	int channel;
	getLuaArguments(L, "si", &filename, &channel);

	error = NULL;

	if (sound_enabled) {
		// Stop currently playing music
		stop_music(channel);

		if (channel < 0 || channel > CHANNELS) {error = "invalid channel";}
		else if (!exists(filename)) {error = "file does not exist";}
		
		if (error == NULL) {
			/*
			channels[channel].sample = alogg_load_ogg(filename);
			if (!channels[channel].sample) {
				fprintf(stderr,"Error loading %s (%d)\n", filename, alogg_error_code);
				alogg_exit();
				exit(1);
			}
			*/
			strncpy(channels[channel].filename, filename, 128);
			channels[channel].stream = alogg_start_streaming(channels[channel].filename, BLOCK_SIZE);
			if (!channels[channel].stream) {
				fprintf(stderr,"Error opening %s\n", filename);
				alogg_exit();
				exit(1);
			}
			channels[channel].ass = alogg_get_audio_stream(channels[channel].stream);
		}

		/*
		channels[channel].voice = allocate_voice(channels[channel].sample);
		if (channels[channel].voice == -1) {
			error = "unable to allocate a voice";
		}
		*/

		if (error == NULL) {
			/*
			voice_start(channels[channel].voice);
			release_voice(channels[channel].voice);
			channels[channel].voice = 0;
			channels[channel].sample = NULL;
			*/
			console.log(CON_LOG | CON_CONSOLE, CON_ALWAYS, "Playing OGG file (%s)", filename);
		}
		else {
			console.log(CON_LOG | CON_CONSOLE, CON_ALWAYS, "Error playing OGG file \"%s\" (%s)", filename, error);
		}
	}

	return 0;
}

/* adjust_channel(channel, volume, panning, speed)
 */
int l_adjust_channel(lua_State *L)
{
	int channel, vol, pan, speed;
	getLuaArguments(L, "iiii", &channel, &vol, &pan, &speed);

	error = NULL;

	if (sound_enabled) {
		if (channel < 0 || channel > CHANNELS) {error = "invalid channel";}
		else if (!channels[channel].ass) {error = "no music on this channel to adjust";}
		else if (vol < 0 || vol > 255) {error = "illegal volume value";}
		else if (pan < 0 || pan > 255) {error = "illegal panning value";}
		else if (speed < 0) {error = "illegal speed value";}

		if (error == NULL) {
			voice_set_volume(channels[channel].ass->voice, vol);
			//alogg_adjust_oggstream(ogg[channel]->s, vol, pan, speed);
			//console.log(CON_LOG | CON_CONSOLE, CON_ALWAYS, "Adjusted channel parameters (%d, %d, %d, %d)", channel, vol, pan, speed);
		} else {
			console.log(CON_LOG | CON_CONSOLE, CON_ALWAYS, "Error adjusting channel parameters (%s)", error);
		}
	}

	return 0;
}

/* get_number_of_channels()
 */
int l_get_number_of_channels(lua_State *L)
{
	return putLuaArguments(L, "i", CHANNELS);
}


void poll_sound()
{
	for (int i = 0; i < CHANNELS; i++) {
		if (channels[i].stream) {
			int ret = alogg_update_streaming(channels[i].stream);
			if (ret == 0) {
				// Loop song
				stop_music(i);
				channels[i].stream = alogg_start_streaming(channels[i].filename, BLOCK_SIZE);
				if (!channels[i].stream) {
					fprintf(stderr,"Error opening %s\n", channels[i].filename);
					alogg_exit();
					exit(1);
				}
				channels[i].ass = alogg_get_audio_stream(channels[i].stream);
				break;
			}
		}
	}
}

void stop_music(int channel)
{
	/*
	if (channels[channel].voice) {
		deallocate_voice(channels[channel].voice);
		destroy_sample(channels[channel].sample);
		channels[channel].voice = 0;
		channels[channel].sample = NULL;
	}
	*/
	if (channels[channel].stream) {
		alogg_stop_streaming(channels[channel].stream);
		channels[channel].stream = NULL;
		channels[channel].ass = NULL;
	}
}


/* stop_music(channel)
 */
int l_stop_music(lua_State *L)
{
	int channel;
	getLuaArguments(L, "i", &channel);

	error = NULL;
	if (channel < 0 || channel >= CHANNELS) {error = "invalid channel";}

	if (error == NULL) {
		stop_music(channel);
	} else {
		console.log(CON_LOG | CON_CONSOLE, CON_ALWAYS, "Error stopping music (%s)", error);
	}
	return 0;
}

#endif


/* play_sample(filename)
 */
int l_play_sample(lua_State *L)
{
	char* name;
	getLuaArguments(L, "s", &name);

	if (sfx_enabled) {
		console.log(CON_LOG, CON_ALWAYS, "Trying to play sample: %s", name);

		DATAFILE *found_object = find_datafile_object(bitmap_data, name);

		if (found_object) {
			//int play_sample(const SAMPLE *spl, int vol, int pan, int freq, int loop);
			play_sample((SAMPLE*)found_object->dat, 255, 128, 1000, 0);
		} else {
			return luaL_error(L, "Error: Cannot find requested sample (%s)!", name);
		}
	}

	return 0;
}

void exit_sound()
{
#ifdef ENABLE_MUSIC
	for (int i = 0; i < CHANNELS; i++) {
		stop_music(i);
	}

	alogg_exit();
#endif
}
