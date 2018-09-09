/* marwan nabil */
FS = 8000; // sampling rate is given and = 8 kHZ


/*		capturing user inputs		*/

users = input("how many users you want to multiplex ? >");
duration = input("\ncapture duration in seconds >");
samples = [1,duration*FS];  // sampling array required by audioread(), captures (duration) seconds of audio

// initialising the records array
raw_records(users,duration*FS) = 0; 	// rows represent users, each row should have the sampled audio from each user

f=0; // we'll not use it
for i=1:users
	sprintf("\nenter the name of the mp3 file of user (%d)",i);
	filename = input("> ");
    [raw_records(i),f] = audioread(filename,samples);  // resulting samples are doubles
end
// raw_records now has all sampled user audios but the samples are still normalised doubles in range (-1.0:1.0)

/*		quantizing : converting from doubles to bytes		*/
levels = linspace(-1,1,256);	// quantization levels vector

quantized_records(users,duration*FS)=0;

for i=1:users
	quantized_records(i)= quantiz(raw_records(i),levels);
	
end
// quantized_records now has all sampled user audios one byte/sample

/*		coding: converting to binary		*/

tdm_records = reshape(de2bi(quantized_records(i)),);

end


