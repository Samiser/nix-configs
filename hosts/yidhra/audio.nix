_: {
  services.pipewire.extraConfig.pipewire."10-mic-input1-mono"."context.modules" = [
    {
      name = "libpipewire-module-loopback";
      args = {
        "node.description" = "Mic (Input 1 mono)";
        "capture.props" = {
          "node.name" = "capture.mic_input1";
          "media.class" = "Stream/Input/Audio";
          "target.object" = "alsa_input.usb-Focusrite_Scarlett_8i6_USB_F854AKF1A0C0FC-00.pro-input-0";
          "audio.position" = [ "AUX0" ];
          "stream.dont-remix" = true;
        };
        "playback.props" = {
          "node.name" = "mic_input1";
          "node.description" = "Mic (Input 1 mono)";
          "media.class" = "Audio/Source";
          "audio.position" = [ "MONO" ];
        };
      };
    }
  ];
}
