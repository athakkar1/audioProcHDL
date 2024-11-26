import numpy as np

x = np.linspace(0, 2 * np.pi, 4096, endpoint=False)
sine_wave = np.sin(x)

# Scale the combined sine wave to the range [0, 4095]
scaled_sine_wave = sine_wave * 10388608/2

# Convert to integer values
scaled_sine_wave = scaled_sine_wave.astype(int)

# Save to a text file
with open('num.txt', 'w') as f:
    for value in scaled_sine_wave:
        f.write(f"{value}\n")

print("Sine wave data saved to 'sine_wave.txt'")
