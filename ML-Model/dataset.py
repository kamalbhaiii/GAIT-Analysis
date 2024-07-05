import pandas as pd
import numpy as np

# Define activity ranges
activity_ranges = {
    'Sedentary': {'HeartRate': (40, 60), 'WalkingRate': (0, 90)},
    'Light Walking': {'HeartRate': (60, 120), 'WalkingRate': (90, 110)},
    'Brisk Walking': {'HeartRate': (120, 140), 'WalkingRate': (110, 130)},
    'Jogging': {'HeartRate': (140, 160), 'WalkingRate': (130, 140)},
    'Running': {'HeartRate': (160, 180), 'WalkingRate': (140, 160)},
    'High-Intensity Running/Sprinting': {'HeartRate': (180, 200), 'WalkingRate': (160, 180)}
}

# Number of samples per activity
samples_per_activity = 500

# Function to generate data
def generate_data(activity_name, heart_rate_range, walking_rate_range, num_samples):
    heart_rates = np.random.randint(heart_rate_range[0], heart_rate_range[1], num_samples)
    walking_rates = np.random.randint(walking_rate_range[0], walking_rate_range[1], num_samples)
    activities = [activity_name] * num_samples
    return pd.DataFrame({'HeartRate': heart_rates, 'WalkingRate': walking_rates, 'Activity': activities})

# Generate data for each activity
data_frames = []
for activity, ranges in activity_ranges.items():
    df = generate_data(activity, ranges['HeartRate'], ranges['WalkingRate'], samples_per_activity)
    data_frames.append(df)

# Concatenate all data frames
full_data = pd.concat(data_frames, ignore_index=True)

# Shuffle the data to ensure randomness
shuffled_data = full_data.sample(frac=1).reset_index(drop=True)

# Save to CSV
shuffled_data.to_csv('activity_data.csv', index=False)

print(f"Data successfully generated, shuffled, and saved to 'activity_data.csv'.")
