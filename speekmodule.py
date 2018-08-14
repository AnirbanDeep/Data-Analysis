from gtts import gTTS
import random
import os

def speek(rand,n,mixer):
	tts = gTTS(text = random.choice(rand), lang = 'en')
	tts.save('jarvis' + str(n) + '.mp3')
	mixer.init()
	mixer.music.load('jarvis' + str(n) + '.mp3')
	mixer.music.play()