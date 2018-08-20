# Signals and systems software project
A modular matlab program containing a set of experiments + a time domain signal generator module (time domain manual tracing), i wrote the signal generator and experiment 3:

- [signal_gen.m] : generates the input time-base signal piece-by-piece interactively from user choices. DC, Ramp, exponential and sinusoidal signals can be added sequentially.
- [exp1.m] : frequency and time domain plots of the generated signal.
- [exp2.m] : creating a system using its impulse response, which is also generated with signal_gen, also convoluting the input signal with the system's impulse response to acquire the output signal in both f and t domains, and adding noise to that signal.
- [exp3.m] : simulates a channel response effect on the propagating signal using the difference equation, plots the channel system's f and impulse responses and also the f and t responses of the output signal, then constructs a recovery system (the inverse of the channel system given by the difference equation's coefficients) and plots the final output signal of the whole system.
- [exp4.m] : a sound processing experiment, reads an input raw sound file, then plots it in both t and f domains, then constructs a simple system with two impulses to demonstrate the impulse effect on the signal (duplicates it with a delay or echo).



[exp1.m]: <./exp1.m>
[exp2.m]: <./exp2.m>
[exp3.m]: <./exp3.m>
[exp4.m]: <./exp4.m>
[signal_gen.m]: <./signal_gen.m>
