import pandas as pd
import numpy as np

# Set the random seed for reproducibility
np.random.seed(42)

# Parameters
total_time = 2400  # total duration in seconds
time_step = 15  # time step in seconds
time_points = np.arange(0, total_time, time_step)

# Create synthetic heart rate and walking rate data
# Heart rate ranges
resting_hr = 50  # bpm
walking_hr = 80  # bpm
running_hr = 140  # bpm

# Walking rate ranges
resting_wr = 0  # steps per minute
walking_wr = 80  # steps per minute
running_wr = 160  # steps per minute

# Transition points
resting_time = 200
walking_time = 300

# Initialize lists for heart rate and walking rate
heart_rate = []
walking_rate = []

for t in time_points:
    if t < resting_time:
        hr = resting_hr + np.random.normal(0, 1)
        wr = resting_wr + np.random.normal(0, 1)
    elif t < resting_time + walking_time:
        progress = (t - resting_time) / walking_time
        hr = resting_hr + (walking_hr - resting_hr) * progress + np.random.normal(0, 2)
        wr = resting_wr + (walking_wr - resting_wr) * progress + np.random.normal(0, 2)
    else:
        progress = (t - (resting_time + walking_time)) / (total_time - resting_time - walking_time)
        hr = walking_hr + (running_hr - walking_hr) * progress + np.random.normal(0, 2)
        wr = walking_wr + (running_wr - walking_wr) * progress + np.random.normal(0, 2)
    
    heart_rate.append(hr)
    walking_rate.append(wr)

# Create DataFrame
data = {
    'HeartRate': heart_rate,
    'WalkingRate': walking_rate
}
df = pd.DataFrame(data)

# Save to CSV
csv_path = './data.csv'
df.to_csv(csv_path, index=False)

csv_path
