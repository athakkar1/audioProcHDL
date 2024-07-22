import numpy as np

# Constants
sampling_rate = 1024  # Sampling rate
num_samples = 1024  # Number of samples
frequency1 = 1000  # Frequency of the first sine wave (Hz)
frequency2 = 2000  # Frequency of the second sine wave (Hz)
period1 = 1 / frequency1  # Time period of the first sine wave (seconds)

# Generate time vector from 0 to 1/frequency1 with 1024 samples
time = np.linspace(0, period1, num_samples, endpoint=False)
# Generate sine waves
sine_wave1 = np.sin(2 * np.pi * frequency1 * time)
sine_wave2 = np.sin(2 * np.pi * frequency2 * time)

# Combine the two sine waves
combined_sine_wave = sine_wave1 + sine_wave2

# Scale the combined sine wave to the range [0, 4095]
scaled_sine_wave = ((combined_sine_wave - np.min(combined_sine_wave)) / 
                    (np.max(combined_sine_wave) - np.min(combined_sine_wave))) * 4095

# Convert to integer values
scaled_sine_wave = scaled_sine_wave.astype(int)

# Save to a text file
with open('sine_wave.txt', 'w') as f:
    for value in scaled_sine_wave:
        f.write(f"{value}\n")

print("Sine wave data saved to 'sine_wave.txt'")
