import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.tree import DecisionTreeClassifier
from sklearn.preprocessing import StandardScaler
from sklearn.pipeline import make_pipeline
import joblib

# Load your dataset
data = pd.read_csv('ML-Model/activity_data.csv')
X = data[['HeartRate', 'WalkingRate']]
y = data['Activity']  # Ensure 'Activity' column has labels (e.g., 0: Resting, 1: Walking, etc.)

# Split the dataset
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Create a pipeline with scaling and decision tree
pipeline = make_pipeline(StandardScaler(), DecisionTreeClassifier())

# Train the model
pipeline.fit(X_train, y_train)

# Save the trained model
joblib.dump(pipeline, 'decision_tree_model.pkl')

print("Decision Tree model trained and saved.")
