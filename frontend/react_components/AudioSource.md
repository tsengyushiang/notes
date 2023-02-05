# AudioSrc

```javascript
const AudioSrc = ({ src, onStop }) => {
  const audioRef = useRef(null);
  useEffect(() => {
    const audioElement = audioRef.current;
    audioElement.load();
    audioElement.addEventListener("canplaythrough", audioElement.play);
    audioElement.addEventListener("ended", onStop);
  }, []);
  return <audio src={src} ref={audioRef} />;
};

// usage
const AudioPlay = ({ isPlaying, src, stop }) => {
    return (
        {!!isPlaying && <AudioSrc src={src} onStop={stop}/>}
    )
}
```