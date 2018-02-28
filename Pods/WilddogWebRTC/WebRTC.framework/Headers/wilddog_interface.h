

#ifndef WildDog_Interface_H
#define WildDog_Interface_H

#define WDG_EXPORT __attribute__((visibility("default")))

namespace WildDog
{
    
    class MediaCallback
	{
	public:

        WDG_EXPORT
		virtual void on_audio_local(const void* audio_data, const size_t number_of_frames, const size_t bytes_per_sample, const size_t number_of_channels, const uint32_t sample_rate) = 0;
        WDG_EXPORT
		virtual void on_audio_remote(const size_t nSamples, const size_t nBytesPerSample, const size_t nChannels, void* audioSamples) = 0;
        WDG_EXPORT
        virtual ~MediaCallback(){}
	};

    
	WDG_EXPORT
    void set_MediaCallback(WildDog::MediaCallback * pMediaCallback);




    class MessageFromWebrtcCallback
	{
	public:

        WDG_EXPORT
		virtual void on_log(char * strLog, int nStrLen ) = 0;
        WDG_EXPORT
        virtual ~MessageFromWebrtcCallback(){}

	};



	WDG_EXPORT
    void set_MessageFromWebrtcCallback(MessageFromWebrtcCallback * pMessageFromWebrtcCallback);
}

#endif
