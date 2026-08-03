:- module(concert_model, [
    supported_sound_mode/1
]).

supported_sound_mode(headphones).
supported_sound_mode(directional_speakers).
supported_sound_mode(low_volume_speakers).
supported_sound_mode(haptic_audio).
supported_sound_mode(streamed_audio).
supported_sound_mode(fully_simulated_audio).
supported_sound_mode(silent_visual_performance).
supported_sound_mode(mixed_reality_audio).

