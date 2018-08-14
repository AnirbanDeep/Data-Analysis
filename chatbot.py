import pyaudio
from pygame import mixer
import speekmodule
from gtts import gTTS
import speech_recognition as sr
i = 0
n = 0
while(i < 1):
	r = sr.Recognizer()
	with sr.Microphone() as source:
		audio = r.adjust_for_ambient_noise(source)
		n = (n + 1)
		print("Say something")
		audio = r.listen(source)
	try:
		s = (r.recognize_google(audio))
		message = (s.lower())
		print(message)
		
		if('hello') in message or ('hi') in message or ('hey') in message:
			rand = ['welcome Mister Chatterjee.']
			speekmodule.speek(rand,n,mixer)


		elif('how are you') in message or ('whats good') in message or ('wassup') in message:
			rand = ['i am fine sir.']
			speekmodule.speek(rand,n,mixer)	
			
		elif('quit') in message or ('shut down') in message or ('exit') in message:
			rand = ['ok sir, bye bye.']
			speekmodule.speek(rand,n,mixer)	
			exit()

	except sr.UnknownValueError:
		print("Could not understand audio.")
	except sr.RequestError as e:
		print("Could not request result; {0}".format(e))
